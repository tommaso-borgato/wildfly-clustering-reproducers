# SSO Single Sign On

Demonstrates how to run SSO on a 2 nodes WildFly cluster;

When you have a cluster of WildFly nodes, you can transparently propagate authenticated session to all the nodes;

This way you can just authenticate once to the the whole cluster;

## Steps

- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Final.zip`)
- run script:
  ```
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  start-all.sh
  ```
- hit url [localhost:8080/clusterbench1/session](http://localhost:8080/clusterbench1/session) 
  with your browser
- and authenticate with user: `alice` password: `alice`  
- change url to [localhost:8180/clusterbench2/session](http://localhost:8180/clusterbench2/session) 
  in your browser address bar: you won't be asked again to type your credentials
- run script:
  ```
  stop-all.sh
  ```    

## How it works 

Security is handled by the `subsystem=elytron`;

This subsystem, by default, contains two `security-domain`:

- `ApplicationDomain`
- `ManagementDomain`

Each domain, in turn, relies on a `realm` for user management:

- `ApplicationDomain` --> `ApplicationRealm`
- `ManagementDomain`  --> `ManagementRealm`

We are going to add our sso user to `ApplicationRealm` which happens to be a `properties-realm` (= users are held in some properties file on disk):

```xml
<properties-realm name="ApplicationRealm">
    <users-properties path="application-users.properties" relative-to="jboss.server.config.dir" digest-realm-name="ApplicationRealm"/>
    <groups-properties path="application-roles.properties" relative-to="jboss.server.config.dir"/>
</properties-realm>
```

We add our sso user to `ApplicationRealm` using the `add-user.sh` script:

```bash
add-user.sh -a -u alice -p alice -r ApplicationRealm -ro User
```


