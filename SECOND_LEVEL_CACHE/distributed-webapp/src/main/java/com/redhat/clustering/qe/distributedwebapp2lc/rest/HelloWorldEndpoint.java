package com.redhat.clustering.qe.distributedwebapp2lc.rest;


import com.redhat.clustering.qe.distributedwebapp2lc.model.Address;
import com.redhat.clustering.qe.distributedwebapp2lc.model.CreditCardPayment;
import com.redhat.clustering.qe.distributedwebapp2lc.model.DebitCardPayment;
import com.redhat.clustering.qe.distributedwebapp2lc.model.ForeignCustomer;
import com.redhat.clustering.qe.distributedwebapp2lc.model.Order;
import com.redhat.clustering.qe.distributedwebapp2lc.model.OrderSupplemental;
import com.redhat.clustering.qe.distributedwebapp2lc.model.OrderSupplemental2;
import com.redhat.clustering.qe.distributedwebapp2lc.model.Payment;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import java.util.List;
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

	@GET
	@Produces("text/plain")
	@Path("/init")
	@Transactional
	public Response doInit() {
		final Address austin = new Address( "Austin" );
		final Address london = new Address( "London" );

		em.persist( austin );
		em.persist( london );

		final ForeignCustomer acme = new ForeignCustomer( "Acme", london, "1234" );
		final ForeignCustomer acmeBrick = new ForeignCustomer( "Acme Brick", london, "9876", acme );

		final ForeignCustomer freeBirds = new ForeignCustomer( "Free Birds", austin, "13579" );

		em.persist( acme );
		em.persist( acmeBrick );
		em.persist( freeBirds );

		final Order order1 = new Order(  "some text", freeBirds );
		freeBirds.getOrders().add( order1 );
		em.persist( order1 );

		final OrderSupplemental orderSupplemental = new OrderSupplemental( 1 );
		order1.setSupplemental( orderSupplemental );
		final OrderSupplemental2 orderSupplemental2_1 = new OrderSupplemental2( 2 );
		order1.setSupplemental2( orderSupplemental2_1 );
		orderSupplemental2_1.setOrder( order1 );
		em.persist( orderSupplemental );
		em.persist( orderSupplemental2_1 );

		final Order order2 = new Order( "some text", acme );
		acme.getOrders().add( order2 );
		em.persist( order2 );

		final OrderSupplemental2 orderSupplemental2_2 = new OrderSupplemental2( 3 );
		order2.setSupplemental2( orderSupplemental2_2 );
		orderSupplemental2_2.setOrder( order2 );
		em.persist( orderSupplemental2_2 );

		final CreditCardPayment payment1 = new CreditCardPayment( 1F, "1" );
		em.persist( payment1 );
		order1.getPayments().add( payment1 );

		final DebitCardPayment payment2 = new DebitCardPayment( 2F, "2" );
		em.persist( payment2 );
		order1.getPayments().add( payment2 );

		return Response.ok("INIT OK").build();
	}

	@GET
	@Produces("text/plain")
	@Path("/run")
	public Response doRun() {
		final List<Order> orders =
				em.createQuery("select o from Order o", Order.class)
				.getResultList();

		for ( Order order : orders ) {
			log.log(Level.INFO, "############################################" );
			log.log(Level.INFO, "Starting Order #" + order.getOid() );

			// accessing the many-to-one's id should not trigger a load
			if ( order.getCustomer().getOid() == null ) {
				log.log(Level.INFO, "Got Order#customer: " + order.getCustomer().getOid() );
			}

			// accessing the one-to-many should trigger a load
			final Set<Payment> orderPayments = order.getPayments();
			log.log(Level.INFO, "Number of payments = " + orderPayments.size() );

			// access the non-inverse, logical 1-1
			order.getSupplemental();
			if ( order.getSupplemental() != null ) {
				log.log(Level.INFO, "Got Order#supplemental = " + order.getSupplemental().getOid() );
			}

			// access the inverse, logical 1-1
			order.getSupplemental2();
			if ( order.getSupplemental2() != null ) {
				log.log(Level.INFO, "Got Order#supplemental2 = " + order.getSupplemental2().getOid() );
			}
		}

		return Response.ok(orders).build();
	}
}
