# 4 NODES WILDFLY CLUSTER

Demonstrates how to run a 4 nodes WildFly cluster using an distributed cache for webapps; 
a distributable WAR is deployed to the 4 nodes and some HTTP requests are fired at the 4 nodes to check the cache is working;

> NOTE: was tested with Java 11 and WildFly 16

- install [Docker](https://docs.docker.com/install/linux/docker-ce/fedora/)
- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- start Docker with command:
  ```
  systemctl start docker
  ```
- download WildFly (e.g. [wildfly-16.0.0.Beta1.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Beta1.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Beta1.zip`)
- run script:
  ```
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Beta1.zip
  start-all.sh --default
  ```
- run script:
  ```
  stop-all.sh
  ```    












