# SHARED SESSIONS

Demonstrates how to run an EAR containing 2 WAR files sharing HTTP sessions, on a 4 nodes WildFly cluster;
Some HTTP requests are fired at the 4 nodes to check that session are shared across WAR files and nodes;

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
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Beta1.zip`)
- run script:
  ```
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  start-all.sh
  ```
- look at the console and check session data is incrementing across WAR files and nodes
- run script:
  ```
  stop-all.sh
  ```    
