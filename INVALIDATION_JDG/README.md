# INVALIDATION CACHE BACKED BY DATABASE

Demonstrates how to run a 2 nodes WildFly cluster using an invalidation cache for webapps backed by a 2 nodes Infinispan Server cluster.

> NOTE: You need to use Java 8; Java 11 does not work with this Infinispan Server version


/subsystem=datagrid-infinispan/cache-container=clustered/distributed-cache=distributed-webapp.war:add(configuration=default)
/subsystem=datagrid-infinispan/cache-container=clustered/distributed-cache=distributed-webapp-distributable-web-1.war:add(configuration=default)
/subsystem=datagrid-infinispan/cache-container=clustered/distributed-cache=distributed-webapp-distributable-web-2.war:add(configuration=default)