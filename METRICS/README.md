# METRICS

Demonstrates how to run a 4 nodes WildFly cluster producing metrics collected by Prometheus and visualized by Grafana.

> NOTE: You need to use WildFly 15 or higher for the new `/metrics` context being available on the server 

Steps (on Fedora):

- install [Docker](https://docs.docker.com/install/linux/docker-ce/fedora/)
- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- start Docker with command:
  ```
  systemctl start docker
  ```
- run script:
  ```
  start-all.sh
  ```
- visit Grafana console at url [Grafana Console](http://localhost:3000/) (use "usename/password" "admin/admin")
- visit WildFly distributed webapp on the 4 nodes:
  - [WildFly Node 1](http://localhost:8180/clusterbench-ee7-web/)
  - [WildFly Node 2](http://localhost:8280/clusterbench-ee7-web/)
  - [WildFly Node 3](http://localhost:8380/clusterbench-ee7-web/)
  - [WildFly Node 4](http://localhost:8480/clusterbench-ee7-web/)
- run script:
  ```
  stop-all.sh
  ```  
  
 