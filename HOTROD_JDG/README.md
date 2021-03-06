# HOTROD SESSION MANAGEMENT

Demonstrates how to run a 2 nodes WildFly cluster using an remote cache for webapps, backed by a 2 nodes Infinispan Server cluster.
The peculiarity of this configuration is that a particular HotRod session manager is used;
This HotRod session manager talks directly to the Infinispan Server cluster through HotRod client.

The priority for determining the session-management configuration to use for <distributable/> applications is as follows:

 * Use the legacy configuration from jboss-web.xml if it defines a <replication-config/>
 * If a distributable-web deployment descriptor namespace was specified (either via distributable-web.xml or jboss-all.xml):
 * Use the named configuration defined by the deployment descriptor
 * Use the adhoc configuration defined by the deployment descriptor
 * Use a session-management configuration whose name matches the name of the undertow server associated with the deployment, if one exists
 * Otherwise use the configuration identified by the default-session-management.


> NOTE: You have to use Infinispan Server newer or equal to [infinispan-server-10.0.0](http://downloads.jboss.org/infinispan/10.0.0.Beta3/infinispan-server-10.0.0.Beta3.zip)

## Intro

A new new distributed session manager implementation `org.wildfly.clustering.web.hotrod.session.HotRodSessionManager` has been added to WildFly
(see [WFLY-7719](https://issues.jboss.org/browse/WFLY-7719)).

This HotRod session manager talks directly to the Infinispan Server cluster through the HotRod client (`org.infinispan:infinispan-client-hotrod`)
provided by Infinispan.

With this new session manager it's possible to offload session data (or/and sso data) without even caching a copy on the WildFLy node.

Two new configurations elements have been added to the `distributable-web` element:

 * `hotrod-session-management`
 * `hotrod-single-sign-on-management`

Here is the updated list of options we have now in the `distributable-web` element:

```
<subsystem xmlns="urn:jboss:domain:distributable-web:1.0" default-session-management="session" default-single-sign-on-management="default">
    <infinispan-session-management name="session" cache-container="foo" granularity="SESSION">
        <primary-owner-affinity/>
    </infinispan-session-management>
    <infinispan-session-management name="attribute" cache-container="foo" cache="bar" granularity="ATTRIBUTE">
        <local-affinity/>
    </infinispan-session-management>
    <hotrod-session-management name="remote" remote-cache-container="foo" granularity="ATTRIBUTE">
        <no-affinity/>
    </hotrod-session-management>
    <infinispan-single-sign-on-management name="default" cache-container="foo"/>
    <infinispan-single-sign-on-management name="domain" cache-container="foo" cache="bar"/>
    <hotrod-single-sign-on-management name="remote" remote-cache-container="foo"/>
    <infinispan-routing cache-container="web" cache="routing"/>
</subsystem>
```

## Cache on WildFly

You have two options for the WildFly cache (`remote-cache-container` attribute):

1. L1 cache: maintain a copy of the entries off-loaded to the remote JDG cluster; an `invalidation-near-cache` is used on each WildFly node: the so called L1 cache
2. NO L1 cache

> NOTE: Option "2. NO L1 cache" is NOT recommended 

## L1 cache

Each WildFly node have a "Level 1 Invalidation cache" (see `invalidation-near-cache`) which holds a copy of the cache entries for which the node has ever received a request;
The node receives invalidation messages for the L1 cache directly from the Infinispan Server cluster.

Instead, in a traditional configuration (like in reproducer `INVALIDATION_JDG`), invalidation messages are exchanged between WildFly nodes.

### Transactional

You have two options with L1 cache:

1. Transactional L1 cache
2. NON Transactional L1 cache

### Granularity

You have two options with L1 cache:

1. SESSION or "coarse" granularity
2. ATTRIBUTE or "fine" granularity

### Affinity

When using L1 cache with HotRod session manager it is recommended to use sticky session; this translates to setting routing=LOCAL for the HotRod session manager (see `<local-affinity/>` later on);

> NOTE: find [here](http://wildscribe.github.io/WildFly/16.0/subsystem/infinispan/remote-cache-container/near-cache/invalidation/index.html) documentation on L1 cache

THis ensures that requests to the Infinispan Server cluster are always directed ("routed") to the node that last handled a request for a given session.

## TESTS

Given the above, Clustering tests are going to cover the following scenarios:

1. L1 Transactional cache with SESSION granularity and sticky sessions
2. L1 Transactional cache with ATTRIBUTE granularity and sticky sessions


## Setup

> NOTE: You need to use Java 8; Java 11 does not work with this Infinispan Server version
> NOTE: You have to use WildFly 16 and infinispan-server-9.4.6 or (better) jboss-datagrid-7.3.0

- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Final.zip`)
- download infinispan-server (e.g. [infinispan-server-10.0.0.Beta3.zip](http://downloads.jboss.org/infinispan/10.0.0.Beta3/infinispan-server-10.0.0.Beta3.zip)) to some folder on your PC (e.g. `/some-folder/infinispan-server-10.0.0.Beta3.zip`)
- run script:
  ```
  export JDG_ZIP=/some-folder/infinispan-server-10.0.0.Beta3.zip
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  start-all.sh --default
  ```
- Connect with jconsole and look at:
  ```
  jboss.datagrid-infinispan -> Cache -> "distributed-webapp.war(local)" -> "clustered" -> Statistics -> Attributes -> numberOfEntries
  ```
  This should be something like 4 or 8
- run script:
  ```
  stop-all.sh
  ```    

## Detailed setup explanation

From the point of view of what we run, we have:

- 2 Infinispan Server nodes forming a cluster (first node on port 11522, second node on port 11622)
- 2 WildFly nodes forming a cluster (first node on port 8180, second node on port 8280)

> NOTE: we use e.g. `-Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100` to run multiple "WildFly" / "Infinispan Server" instances on the same host

Each WildFly node is connected to the remote Infinispan Server cluster as follows:

On each WildFly node we create socket connections to the remote Infinispan Server cluster; in standalone-ha.xml we have:

```
<outbound-socket-binding name="infinispan-server-1">
            <remote-destination host="127.0.0.1" port="11522"/>
</outbound-socket-binding>
<outbound-socket-binding name="infinispan-server-2">
    <remote-destination host="127.0.0.1" port="11622"/>
</outbound-socket-binding>
```

Then, on each WildFly node, we use these sockets to enable the WildFly Infinispan subsystem to connect to the remote Infinispan Server cluster:

```
<remote-cache-container name="datagrid-cc" default-remote-cluster="infinispan-server-cluster" module="org.wildfly.clustering.web.hotrod">
    <invalidation-near-cache max-entries="1000"/>
    <remote-clusters>
        <remote-cluster name="infinispan-server-cluster" socket-bindings="infinispan-server-1 infinispan-server-2"/>
    </remote-clusters>
</remote-cache-container>
```

Then, on each WildFly node, we create a profile where the HotRod session manager is used to manage cache entries that, eventually, 
are stored in the remote Infinispan Server cluster through the WildFly Infinispan subsystem:

```
<subsystem xmlns="urn:jboss:domain:distributable-web:1.0" default-session-management="default" default-single-sign-on-management="default">
    ...
    <hotrod-session-management name="datagrid-sm" granularity="SESSION" remote-cache-container="datagrid-cc">
        <local-affinity/>
    </hotrod-session-management>
    ...
</subsystem>
```













