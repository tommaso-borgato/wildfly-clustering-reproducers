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
@Entity(name = "ForeignCustomer")
@Table(name = "foreign_cust")
public class ForeignCustomer extends Customer {
	private String vat;

	public ForeignCustomer() {
	}

	public ForeignCustomer(
			String name,
			Address address,
			String vat,
			Customer parentCustomer) {
		super( name, address, parentCustomer );
		this.vat = vat;
	}

	public ForeignCustomer(
			String name,
			Address address,
			String vat) {
		this( name, address, vat, null );
	}

	public String getVat() {
		return vat;
	}

	public void setVat(String vat) {
		this.vat = vat;
	}
}
