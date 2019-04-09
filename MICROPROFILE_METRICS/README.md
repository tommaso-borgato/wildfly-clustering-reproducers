# MICROPROFILE_METRICS

## Eclipse MicroProfile Metrics

WildFly uses SmallRye that is an implementation of the [Eclipse MicroProfile Metrics](https://microprofile.io/project/eclipse/microprofile-metrics/) specification;
Metrics are implemented in `smallrye-metrics`;
Metrics are enabled by default in WildFly, as we can see in standalone-ha.xml:

```
<subsystem 
   xmlns="urn:wildfly:microprofile-metrics-smallrye:2.0" 
   security-enabled="false" 
   exposed-subsystems="*" 
   prefix="${wildfly.metrics.prefix:wildfly}" />
```

And we have the following endpoints available out of the box:

- /metrics - Contains metrics specified in the MicroProfile 1.1 specification
- /metrics/vendor - Contains vendor-specific metrics, such as memory pools
- /metrics/application - Contains metrics from deployed applications and subsystems that use the MicroProfile Metrics API

In this example we will add our custom metric to the last context;

After deploying the WAR, you can hit that endpoint like this:

```
curl http://localhost:8080/distributed-webapp-metrics/hello
```

These endpoints produce _"Prometheus ready"_ metrics, in the sense that the output is formatted in a key value format that Prometheus can consume:

```
[user@host ~]$ curl http://localhost:9990/metrics
...
base:gc_g1_young_generation_count 8.0
base:classloader_total_loaded_class_count 14756.0
base:cpu_system_load_average 1.29
base:thread_count 60.0
...
```

## Add Application Metrics

To add our custom application metric:

- we create a REST endpoint that is a `@ApplicationScoped` CDI bean
- we add a GET method annotated with `@Gauge` that returns an `int`

Now we can hit `http://localhost:8080/metrics/application/` and find that our custom application metric has been exposed
in Prometheus compatible format 



Run mvn thorntail:run in the unzipped directory
Go to http://localhost:8080/hello and you should see the following message:
Hello from Thorntail!