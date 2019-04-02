# INVALIDATION CACHE BACKED BY INFINISPAN SERVER (OR JDG)

Demonstrates how to run a 2 nodes WildFly cluster using an remote cache for webapps, backed by a 2 nodes Infinispan Server cluster.

The cache used by WildFly distributable web apps is totally handled by a remote JDG cluster.

Each WildFly node just holds an `invalidation-near-cache` which holds a copy of the entries and receives invalidation messages directly from the Infinispan Server cluster.

Instead, in a traditional configuration (like in reproducer `INVALIDATION_JDG`), invalidation messages are exchanged between WildFly nodes.

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

## Profiles

You can run the reproducer with the following profiles:

### coarse

Uses granularity="SESSION" for cache data replication; run with command:

```
start-all.sh --coarse
```

Uses file META-INF/jboss-all.xml in WAR to set:

```xml
<jboss xmlns="urn:jboss:1.0">
    <distributable-web xmlns="urn:jboss:distributable-web:1.0">
        <hotrod-session-management remote-cache-container="web" granularity="SESSION">
            <local-affinity/>
        </hotrod-session-management>
    </distributable-web>
</jboss>
```

to reference `remote-cache-container` in `standalone-ha.xml`:


the infinispan-server-1 and infinispan-server-1 point 
```xml
<socket-binding-group name="standard-sockets" ... >
    ...
    <outbound-socket-binding name="infinispan-server-1">
        <remote-destination host="127.0.0.1" port="11522"/>
    </outbound-socket-binding>
    <outbound-socket-binding name="infinispan-server-2">
        <remote-destination host="127.0.0.1" port="11622"/>
    </outbound-socket-binding>
</socket-binding-group>
```



### fine

Uses granularity="ATTRIBUTE" for cache data replication; run with command:

```
start-all.sh --coarse
```

Uses file `META-INF/jboss-all.xml` in `WAR` to set:

```xml
<jboss xmlns="urn:jboss:1.0">
    <distributable-web xmlns="urn:jboss:distributable-web:1.0">
        <hotrod-session-management remote-cache-container="web" granularity="ATTRIBUTE">
           <local-affinity/>
       </hotrod-session-management>
    </distributable-web>
</jboss>
```

to reference `remote-cache-container` in `standalone-ha.xml`:

```xml
TODO: add xml
```


L1 Cache in the Infinispan subsystem:

```xml
<remote-cache-container name="web" default-remote-cluster="infinispan-server-cluster" module="org.wildfly.clustering.web.hotrod">
    <invalidation-near-cache max-entries="1000"/>
    <remote-clusters>
        <remote-cluster name="infinispan-server-cluster" socket-bindings="infinispan-server-1 infinispan-server-2"/>
    </remote-clusters>
</remote-cache-container>
```






# ===================================================
# WIP
# ===================================================

## https://issues.jboss.org/browse/EAP7-1109

BRANCH https://github.com/wildfly-clustering/wildfly/tree/remote

COMMUNITY DOC https://github.com/wildfly/wildfly/blob/3e1d218d089768e404f97d387dddb745eb17d05b/docs/src/main/asciidoc/_high-availability/subsystem-support/Distributable_Web_Applications.adoc

## PR and bits

https://github.com/wildfly/wildfly/pull/11662
/home/hudson/static_build_env/clustering/wildfly/wildfly-remote.zip (branch is pferraro:remote)


## sample cli

sample configuration: 
https://github.com/pferraro/wildfly/blob/remote/testsuite/integration/clustering/src/test/java/org/jboss/as/test/clustering/cluster/web/remote/AbstractHotRodWebFailoverTestCase.java#L52

## L1 cache configuration

we have to test:
- L1 + sticky session, ATTRIBUTE vs SESSION granularity (affinity=local)
- NO L1, NO sticky session ==> NO it's a bad config and it's not recommended

http://wildscribe.github.io/WildFly/16.0/subsystem/infinispan/remote-cache-container/near-cache/invalidation/index.html

## questions

- is it the hotrod-session-management element that triggers new behaviour ? __yes - it's the hotrod-session-management that enables use of the hotrod-based session manager; although, assuming the subsystem exists, you can define a deployment specific session manager without the need to define one in the distributable-web subsystem__
- is the jboss-all.xml supposed to be in the META-INF directory? why in CoarseHotRodWebFailoverTestCase it is added to the WEB-INF dir? :
war.addAsWebInfResource(CoarseHotRodWebFailoverTestCase.class.getPackage(), "jboss-all_coarse.xml", "jboss-all.xml"); __jboss-all.xml can appear in either META-INF or WEB-INF__
- why did you always use jboss-all.xml in test and not distributable-web.xml ? __it doesn't matter which is used - they are parsed by the same logic__

## Zulip

__me:__ Can the remote-cache-container(default-remote-cluster=infinispan-server-cluster) 
be used without the distributable-web subsystem and still get the same result: i.e. using the HotRod-based distributed session manager ? _(I was asking because I could not see any reference to the new session manager anywhere but in the infinispan subsystem)_

__Paul:__ No - the deployment unit processors that detect and process the distributable-web deployment descriptors are defined by the distributable-web subsystem.  So, the subsystem must exist._(not sure we understood each other)_

__me:__ is this __"module=org.wildfly.clustering.web.hotrod"__ that makes the difference between traditional session manager and the new hot rod based session manager? :
/subsystem=infinispan/remote-cache-container=web:add(default-remote-cluster=infinispan-server-cluster, module=org.wildfly.clustering.web.hotrod)
/subsystem=infinispan/remote-cache-container=web:add(default-remote-cluster=infinispan-server-cluster)

__Paul:__ no, however, the module is needed to load the marshalling classes required for the session manager to work

__me:__ is the jboss-all.xml supposed to be in the META-INF directory? why in CoarseHotRodWebFailoverTestCase it is added to the WEB-INF dir? :
war.addAsWebInfResource(CoarseHotRodWebFailoverTestCase.class.getPackage(), "jboss-all_coarse.xml", "jboss-all.xml");

__Paul:__ yes - it's the __hotrod-session-management__ in e.g. jboss-all.xml, that enables use of the hotrod-based session manager:

```
<jboss xmlns="urn:jboss:1.0">
  <distributable-web xmlns="urn:jboss:distributable-web:1.0">
    <hotrod-session-management remote-cache-container="web" granularity="ATTRIBUTE">
      <local-affinity/>
    </hotrod-session-management>
  </distributable-web>
</jboss>
```

although, assuming the subsystem exists, you can define a deployment specific session manager without the need to define one in the distributable-web subsystem;
jboss-all.xml can appear in either META-INF or WEB-INF;
it doesn't matter which is used - they are parsed by the same logic

__me:__ to use __hotrod-session-management__ you need to have the connection to infinispan in place:

```
 // remote-cache-container=web
/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=infinispan-server-1:add(port=11622,host=%s)
/subsystem=infinispan/remote-cache-container=web:add(default-remote-cluster=infinispan-server-cluster, module=org.wildfly.clustering.web.hotrod)
/subsystem=infinispan/remote-cache-container=web/remote-cluster=infinispan-server-cluster:add(socket-bindings=[infinispan-server-1])
/subsystem=distributable-web/routing=infinispan:remove
/subsystem=distributable-web/routing=local:add
```














