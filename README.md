# wildfly-clustering-reproducers

This repo contains some recipes and scripts on how to easily and quickly setup some WildFly cluster.

## BASIC

Demonstrates how to run a 4 nodes WildFly cluster using an distributed cache for WARs;
a distributable WAR is deployed to the 4 nodes and some HTTP requests are fired at the 4 nodes to check the cache is working.

## METRICS

Demonstrates how to run a 4 nodes WildFly cluster producing metrics collected by Prometheus and visualized by Grafana.

## INVALIDATION_DB

Demonstrates how to run a 4 nodes WildFly cluster using an invalidation cache for webapps, backed by a relational Database.

## INVALIDATION_JDG

Demonstrates how to run a 2 nodes WildFly cluster using an invalidation cache for webapps, backed by a 2 nodes Infinispan Server cluster.

## SINGLETON DEPLOYMENT

Demonstrates how to run a Singleton Deployment WAR on a 4 nodes WildFly cluster;
a Singleton Deployment WAR is deployed to the 4 nodes and some HTTP requests are fired at the 4 nodes to check the service is active on just on node;

## SHARED SESSIONS

Demonstrates how to run an EAR containing 2 WAR files sharing HTTP sessions, on a 4 nodes WildFly cluster;
Some HTTP requests are fired at the 4 nodes to check that session are shared across WAR files and nodes;
