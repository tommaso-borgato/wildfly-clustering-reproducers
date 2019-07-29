## Second Level Cache with Hibernate and Infinispan


### Intro

In JPA, the Persistence Context is what handles the set of entities which hold data to be persisted in some persistence store.
Persistence Context is bound to the currently running logical transaction, acting as a transactional write-behind cache: 
when the transaction is closed, entity state transitions are translated into DML statements; then, the Persistence Context is destroyed.
The Persistence Context can be bound to a SFSB (Stateful Session Bean) session and, hence, span across multiple server calls; 
in this case, it is called "Extended Persistence Context" and DML statements are generated when `flush()` is manually called;

Anyway, the Persistence Contextis destroyed after the SFSB session ends.

The second-level cache spans across multiple transactions or sessions.


### How it works

In `persistence.xml` we add the following:
```xml
    <property name="hibernate.cache.infinispan.entity.cfg" value="entity-replicated"/>
```
This has the effect of using the Infinispan cache `entity-replicated` as a custom cache template for entities's caches 
(reference here: https://access.redhat.com/documentation/en-us/red_hat_data_grid/7.3/html/red_hat_data_grid_user_guide/integrations);
  
In the `standalone-ha.xml`, we have an `invalidation-cache` named `entity` in the cache container `hibernate` of
the Infinispan subsystem;
By default, this cache would be used as the template for entities's caches;
Here we are overriding this default creating a replicated-cache in the cache container `hibernate`, and using it
as template;
  
We are using the entity `DummyEntityCustomRegion`, which also defines a custom region name to be used for
its second level cache name:
```java
     @Cache(usage = CacheConcurrencyStrategy.TRANSACTIONAL, region = "DUMMY_ENTITY_REGION_NAME")
```
  
The result is that, for the entity {@link DummyEntityCustomRegion}, a `replicated-cache` named
`ClusteredJPA2LCCustomRegionTestCase.war#MainPU.DUMMY_ENTITY_REGION_NAME` is created;
  

### JPA Configuration

Enabling second cache for JPA, requires some changes to the descriptor file `persistence.xml`:

```xml
<property name="hibernate.cache.use_second_level_cache" value="true"/>
```

To select which entities/collections to cache, first annotate them with `javax.persistence.Cacheable`:

```java
@Entity
@Cacheable(true) 
public class Employee implements Serializable {
    //...
}
```
 
Then make sure shared cache mode is set to ENABLE_SELECTIVE:	

```xml
<shared-cache-mode>ENABLE_SELECTIVE</shared-cache-mode>
```

Optionally, queries can also be cached:

```xml
<property name="hibernate.cache.use_query_cache" value="true"/>
```

and the single query to be made cacheable:

```java
Query query = em.createQuery("select e from Employee e");
query.setHint("org.hibernate.cacheable", Boolean.TRUE);
```

The best way to find out whether second level cache is working or not is to enable and inspect the statistics:

```xml
<property name="hibernate.generate_statistics" value="true" />
```

### jboss.as.jpa.scopedname

Specify the qualified (application scoped)
persistence unit name to be used. By default, this is internally set to
the application name + persistence unit name. The
hibernate.cache.region_prefix will default to whatever you set
jboss.as.jpa.scopedname to. Make sure you set the
jboss.as.jpa.scopedname value to a value not already in use by other
applications deployed on the same application server instance.

### jpa/hibernate5_3/src/test/bundles/explicitpar/META-INF/persistence.xml

```
<property name="hibernate.cache.region_prefix" value="hibernate.test"/>
```

### TODO

WildFly integration test suite will be extended with following scenarios:

 * L2 cache enabled prevents recovery in separate transactions (based on support case 02315986 - https://access.redhat.com/support/cases/#/case/02315986)
   ** configure read-write concurrency strategy (likely test the same with other strategies)
   ** fail + rollback writing transaction
   ** test that cache contains/doesn't contain correct data
   ==> added in testsuite/integration/basic#org.jboss.as.test.integration.jpa.secondlevelcache because they are single node tests on transactions

 * use of custom cache regions
   ** define custom caches (template) in infinispan subsystem with custom properties for eviction, expiration, etc.
   ** configure template in persistence xml
   ** configure region per entity using @Cache
   ** test that custom region uses correct template
   ==> added in testsuite/integration/clustering#org.jboss.as.test.clustering.cluster.jpa2lc.ClusteredJPA2LCTestCase because we need a cluster to use a replicated cache

   questions:
   1. custom region == custom cache in hibernate cache container?
   2. API to check statistics and content of a cache

 * customization within the persistence.xml for cache regions
   ** base as above, but some options of cache (template) will be overriden in app
   ** test that options in the cache configuration can also be overridden directly through properties
     *** hibernate.cache.infinispan.something.eviction.strategy
     *** hibernate.cache.infinispan.something.eviction.max_entries
     *** hibernate.cache.infinispan.something.expiration.lifespan
     *** hibernate.cache.infinispan.something.expiration.max_idle
     *** hibernate.cache.infinispan.something.expiration.wake_up_interval

 * get non-jpa tests to the same level as jpa tests
   ** extend non-jpa test to the same level as https://github.com/wildfly/wildfly/blob/master/testsuite/integration/basic/src/test/java/org/jboss/as/test/integration/jpa/secondlevelcache/JPA2LCTestCase.java[JPA2LCTestCase.java]



## Existing Second Level Cache Tests in the WildFly test-suite


### org/jboss/as/test/integration/jpa/secondlevelcache/JPA2LCTestCase.java


#### testMultipleNonTXTransactionalEntityManagerInvocations

- Create entity through EntityManager
- Select entity through EntityManager (entity is put into 2LC)
- Delete entity directly via JDBC (entity is NOT removed from 2LC)
- Select entity through EntityManager: entity is still in cache and select is successful 

Persistence Unit:

```
    <persistence-unit name="mypc2">
        <description>Persistence Unit.</description>
        <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
        <properties>
            <property name="hibernate.hbm2ddl.auto" value="create-drop"/>
            <property name="hibernate.show_sql" value="false"/>
            <property name="hibernate.cache.use_second_level_cache" value="true"/>
            <property name="hibernate.cache.use_query_cache" value="true"/>
            <property name="hibernate.generate_statistics" value="true"/>
            <property name="hibernate.enhancer.enableDirtyTracking" value="true"/>
            <property name="hibernate.enhancer.enableLazyInitialization" value="true"/>
            <property name="hibernate.enhancer.enableAssociationManagement" value="true"/>

            <!-- Hibernate 5.2+ (see https://hibernate.atlassian.net/browse/HHH-10877 +
                 https://hibernate.atlassian.net/browse/HHH-12665) no longer defaults
                 to allowing a DML operation outside of a started transaction.
                 The application workaround is to configure new property hibernate.allow_update_outside_transaction=true.
            -->
           <property name="hibernate.allow_update_outside_transaction" value="true"/>
        </properties>
    </persistence-unit>
```

#### testDisabledCache    

Persistence Unit: 

```
    <persistence-unit name="mypc_no_2lc">
        <description>Persistence Unit.</description>
        <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
        <shared-cache-mode>NONE</shared-cache-mode>
        <properties>
            <property name="hibernate.hbm2ddl.auto" value="create-drop"/>
            <property name="hibernate.show_sql" value="false"/>
            <property name="hibernate.cache.use_second_level_cache" value="false"/>
            <property name="hibernate.cache.use_query_cache" value="false"/>
            <property name="hibernate.generate_statistics" value="true"/>
            <property name="hibernate.enhancer.enableDirtyTracking" value="true"/>
            <property name="hibernate.enhancer.enableLazyInitialization" value="true"/>
            <property name="hibernate.enhancer.enableAssociationManagement" value="true"/>

            <!-- Hibernate 5.2+ (see https://hibernate.atlassian.net/browse/HHH-10877 +
                 https://hibernate.atlassian.net/browse/HHH-12665) no longer defaults
                 to allowing a DML operation outside of a started transaction.
                 The application workaround is to configure new property hibernate.allow_update_outside_transaction=true.
            -->
           <property name="hibernate.allow_update_outside_transaction" value="true"/>
        </properties>
    </persistence-unit>
```

- Create entity through EntityManager and verify cahce `statistics` are empty
- Select entity through EntityManager and verify cahce `statistics` are empty

#### testSameQueryTwice

- Run query through EntityManager and verify cahce `statistics` for query have correct `miss`(1: mean query result was missing in cache and DB was hit), `put`(1) and `hit`(0)
- Run query through EntityManager and verify cahce `statistics` for query have correct `hit`(1)

Persistence Unit: 

```
    <persistence-unit name="mypc">
        <description>Persistence Unit.</description>
        <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
        <properties>
            <property name="hibernate.hbm2ddl.auto" value="create-drop"/>
            <property name="hibernate.show_sql" value="false"/>
            <property name="hibernate.cache.use_second_level_cache" value="true"/>
            <property name="hibernate.cache.use_query_cache" value="true"/>
            <property name="hibernate.generate_statistics" value="true"/>
            <property name="hibernate.enhancer.enableDirtyTracking" value="true"/>
            <property name="hibernate.enhancer.enableLazyInitialization" value="true"/>
            <property name="hibernate.enhancer.enableAssociationManagement" value="true"/>

            <!-- Hibernate 5.2+ (see https://hibernate.atlassian.net/browse/HHH-10877 +
                 https://hibernate.atlassian.net/browse/HHH-12665) no longer defaults
                 to allowing a DML operation outside of a started transaction. 
                 The application workaround is to configure new property hibernate.allow_update_outside_transaction=true.
            -->
           <property name="hibernate.allow_update_outside_transaction" value="true"/>
        </properties>
    </persistence-unit>
```

#### testInvalidateQuery

- Performs 2 query calls, first call put query in the cache and second should hit the cache (for a non existing entity)
- create entity (invalidate the cache)
- Performs 2 query calls, first call put query in the cache and second should hit the cache (for the newly created entity)

Persistence Unit: `mypc`

#### testEvictQueryCache

- Performs 2 query calls, first call put query in the cache and second should hit the cache (for the newly created entity)
- Evicts all query cache regions
- Check query cache is actually empty

Persistence Unit: `mypc`



### org/jboss/as/test/integration/jpa/secondlevelcache/JpaStatisticsTestCase.java


#### testJpaStatistics

Test cache statistics exists for a given persistence unit;
Basically, after deployment of jar conteining a persistence unit `mypc`, 
checks that sybsystem `/deployment/JpaStatisticsTestCase/subsystem=jpa/hibernate-persistence-unit/JpaStatisticsTestCase/.jar#mypc:read-resource` actually exixts.



### org/jboss/as/test/clustering/cluster/jpa2lc/ClusteredJPA2LCTestCase.java


#### setupCacheContainer

Setup a replicated 2LC cache for entities on each of a 2 nodes cluster:

```
/subsystem=infinispan/cache-container=hibernate/replicated-cache=entity-replicated:add(mode=sync)
```

and just verify that the cli operation is successful

#### testEntityCacheReplication

| NOTE: Uses a `custom region` (i.e. a custom Infinispan cache) for the entities 2LC cache

- Create Entity
- Verify the Entity is in 2LC on both nodes (since the 2LC cache is actually a `replicated-cache`)
- Evict Entity from 2LC
- Verify the Entity is NOT in 2LC on both nodes
- Add Entity from 2LC
- Verify the Entity is in 2LC on both nodes

Persistence Unit:

```
<persistence xmlns="http://java.sun.com/xml/ns/persistence" version="2.0">
    <persistence-unit name="MainPU">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
        <shared-cache-mode>ALL</shared-cache-mode>
        <properties>
            <property name="hibernate.dialect" value="org.hibernate.dialect.H2Dialect"/>
            <property name="hibernate.show_sql" value="false"/>
            <property name="hibernate.format_sql" value="true"/>
            <property name="hibernate.hbm2ddl.auto" value="create"/>
            <property name="hibernate.cache.use_second_level_cache" value="true"/>
            <property name="hibernate.cache.use_query_cache" value="true"/>
            <property name="hibernate.cache.infinispan.entity.cfg" value="entity-replicated"/>
        </properties>
    </persistence-unit>
</persistence>
```



### org/jboss/as/test/clustering/cluster/ejb/xpc/StatefulWithXPCFailoverTestCase.java


Test Extended persistence context;

EntityManager lives and dies within a JTA transaction. Once the transaction is finished, all persistent objects are detached from the EntityManager and are no longer managed.
EJB 3.0 allows you to define long-living EntityManagers that live beyond the scope of a JTA transaction. This is called an Extended Persistence Context.
Extended persistence contexts can only be used within Stateful session beans:

```
@Stateful
public class StatefulBean
{
   @PersistenceContext(type=PersistenceContextType.EXTENDED) 
   EntityManager em;
   ...
}
```

Conversations: when you combine extended persistence contexts with non-transactional methods (`@TransactionAttribute(TransactionAttributeType.NOT_SUPPORTED)`). 
If you interact with an extended persistence context outside of a transaction, the inserts, updates, and deletes will be queued until you access the persistence context within a transaction. This means that any persist(), merge(), or remove() method you call will not actually result in a JDBC execution and thus an update of the database until you manually call `EntityManager.flush()`: e.g. in 10 web pages wizard, this could come handy having the SFSB holding all the entities but saving them just at `flush()`.

Persistence Unit:

```
<?xml version="1.0" encoding="UTF-8"?> 
<persistence xmlns="http://java.sun.com/xml/ns/persistence" version="1.0">
  <persistence-unit name="mypc">
    <description>Persistence Unit.</description>
    <jta-data-source>java:jboss/datasources/ExampleDS</jta-data-source>
    <shared-cache-mode>ENABLE_SELECTIVE</shared-cache-mode>
    <properties> 
      <property name="hibernate.hbm2ddl.auto" value="create-drop"/>
      <property name="hibernate.cache.use_second_level_cache" value="true" />
      <property name="hibernate.generate_statistics" value="true" />
      <property name="hibernate.show_sql" value="true"/>
    </properties>
  </persistence-unit>
</persistence>
```

#### testSecondLevelCache

On a 2 nodes cluster (each node with its own local DB) an Extended Persistence Context Entity Manager is used:

.... do many JPA operations without JTA Transaction and check 2LC is updated just at flush ....

- NODE 1: Create entity and select it with no JTA transaction
- NODE 1: entity NOT in 2LC on NODE 1 (no JTA transaction, no JDBC)
- NODE 2: Create entity and select it with no JTA transaction
- NODE 2: flush (trigger JDBC)
- NODE 2: entity is in 2LC on NODE 2
- NODE 2: delete entity
- NODE 1 & 2: entity NOT in 2LC (evicted after delete)

#### testBasicXPC

On a 2 nodes cluster (each node with its own local DB) an Extended Persistence Context Entity Manager is used:

- NODE 2: is failed
- NODE 1: enetity is created
- NODE 1: entity is read from XPC 
- NODE 2: is stated
- NODE 2: entity is read (not clear to me why this is successful)
- NODE 1: is failed


### org/jboss/as/test/integration/hibernate/secondlevelcache/HibernateSecondLevelCacheTestCase.java


Hibernate Configuration:

```
<?xml version='1.0' encoding='utf-8'?>
<hibernate-configuration>
	<session-factory>
		<property name="show_sql">false</property>
		<property name="hibernate.cache.use_second_level_cache">true</property>
		<property name="hibernate.show_sql">false</property>
		<property name="hibernate.cache.region.factory_class">org.infinispan.hibernate.cache.v51.InfinispanRegionFactory</property>
		<property name="hibernate.cache.infinispan.shared">false</property>
		<mapping resource="testmapping.hbm.xml"/>
	</session-factory>
</hibernate-configuration>
```

#### testSecondLevelCache

- Create entity via Hibernate
- Select entity via Hibernate (entity is now in 2LC) 
- update entity via JDBC
- verify entity read via Hibernate is NOT updated
- clear 2LC
- verify entity read via Hibernate is updated

#### testReadDeletedRowFrom2lc

- Create entity via Hibernate
- Select entity via Hibernate (entity is now in 2LC) 
- delete entity via JDBC
- verify entity can still be read via Hibernate (direct JDBC delete did NOT trigger entity eviction)





















