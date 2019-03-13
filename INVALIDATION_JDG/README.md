# INVALIDATION CACHE BACKED BY INFINISPAN SERVER (OR JDG)

Demonstrates how to run a 2 nodes WildFly cluster using an invalidation cache for webapps, backed by a 2 nodes Infinispan Server cluster.

> NOTE: You need to use Java 8; Java 11 does not work with this Infinispan Server version

> NOTE: You have to use WildFly 16 and infinispan-server-9.4.6 or jboss-datagrid-7.3.0 (better) 

> NOTE: Profiles `distributable-web-1` and `distributable-web-2` were added to test [EAP7-1072](https://issues.jboss.org/browse/EAP7-1072)

> NOTE: If you want to use profiles `distributable-web-1` and `distributable-web-2` (before [EAP7-1072](https://issues.jboss.org/browse/EAP7-1072) is merged), you need to use WildFly built from `https://github.com/pferraro/wildfly/` branch `refs/heads/web` 


- install `gnome-terminal` (used to see log from different nodes in different terminal windows):
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
  MBeans ->     jboss.datagrid-infinispan -> Cache -> "distributed-webapp.war(local)" -> "clustered" -> Statistics -> Attributes -> numberOfEntries
  ```
  This should be something like 4 or 8
- run script:
  ```
  stop-all.sh
  ```    

## Profiles

You can run the reproducer with the following profiles:

### default

```
start-all.sh --default
```

Using this profile we get a webapp configured to use cache `offload` in cache container `web`.
this `offload` cache stores session data in a remote Infinispan Server cluster.

### distributable-web-1

```
start-all.sh --distributable-web-1
```

Using this profile, the webapp is configured though file `WEB-INF/distributable-web.xml`:
```xml
<distributable-web xmlns="urn:jboss:distributable-web:1.0">
  <session-management name="sm_offload_to_jdg_1"/>
</distributable-web>
```
to use the `session-management` profile `sm_offload_to_jdg_1` defined in subsystem `distributable-web`:
```xml
<subsystem xmlns="urn:jboss:domain:distributable-web:1.0" default-session-management="default" default-single-sign-on-management="default">
  ...
  <infinispan-session-management name="sm_offload_to_jdg_1" granularity="SESSION" cache-container="web" cache="offload">
    <primary-owner-affinity/>
  </infinispan-session-management>
  ...    
</subsystem>
```
this `sm_offload_to_jdg_1` profile points to an existing cache `offload`:
```xml
<subsystem xmlns="urn:jboss:domain:infinispan:7.0">
    <cache-container name="web" default-cache="offload" module="org.wildfly.clustering.web.infinispan">
        <invalidation-cache name="offload">
            <hotrod-store remote-cache-container="web-sessions" fetch-state="false" passivation="false" preload="false" purge="false" shared="false"/>
        </invalidation-cache>
        ...
        <remote-cache-container name="web-sessions" default-remote-cluster="jdg-server-cluster">
            <remote-clusters>
                <remote-cluster name="jdg-server-cluster" socket-bindings="hotrodserver1 hotrodserver2"/>
            </remote-clusters>
        </remote-cache-container>
    </cache-container>
</subsystem>
```

### distributable-web-2

```
start-all.sh --distributable-web-2
```

Using this profile, the webapp is configured though file `WEB-INF/distributable-web.xml`:
```xml
<distributable-web xmlns="urn:jboss:distributable-web:1.0">
    <infinispan-session-management cache-container="web" cache="offload" granularity="SESSION">
        <primary-owner-affinity/>
    </infinispan-session-management>
</distributable-web>
```
to use existing cache `offload`:
```xml
<subsystem xmlns="urn:jboss:domain:infinispan:7.0">
    <cache-container name="web" default-cache="offload" module="org.wildfly.clustering.web.infinispan">
        <invalidation-cache name="offload">
            <hotrod-store remote-cache-container="web-sessions" fetch-state="false" passivation="false" preload="false" purge="false" shared="false"/>
        </invalidation-cache>
    </cache-container>
</subsystem>    
```











