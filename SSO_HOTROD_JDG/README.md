# Clustered SSO (Single Sign On) backed by remote Infinispan Cluster

Demonstrates how to run SSO on a 2 nodes WildFly cluster;

SSO data is offloaded to a 2 nodes Infinispan cluster using the new `hotrod-single-sign-on-management` added in [WFLY-7719](https://issues.jboss.org/browse/WFLY-7719);

When you have a cluster of WildFly nodes, you can transparently propagate authenticated session to all the nodes;

This way you can just authenticate once to the the whole cluster;

See [Web_Single_Sign_On](https://docs.wildfly.org/16/WildFly_Elytron_Security.html#Web_Single_Sign_On).

Keep in mind that the priority for determining the session-management configuration to use is as follows:

 * For elytron-based SSO, use the single-sign-on-management configuration whose name matches the application-security-domain associated with the deployment, if one exists
 * For undertow-based SSO, use the single-sign-on-management configuration whose name matches the name of the undertow host associated with the deployment, if one exists
 * Otherwise, use the configuration identified by the default-single-sign-on-management.

> NOTE: You have to use Infinispan Server newer or equal to [infinispan-server-10.0.0](http://downloads.jboss.org/infinispan/10.0.0.Beta3/infinispan-server-10.0.0.Beta3.zip)

## Intro

A new new distributed session manager implementation `org.wildfly.clustering.web.hotrod.session.HotRodSessionManager` has been added to WildFly
(see [WFLY-7719](https://issues.jboss.org/browse/WFLY-7719)).

This HotRod session manager talks directly to the Infinispan Server cluster through the HotRod client (`org.infinispan:infinispan-client-hotrod`)
provided by Infinispan.

With this new session manager it's possible to offload sso data (or/and session data) without even caching a copy on the WildFLy node.

Two new configurations elements have been added to the `distributable-web` element:

 * `hotrod-session-management`
 * `hotrod-single-sign-on-management`

Here is the updated list of options we have now in the `distributable-web` element:

```
<subsystem xmlns="urn:jboss:domain:distributable-web:1.0" default-session-management="session" default-single-sign-on-management="default">
    <infinispan-session-management name="session" cache-container="foo" granularity="SESSION">
        <primary-owner-affinity/>
    </infinispan-session-management>
    <infinispan-session-management name="attribute" cache-container="foo" cache="bar" granularity="ATTRIBUTE">
        <local-affinity/>
    </infinispan-session-management>
    <hotrod-session-management name="remote" remote-cache-container="foo" granularity="ATTRIBUTE">
        <no-affinity/>
    </hotrod-session-management>
    <infinispan-single-sign-on-management name="default" cache-container="foo"/>
    <infinispan-single-sign-on-management name="domain" cache-container="foo" cache="bar"/>
    <hotrod-single-sign-on-management name="remote" remote-cache-container="foo"/>
    <infinispan-routing cache-container="web" cache="routing"/>
</subsystem>
```

## Steps

- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Final.zip`)
- download infinispan-server (e.g. [infinispan-server-10.0.0.Beta3.zip](http://downloads.jboss.org/infinispan/10.0.0.Beta3/infinispan-server-10.0.0.Beta3.zip)) to some folder on your PC (e.g. `/some-folder/infinispan-server-9.4.6.Final.zip`)
- run script:
  ```    
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  export JDG_ZIP=/some-folder/infinispan-server-10.0.0.Beta3.zip
  
  start-all.sh
  ```
- hit url [localhost:8180/clusterbench1/](http://localhost:8180/clusterbench1/) 
  with your browser
- and authenticate with user: `alice` password: `alice`  
- change url to [localhost:8280/clusterbench2/](http://localhost:8280/clusterbench2/) 
  in your browser address bar: you won't be asked again to type your credentials
- run script:
  ```
  stop-all.sh
  ```    

## How it works 

## SSO

The webapp is secured through `web.xml`:
```
    <login-config>
        <auth-method>FORM</auth-method>
        ...
    </login-config>        
```

And WildFly is configured to support SSO (see `wildfly.cli`):
```
...
/subsystem=undertow/application-security-domain=other/setting=single-sign-on:add(key-store=sso, key-alias=localhost, credential-reference={clear-text=secret})
```

## HotRod

WildFly is configured to offload SSO data to a  remote cluster through HotRod:
```
/subsystem=distributable-web/hotrod-single-sign-on-management=other:add(remote-cache-container=web)
/subsystem=distributable-web:write-attribute(name=default-single-sign-on-management, value=other)
```



> NOTE: to make it work you need either:
>  - make the Infinispan cache (that holds SSO data) transactional (see `jdg.cli`):
>    ```
>    /subsystem=datagrid-infinispan/cache-container=clustered/distributed-cache=other:add(configuration=transactional)
>    ```
>  - or add `BASIC` authentication to the webapp through `web.xml`:
>    ```
>        <login-config>
>            <auth-method>BASIC?silent=true,FORM</auth-method>
>            ...
>        </login-config>        
>    ```