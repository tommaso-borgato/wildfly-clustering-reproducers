# SINGLETON DEPLOYMENT

Demonstrates how to run a Singleton Deployment WAR on a 4 nodes WildFly cluster;
a Singleton Deployment WAR is deployed to the 4 nodes and some HTTP requests are fired at the 4 nodes to check the service is active on just on node;

> NOTE: was tested with Java 11 and WildFly 16

- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Final.zip`)
- run script:
  ```
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  start-all.sh --default
  ```
- try and kill the active note and observe the service start on one of the remaining nodes
- run script:
  ```
  stop-all.sh
  ```    
