package com.blackstar.model.sp;

public class GetStatisticsKPI {
	
	private String officeName;
	private String project;
	private String customer;
	private int pNumber;
	private int tPolicies;
	private int nReports;
	private int tReports;
	
	public String getOfficeName() {
		return officeName;
	}
	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public String getCustomer() {
		return customer;
	}
	public void setCustomer(String customer) {
		this.customer = customer;
	}
	public int getpNumber() {
		return pNumber;
	}
	public void setpNumber(int pNumber) {
		this.pNumber = pNumber;
	}
	public int gettPolicies() {
		return tPolicies;
	}
	public void settPolicies(int tPolicies) {
		this.tPolicies = tPolicies;
	}
	public int getnReports() {
		return nReports;
	}
	public void setnReports(int nReports) {
		this.nReports = nReports;
	}
	public int gettReports() {
		return tReports;
	}
	public void settReports(int tReports) {
		this.tReports = tReports;
	}

}
