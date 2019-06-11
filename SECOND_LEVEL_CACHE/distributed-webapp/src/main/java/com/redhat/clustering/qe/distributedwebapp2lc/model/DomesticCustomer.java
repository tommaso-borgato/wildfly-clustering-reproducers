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
@Entity(name = "DomesticCustomer")
@Table(name = "domestic_cust")
public class DomesticCustomer extends Customer {
	private String taxId;

	public DomesticCustomer() {
	}

	public DomesticCustomer(
			String name,
			String taxId,
			Address address,
			Customer parentCustomer) {
		super( name, address, parentCustomer );
		this.taxId = taxId;
	}

	public String getTaxId() {
		return taxId;
	}

	public void setTaxId(String taxId) {
		this.taxId = taxId;
	}
}
