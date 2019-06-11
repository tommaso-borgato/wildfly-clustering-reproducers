/*
 * Hibernate, Relational Persistence for Idiomatic Java
 *
 * License: GNU Lesser General Public License (LGPL), version 2.1 or later
 * See the lgpl.txt file in the root directory or http://www.gnu.org/licenses/lgpl-2.1.html
 */
package com.redhat.clustering.qe.distributedwebapp2lc.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;

/**
 * @author Steve Ebersole
 */
@Entity(name = "Payment")
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class Payment {
	private Long oid;
	private Float amount;

	public Payment() {
	}

	public Payment(Float amount) {
		this.amount = amount;
	}

	@Id
	@Column(name = "oid")
	@GeneratedValue(strategy = GenerationType.AUTO)
	public Long getOid() {
		return oid;
	}

	public void setOid(Long oid) {
		this.oid = oid;
	}

	public Float getAmount() {
		return amount;
	}

	public void setAmount(Float amount) {
		this.amount = amount;
	}
}
