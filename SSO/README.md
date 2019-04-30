# Clustered SSO (Single Sign On)

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

Given this, first we configure WildFly following the steps described here [WFLY Web+Single+Sign-On](https://docs.jboss.org/author/display/WFLY/Web+Single+Sign-On);

First we create a realm for holding users:

```xpath
/subsystem=elytron/filesystem-realm=clustering-realm:add(path=/tmp/clustering-realm-1)
```

Then we create domain that uses realm

```xpath
/subsystem=elytron/security-domain=clustering-domain:add(default-realm=clustering-realm, permission-mapper=default-permission-mapper,realms=[{realm=clustering-realm, role-decoder=groups-to-roles}]
```

Then we add users to our realm:
```xpath
/subsystem=elytron/filesystem-realm=clustering-realm:add-identity(identity=alice)
/subsystem=elytron/filesystem-realm=clustering-realm:set-password(identity=alice, clear={password=alice})
/subsystem=elytron/filesystem-realm=clustering-realm:add-identity-attribute(identity=alice, name=groups, value=["user"])
```

We add to elytron (the security module in WildFLy) the possibility to authenticate via FORM to our domain:

```xpath
/subsystem=elytron/http-authentication-factory=clustering-http-authentication:add(security-domain=clustering-domain, http-server-mechanism-factory=global, mechanism-configurations=[{mechanism-name=FORM}])
```

Then we add to undertow (the web module in WildFLy) the default application security domain for secured apps:

```xpath
/subsystem=undertow/application-security-domain=other:add(http-authentication-factory=clustering-http-authentication)
```

We need a keystore:

```bash
keytool -genkeypair -alias localhost -keyalg RSA -keysize 1024 -validity 365 -keystore keystore.jks -dname "CN=localhost" -keypass secret -storepass secret
```

```xpath
/subsystem=elytron/key-store=clustering-keystore:add(path=keystore.jks, relative-to=jboss.server.config.dir, credential-reference={clear-text=secret}, type=JKS)
```

And finally we add SSO to undertow:

```xpath
/subsystem=undertow/application-security-domain=other/setting=single-sign-on:add(key-store=clustering-keystore, key-alias=localhost, domain=localhost, credential-reference={clear-text=secret})
```

## Using a load balancer

When using a load balancer (like HAProxy) we must take into account the fact that the domain plays a pivotal role;

This is the regular flow:

- the client requests a secure url through the load balancer; let's say the load balancer's IP is `1.1.1.1`, hence the ulr can be something like `http://1.1.1.1/clusterbenc1/session`
- the server load balancer forwards the request to a WildFly node; let's say the node's IP is `2.2.2.2`
- the server send back a form to use for authentication
- the client receives the form and posts username and password to a url like h`ttp://1.1.1.1/clusterbenc1/j_security_check`
- the load balancer forwards the request to the WildFly node that checks the credentials and sends back an authentication cookie;
  this cookie is names `JSESSIONIDSSO` and has an attribute named `domain` that is set to the value used to configure SSO in undertow (`localhost` in this case):
  ```xpath
  /subsystem=undertow/application-security-domain=other/setting=single-sign-on:add(key-store=clustering-keystore, key-alias=localhost, domain=localhost, credential-reference={clear-text=secret})
  ```
- the client receives this cookie and is, from now on, authenticated to the `localhost` domain

What's the problem here?

The problem is that the client also receives a response HTTP header `Origin: http://1.1.1.1` that point to the load balancer;
The client compares `1.1.1.1` with `localhost` and discards the `JSESSIONIDSSO` as not belonging to the response domain;

When using JMeter as client you get the following error:

```java
2019-04-17 07:17:18,806 WARN o.a.h.c.p.ResponseProcessCookies: Cookie rejected [JSESSIONIDSSO="r_h-gNoUTwD7uvrwlkLkji1fuNjnHFB-8KUocOrp", version:0, domain:10.0.145.202, path:/, expiry:null] Illegal 'domain' attribute "10.0.145.202". Domain of origin: "127.0.0.1"
```

We have two options here:

- set the correct domain in the WildFly node:   
  ```xpath
    /subsystem=undertow/application-security-domain=other/setting=single-sign-on:add(key-store=clustering-keystore, key-alias=localhost, domain=1.1.1.1, credential-reference={clear-text=secret})
    ```
- have the load balancer to 
  - remap the `JSESSIONIDSSO`'s `domain` attribute from `localhost` to `1.1.1.1` in the WildFly to client direction (so the client does not discard it)
  - remap back the `JSESSIONIDSSO`'s `domain` attribute from `1.1.1.1` to `localhost` in the client to WildFly direction (so the server recognise it and considers the requests already authenticated)  


