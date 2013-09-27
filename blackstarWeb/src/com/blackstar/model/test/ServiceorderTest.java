package com.blackstar.model.test;

import static org.junit.Assert.*;

import javax.persistence.EntityManagerFactory;
import javax.persistence.*;

import org.junit.Test;

import com.blackstar.model.Serviceorder;

public class ServiceorderTest {

	@Test
	public final void testServiceorder() {
		Serviceorder target = new Serviceorder();
		// Set properties here

		EntityManagerFactory emfInstance = Persistence
		    .createEntityManagerFactory("com.blackstar.jpa");
		EntityManager entityManager = emfInstance.createEntityManager();
		entityManager.getTransaction().begin();
		entityManager.persist(target);
		entityManager.getTransaction().commit();
		entityManager.close();
	}

	@Test
	public final void testServiceorderCharacterIntegerShortStringDateStringStringStringByteDateStringStringStringDateStringStringDateStringString() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetServiceOrderId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetServiceOrderId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetServiceTypeId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetServiceTypeId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetTicketId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetTicketId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetPolicyId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetPolicyId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetServiceUnit() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetServiceUnit() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetServiceDate() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetServiceDate() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetResponsible() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetResponsible() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetReceivedBy() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetReceivedBy() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetServiceComments() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetServiceComments() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetStatusId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetStatusId() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetClosed() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetClosed() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetConsultant() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetConsultant() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetCoordinator() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetCoordinator() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetAsignee() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetAsignee() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetCreated() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetCreated() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetCreatedBy() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetCreatedBy() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetCreatedByUsr() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetCreatedByUsr() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetModified() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetModified() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetModifiedBy() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetModifiedBy() {
		fail("Not yet implemented");
	}

	@Test
	public final void testGetModifiedByUsr() {
		fail("Not yet implemented");
	}

	@Test
	public final void testSetModifiedByUsr() {
		fail("Not yet implemented");
	}

}
