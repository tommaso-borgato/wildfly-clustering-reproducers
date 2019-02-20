# INVALIDATION CACHE BACKED BY DATABASE

Demonstrates how to run a 4 nodes WildFly cluster using an invalidation cache for webapps backed by a relational Database.

> NOTE: You need to use WildFly built from `https://github.com/pferraro/wildfly/` branch `refs/heads/web`

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
- Connect to PostgreSQL at:
  ```
  jdbc-url: jdbc:postgresql://127.0.0.1:5432/postgres 
  username: postgres
  password: postgres
  ```
- run script:
  ```
  stop-all.sh
  ```    
