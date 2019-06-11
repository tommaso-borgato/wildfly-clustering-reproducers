/*
 * Hibernate, Relational Persistence for Idiomatic Java
 *
 * License: GNU Lesser General Public License (LGPL), version 2.1 or later
 * See the lgpl.txt file in the root directory or http://www.gnu.org/licenses/lgpl-2.1.html
 */
package com.redhat.clustering.qe.distributedwebapp2lc.model;

import org.hibernate.annotations.LazyToOne;
import org.hibernate.annotations.LazyToOneOption;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import java.util.HashSet;
import java.util.Set;

/**
 * @author Steve Ebersole
 */
@Entity(name = "Customer")
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class Customer {
	private Long oid;
	private String name;
	private Set<Order> orders = new HashSet<>();

	private Address address;

	private Customer parentCustomer;
	private Set<Customer> childCustomers = new HashSet<>();

	public Customer() {
	}

	public Customer(String name, Address address, Customer parentCustomer) {
		this.name = name;
		this.address = address;
		this.parentCustomer = parentCustomer;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "customer")
	public Set<Order> getOrders() {
		return orders;
	}

	public void setOrders(Set<Order> orders) {
		this.orders = orders;
	}

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
	@LazyToOne(LazyToOneOption.NO_PROXY)
	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
	@LazyToOne(LazyToOneOption.NO_PROXY)
	public Customer getParentCustomer() {
		return parentCustomer;
	}

	public void setParentCustomer(Customer parentCustomer) {
		this.parentCustomer = parentCustomer;
	}

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "parentCustomer")
	public Set<Customer> getChildCustomers() {
		return childCustomers;
	}

	public void setChildCustomers(Set<Customer> childCustomers) {
		this.childCustomers = childCustomers;
	}
}
