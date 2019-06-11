/*
 * Hibernate, Relational Persistence for Idiomatic Java
 *
 * License: GNU Lesser General Public License (LGPL), version 2.1 or later
 * See the lgpl.txt file in the root directory or http://www.gnu.org/licenses/lgpl-2.1.html
 */
package com.redhat.clustering.qe.distributedwebapp2lc.model;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author Steve Ebersole
 */
@Entity(name = "CreditCardPayment")
@Table(name = "credit_payment")
public class CreditCardPayment extends Payment {
	private String transactionId;

	public CreditCardPayment() {
	}

	public CreditCardPayment(Float amount, String transactionId) {
		this.transactionId = transactionId;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
}
