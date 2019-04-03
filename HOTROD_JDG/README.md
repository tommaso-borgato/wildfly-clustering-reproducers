# HOTROD SESSION MANAGEMENT

Demonstrates how to run a 2 nodes WildFly cluster using an remote cache for webapps, backed by a 2 nodes Infinispan Server cluster.
The peculiarity of this configuration is that a particular HotRod session manager is used.
This HotRod session manager talks directly to the Infinispan Server cluster through HotRod client.

The cache used by WildFly distributable web app is totally handled by a remote JDG cluster.

You have two options here:

1. L1 cache: maintain a copy of the entries in the remote JDG cluster, in `invalidation-near-cache` in every WildFly node: the so called L1 cache
2. NO L1 cache

> NOTE: Option "2. NO L1 cache" is NOT recommended and, hence, is not tested

## L1 cache

Each WildFly node have an `invalidation-near-cache` which holds a copy of the cache entries and receives invalidation messages directly from the Infinispan Server cluster.

Instead, in a traditional configuration (like in reproducer `INVALIDATION_JDG`), invalidation messages are exchanged between WildFly nodes.

### Transactional

You have two options with L1 cache:

1. Transactional L1 cache
2. NON Transactional L1 cache

> NOTE: Option "2. NON Transactional L1 cache" is NOT recommended and, hence, is not tested

### Granularity

You have two options with L1 cache:

1. SESSION or "coarse" granularity
2. ATTRIBUTE or "fine" granularity

### Affinity

When using L1 cache with HotRod session manager it is recommended to use sticky session; this translates to setting routing=LOCAL for the HotRod session manager:

```
```

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
- download infinispan-server (e.g. [infinispan-server-9.4.6.Final.zip](http://downloads.jboss.org/infinispan/9.4.6.Final/infinispan-server-9.4.6.Final.zip)) to some folder on your PC (e.g. `/some-folder/infinispan-server-9.4.6.Final.zip`)
- run script:
  ```
  export JDG_ZIP=/some-folder/infinispan-server-9.4.6.Final.zip
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













