package com.redhat.clustering.qe.distributedwebapp2lc.rest;


import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import java.util.logging.Logger;


@Stateless
@LocalBean
@Path("/api")
public class HelloWorldEndpoint {

	protected static final Logger log = Logger.getLogger(HelloWorldEndpoint.class.getName());

	@GET
        @Path("/ping")
        public Response ping() {
	    String node = System.getProperty("jboss.node.name");
	    return Response.ok().entity(String.format("Service online on %s", node)).build();
        }
}
