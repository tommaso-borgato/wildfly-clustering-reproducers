package org.jboss.test.rest;


import org.eclipse.microprofile.metrics.MetricUnits;
import org.eclipse.microprofile.metrics.annotation.Gauge;

import javax.enterprise.context.ApplicationScoped;
import javax.management.AttributeNotFoundException;
import javax.management.InstanceNotFoundException;
import javax.management.MBeanException;
import javax.management.MBeanServerConnection;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;
import javax.management.ReflectionException;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import java.io.IOException;
import java.lang.management.ManagementFactory;


@ApplicationScoped
@Path("/api")
public class CustomMetricEndpoint {

	private int gauge = 0;

	@GET
	@Produces("text/plain")
	@Gauge(unit = MetricUnits.NONE, name = "intValue", absolute = true)
	public int doGet() {
		return gauge++;
	}

	@GET
	@Path("jgroups_received_bytes")
	@Produces("text/plain")
	@Gauge(unit = MetricUnits.NONE, name = "jgroupsReceivedBytes", absolute = true)
	public long doGet1() throws MalformedObjectNameException, AttributeNotFoundException, MBeanException, ReflectionException, InstanceNotFoundException, IOException {
		MBeanServerConnection mbeanServerConnection = ManagementFactory.getPlatformMBeanServer();
		ObjectName mbeanName = new ObjectName("jgroups:type=channel,cluster=\"ee\"");
		mbeanServerConnection.getAttribute(mbeanName, "received_bytes");
		return Long.parseLong(mbeanServerConnection.getAttribute(mbeanName, "received_bytes").toString());
	}

	@GET
	@Path("jgroups_sent_bytes")
	@Produces("text/plain")
	@Gauge(unit = MetricUnits.NONE, name = "jgroupsSentBytes", absolute = true)
	public long doGet2() throws MalformedObjectNameException, AttributeNotFoundException, MBeanException, ReflectionException, InstanceNotFoundException, IOException {
		MBeanServerConnection mbeanServerConnection = ManagementFactory.getPlatformMBeanServer();
		ObjectName mbeanName = new ObjectName("jgroups:type=channel,cluster=\"ee\"");
		mbeanServerConnection.getAttribute(mbeanName, "received_bytes");
		return Long.parseLong(mbeanServerConnection.getAttribute(mbeanName, "sent_bytes").toString());
	}

	@GET
	@Path("jgroups_received_messages")
	@Produces("text/plain")
	@Gauge(unit = MetricUnits.NONE, name = "jgroupsReceivedBytes", absolute = true)
	public long doGet3() throws MalformedObjectNameException, AttributeNotFoundException, MBeanException, ReflectionException, InstanceNotFoundException, IOException {
		MBeanServerConnection mbeanServerConnection = ManagementFactory.getPlatformMBeanServer();
		ObjectName mbeanName = new ObjectName("jgroups:type=channel,cluster=\"ee\"");
		mbeanServerConnection.getAttribute(mbeanName, "received_messages");
		return Long.parseLong(mbeanServerConnection.getAttribute(mbeanName, "received_messages").toString());
	}

	@GET
	@Path("jgroups_sent_messages")
	@Produces("text/plain")
	@Gauge(unit = MetricUnits.NONE, name = "jgroupsSentBytes", absolute = true)
	public long doGet4() throws MalformedObjectNameException, AttributeNotFoundException, MBeanException, ReflectionException, InstanceNotFoundException, IOException {
		MBeanServerConnection mbeanServerConnection = ManagementFactory.getPlatformMBeanServer();
		ObjectName mbeanName = new ObjectName("jgroups:type=channel,cluster=\"ee\"");
		mbeanServerConnection.getAttribute(mbeanName, "received_messages");
		return Long.parseLong(mbeanServerConnection.getAttribute(mbeanName, "sent_messages").toString());
	}


}
