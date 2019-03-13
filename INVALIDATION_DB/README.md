# INVALIDATION CACHE BACKED BY DATABASE

Demonstrates how to run a 4 nodes WildFly cluster using an invalidation cache for webapps backed by a relational Database.

Relational Database is PostgreSQL and is started as Docker container.

> NOTE: Profiles `distributable-web-1` and `distributable-web-2` were added to test [EAP7-1072](https://issues.jboss.org/browse/EAP7-1072)

> NOTE: If you want to use profiles `distributable-web-1` and `distributable-web-2` (before [EAP7-1072](https://issues.jboss.org/browse/EAP7-1072) is merged), you need to use WildFly built from `https://github.com/pferraro/wildfly/` branch `refs/heads/web` 

- install [Docker](https://docs.docker.com/install/linux/docker-ce/fedora/)
- install `gnome-terminal` (used to see log from different nodes in different terminal windows):
  ```
  sudo yum install gnome-terminal
  ```
- start Docker with command:
  ```
  systemctl start docker
  ```
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Final.zip`)
- run script:
  ```
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  start-all.sh --default
  ```
- Connect to PostgreSQL at:
  ```
  jdbc-url: jdbc:postgresql://127.0.0.1:5432/postgres 
  username: postgres
  password: postgres
  ```
  and run SQL query:
  ```
  select * from s_distributed_webapp_war
  ```
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

Using this profile we get a webapp configured to use a cache named `offload` in cache container `web`; 
this `offload` cache stores session data in a PostgreSQL Database.


### distributable-web-1

```
start-all.sh --distributable-web-1
```

Using this profile, the webapp is configured though file `WEB-INF/distributable-web.xml`:
```xml
<distributable-web xmlns="urn:jboss:distributable-web:1.0">
  <session-management name="sm_offload_to_db_1"/>
</distributable-web>
```
to use the `session-management` profile `sm_offload_to_db_1` defined in subsystem `distributable-web`:
```xml
<subsystem xmlns="urn:jboss:domain:distributable-web:1.0" default-session-management="default" default-single-sign-on-management="default">
  ...
  <infinispan-session-management name="sm_offload_to_db_1" granularity="SESSION" cache-container="web" cache="offload_to_db_1">
      <primary-owner-affinity/>
  </infinispan-session-management>
  ...    
</subsystem>
```
this `sm_offload_to_db_1` profile points to an existing cache `offload_to_db_1`:
```xml
<subsystem xmlns="urn:jboss:domain:infinispan:7.0">
    <cache-container name="web" default-cache="dist" module="org.wildfly.clustering.web.infinispan">
        <invalidation-cache name="offload_to_db_1">
            <jdbc-store data-source="testDS" dialect="POSTGRES" fetch-state="false" passivation="false" purge="false" shared="true">
                <table prefix="s">
                    <id-column name="id" type="VARCHAR(255)"/>
                    <data-column name="datum" type="BYTEA"/>
                    <timestamp-column name="version" type="BIGINT"/>
                </table>
            </jdbc-store>
        </invalidation-cache>
        ...
    </cache-container>
</subsystem>
```

> Use SQL query:
    ```
    select * from s_distributed_webapp_distributable_web_1_war
    ```

### distributable-web-2

```
start-all.sh --distributable-web-2
```

Using this profile, the webapp is configured though file `WEB-INF/distributable-web.xml`:
```xml
<distributable-web xmlns="urn:jboss:distributable-web:1.0">
    <infinispan-session-management cache-container="web" cache="offload_to_db_2" granularity="SESSION">
        <primary-owner-affinity/>
    </infinispan-session-management>
</distributable-web>
```
to use existing cache `offload_to_db_2`:
```xml
<subsystem xmlns="urn:jboss:domain:infinispan:7.0">
    <cache-container name="web" default-cache="dist" module="org.wildfly.clustering.web.infinispan">
        <invalidation-cache name="offload_to_db_2">
            <jdbc-store data-source="testDS" dialect="POSTGRES" fetch-state="false" passivation="false" purge="false" shared="true">
                <table prefix="s">
                    <id-column name="id" type="VARCHAR(255)"/>
                    <data-column name="datum" type="BYTEA"/>
                    <timestamp-column name="version" type="BIGINT"/>
                </table>
            </jdbc-store>
        </invalidation-cache>
    </cache-container>
</subsystem>    
```

> Use SQL query:
    ```
    select * from s_distributed_webapp_distributable_web_2_war
    ```








