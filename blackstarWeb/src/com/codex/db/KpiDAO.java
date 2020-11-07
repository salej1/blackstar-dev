package com.codex.db;

import java.util.Date;

public interface KpiDAO{
	public String getInvoicingKpi(Date startDate, Date endDate, String cst, Integer clientOriginId);
	public String getEffectiveness(Date startDate, Date endDate, String cst, Integer clientOriginId);
	public String getProposals(Date startDate, Date endDate, String cst, Integer clientOriginId);
	public String getProjectsByStatus(Date startDate, Date endDate, String cst, Integer clientOriginId);
	public String getProjectsByOrigin(Date startDate, Date endDate, String cst, Integer clientOriginId);
	public String getClientVisits(Date startDate, Date endDate, String cst, Integer clientOriginId);
	public String getNewCustomers(Date startDate, Date endDate, String cst);
	public String getProductFamilies(Date startDate, Date endDate);
	public String getComerceCodes(Date startDate, Date endDate);
	public String getSalesCallRecords(Date startDate, Date endDate, String cst);
}
