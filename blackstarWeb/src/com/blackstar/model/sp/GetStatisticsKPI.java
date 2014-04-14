package com.blackstar.model.sp;

public class GetStatisticsKPI {
	
	private String officeName;
	private String project;
	private String customer;
	private Integer pNumber;
	private Double tPolicies;
	private Integer nReports;
	private Double tReports;
	private Integer oReports;
	
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
	public Integer getpNumber() {
		return pNumber;
	}
	public void setpNumber(Integer pNumber) {
		this.pNumber = pNumber;
	}
	public Double gettPolicies() {
		return tPolicies;
	}
	public void settPolicies(Double tPolicies) {
		this.tPolicies = tPolicies;
	}
	public Integer getnReports() {
		return nReports;
	}
	public void setnReports(Integer nReports) {
		this.nReports = nReports;
	}
	public Double gettReports() {
		return tReports;
	}
	public void settReports(Double tReports) {
		this.tReports = tReports;
	}
	public Integer getoReports() {
		return oReports;
	}
	public void setoReports(Integer oReports) {
		this.oReports = oReports;
	}

}
