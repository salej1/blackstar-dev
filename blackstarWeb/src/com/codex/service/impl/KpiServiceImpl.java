package com.codex.service.impl;

import java.util.Date;

import com.blackstar.services.AbstractService;
import com.codex.db.KpiDAO;
import com.codex.service.KpiService;

public class KpiServiceImpl extends AbstractService implements KpiService {

	KpiDAO dao;
	
	public void setDao(KpiDAO dao) {
		this.dao = dao;
	}

	@Override
	public String getInvoicingKpi(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		return dao.getInvoicingKpi(startDate, endDate, cst, clientOriginId);
	}

	@Override
	public String getEffectiveness(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		return dao.getEffectiveness(startDate, endDate, cst, clientOriginId);
	}

	@Override
	public String getProposals(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		return dao.getProposals(startDate, endDate, cst, clientOriginId);
	}

	@Override
	public String getProjectsByStatus(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		return dao.getProjectsByStatus(startDate, endDate, cst, clientOriginId);
	}

	@Override
	public String getProjectsByOrigin(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		return dao.getProjectsByOrigin(startDate, endDate, cst, clientOriginId);
	}

	@Override
	public String getClientVisits(Date startDate, Date endDate, String cst,
			Integer clientOriginId) {
		return dao.getClientVisits(startDate, endDate, cst, clientOriginId);
	}

	@Override
	public String getNewCustomers(Date startDate, Date endDate, String cst) {
		return dao.getNewCustomers(startDate, endDate, cst);
	}

	@Override
	public String getProductFamilies(Date startDate, Date endDate) {
		return dao.getProductFamilies(startDate, endDate);
	}

	@Override
	public String getComerceCodes(Date startDate, Date endDate) {
		return dao.getComerceCodes(startDate, endDate);
	}

	@Override
	public String getSalesCallsRecords(Date startDate, Date endDate, String cst) {
		return dao.getSalesCallRecords(startDate, endDate, cst);
	}

}
