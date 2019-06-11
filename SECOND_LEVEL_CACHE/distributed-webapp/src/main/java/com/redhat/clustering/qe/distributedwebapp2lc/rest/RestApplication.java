package com.redhat.clustering.qe.distributedwebapp2lc.rest;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;
import java.util.Collections;
import java.util.Set;

@ApplicationPath("/")
public class RestApplication extends Application {
    @Override
    public Set<Class<?>> getClasses() {
        return Collections.singleton(HelloWorldEndpoint.class);
    }

}
