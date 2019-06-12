package com.redhat.clustering.qe.distributedwebapp2lc.rest;


import com.redhat.clustering.qe.distributedwebapp2lc.model.Address;
import com.redhat.clustering.qe.distributedwebapp2lc.model.CreditCardPayment;
import com.redhat.clustering.qe.distributedwebapp2lc.model.Customer;
import com.redhat.clustering.qe.distributedwebapp2lc.model.DebitCardPayment;
import com.redhat.clustering.qe.distributedwebapp2lc.model.ForeignCustomer;
import com.redhat.clustering.qe.distributedwebapp2lc.model.Order;
import com.redhat.clustering.qe.distributedwebapp2lc.model.OrderSupplemental;
import com.redhat.clustering.qe.distributedwebapp2lc.model.OrderSupplemental2;
import com.redhat.clustering.qe.distributedwebapp2lc.model.Payment;
import org.hibernate.stat.Statistics;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;


@Stateless
@LocalBean
@Path("/test")
public class HelloWorldEndpoint {

	protected static final Logger log = Logger.getLogger(HelloWorldEndpoint.class.getName());

	@PersistenceContext
	private EntityManager em;

	private static final Map<String, Long> cntMap = new HashMap<>();
	private static final long getId(long i, Class<?> cl) {
		if (! cntMap.containsKey(cl.getCanonicalName())) {
			cntMap.put(cl.getCanonicalName(), Long.valueOf(1));
		} else {
			long curval = cntMap.get(cl.getCanonicalName());
			cntMap.put(cl.getCanonicalName(), curval + Long.valueOf(1));
		}
		long retval = cntMap.get(cl.getCanonicalName()) + i;
		log.info("CLASS="  + cl.getName() + " ID="+retval);
		return retval;
	}

	@GET
	@Produces("text/plain")
	@Path("/init")
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public Response doInit() {
		final List<Long> ordersOid = new ArrayList<>();

		for (long i=0; i<5; i++) {
			final Address austin = new Address("Austin");
			austin.setId(getId(i, Address.class));
			final Address london = new Address("London");
			london.setId(getId(i, Address.class));

			em.merge(austin);
			em.merge(london);

			final ForeignCustomer acme = new ForeignCustomer("Acme", london, "1234");
			acme.setOid(getId(i, Customer.class));
			final ForeignCustomer acmeBrick = new ForeignCustomer("Acme Brick", london, "9876", acme);
			acmeBrick.setOid(getId(i, Customer.class));
			final ForeignCustomer freeBirds = new ForeignCustomer("Free Birds", austin, "13579");
			freeBirds.setOid(getId(i, Customer.class));

			em.merge(acme);
			em.merge(acmeBrick);
			em.merge(freeBirds);

			final Order order1 = new Order("some text", freeBirds);
			order1.setOid(getId(i, Order.class));
			freeBirds.getOrders().add(order1);
			em.merge(order1);

			final OrderSupplemental orderSupplemental = new OrderSupplemental(1);
			orderSupplemental.setOid(getId(i, OrderSupplemental.class));
			order1.setSupplemental(orderSupplemental);
			final OrderSupplemental2 orderSupplemental2_1 = new OrderSupplemental2(2);
			orderSupplemental2_1.setOid(getId(i, OrderSupplemental2.class));
			order1.setSupplemental2(orderSupplemental2_1);
			orderSupplemental2_1.setOrder(order1);
			em.merge(orderSupplemental);
			em.merge(orderSupplemental2_1);

			final Order order2 = new Order("some text", acme);
			order2.setOid(getId(i, Order.class));
			acme.getOrders().add(order2);
			em.merge(order2);

			final OrderSupplemental2 orderSupplemental2_2 = new OrderSupplemental2(3);
			orderSupplemental2_2.setOid(getId(i, OrderSupplemental2.class));
			order2.setSupplemental2(orderSupplemental2_2);
			orderSupplemental2_2.setOrder(order2);
			em.merge(orderSupplemental2_2);

			final CreditCardPayment payment1 = new CreditCardPayment(1F, "1");
			payment1.setOid(getId(i, Payment.class));
			order1.getPayments().add(payment1);
			em.merge(payment1);

			final DebitCardPayment payment2 = new DebitCardPayment(2F, "2");
			payment2.setOid(getId(i, Payment.class));
			order1.getPayments().add(payment2);
			em.merge(payment2);

			ordersOid.add(order1.getOid());
			ordersOid.add(order2.getOid());
		}

		return Response.ok(ordersOid).build();
	}

	@GET
	@Produces("text/plain")
	@Path("/run")
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public Response doRun() {
		final List<Long> ordersOid = new ArrayList<>();

		final Statistics stats = org.hibernate.internal.SessionImpl.class.cast(em.getDelegate()).getSessionFactory().getStatistics();
		stats.clear();

		final List<Order> orders =
				em.createQuery("select o from Order o", Order.class)
				.setHint("org.hibernate.cacheable", Boolean.FALSE)
				.getResultList();

		log.log(Level.INFO, "======================================================================" );
		for ( Order order : orders ) {
			log.log(Level.INFO, "############################################" );
			log.log(Level.INFO, "Starting Order #" + order.getOid() );

			// accessing the many-to-one's id should not trigger a load
			if ( order.getCustomer().getOid() == null ) {
				log.log(Level.INFO, "Got Order#customer: " + order.getCustomer().getOid() + " (" + stats.getPrepareStatementCount() + ")" );
			}

			// accessing the one-to-many should trigger a load
			final Set<Payment> orderPayments = order.getPayments();
			log.log(Level.INFO, "Number of payments = " + orderPayments.size() + " (" + stats.getPrepareStatementCount() + ")");

			// access the non-inverse, logical 1-1
			order.getSupplemental();
			if ( order.getSupplemental() != null ) {
				log.log(Level.INFO, "Got Order#supplemental = " + order.getSupplemental().getOid() + " (" + stats.getPrepareStatementCount() + ")" );
			}

			// access the inverse, logical 1-1
			order.getSupplemental2();
			if ( order.getSupplemental2() != null ) {
				log.log(Level.INFO, "Got Order#supplemental2 = " + order.getSupplemental2().getOid() + " (" + stats.getPrepareStatementCount() + ")" );
			}
			ordersOid.add(order.getOid());
		}

		return Response.ok(ordersOid).build();
	}
}
