# Clustered SSO (Single Sign On) backed by remote Infinispan Cluster

Demonstrates how to run SSO on a 2 nodes WildFly cluster;

SSO data is offloaded to a 2 nodes Infinispan cluster using the new `hotrod-single-sign-on-management` added in [WFLY-7719](https://issues.jboss.org/browse/WFLY-7719);

When you have a cluster of WildFly nodes, you can transparently propagate authenticated session to all the nodes;

This way you can just authenticate once to the the whole cluster;

See [Web_Single_Sign_On](https://docs.wildfly.org/16/WildFly_Elytron_Security.html#Web_Single_Sign_On).

> NOTE: You need to use Java 8 for the Infinispan cluster (see `run script` below)

## Steps

- install `gnome-terminal`:
  ```
  sudo yum install gnome-terminal
  ```
- download WildFly (e.g. [wildfly-16.0.0.Final.zip](https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip)) to some folder on your PC (e.g. `/some-folder/wildfly-16.0.0.Final.zip`)
- download infinispan-server (e.g. [infinispan-server-9.4.6.Final.zip](http://downloads.jboss.org/infinispan/9.4.6.Final/infinispan-server-9.4.6.Final.zip)) to some folder on your PC (e.g. `/some-folder/infinispan-server-9.4.6.Final.zip`)
- run script:
  ```  
  # Java 8 is used for Infinispan
  export JAVA_HOME_8=/usr/Java/oracle/jdk1.8.0_181
  # Java 11 i used for WildFly
  export JAVA_HOME_11=/usr/Java/openjdk/jdk-11.0.2
  
  export WLF_ZIP=/some-folder/wildfly-16.0.0.Final.zip
  export JDG_ZIP=/some-folder/infinispan-server-9.4.6.Final.zip
  
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