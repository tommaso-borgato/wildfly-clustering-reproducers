## Invalidation cache for HTTP session data backed by a relational Database

### How to run

Everything has to be run as `root`:

- install `gnome-terminal`:
  ```bash
  dnf install gnome-terminal
  ```
- install `podman`:
  ```bash
  dnf install podman
  ``` 
- put some `wildfly.zip` of your choice in the current directory and:
  ```bash
  export WLF_ZIP=$(pwd)/wildfly.zip
  ```
- run the reproducer:
  To use `SYBASE`:
  ```bash
  ./start-all.sh --sybase
  ```
  To use `MYSQL`:
  ```bash
  ./start-all.sh --mysql
  ```