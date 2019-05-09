# TWO CLUSTERS

Demonstrates how to run a 2 nodes WildFly cluster using an remote cache for webapps, backed by a 2 nodes Infinispan Server cluster.

The communication between WildFLy and Infinispan is encrypted (see the `--secure` option later on);

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
  start-all.sh --secure
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













