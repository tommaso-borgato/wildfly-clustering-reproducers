# METRICS

Demonstrates hot to run a 4 nodes WildFly cluster producing metrics collected by Prometheus and visualized by Grafana.

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
- visit Grafana console at url `http://localhost:3000/` (use "usename/password" "admin/admin")
- run script:
  ```
  stop-all.sh
  ```  
  
 