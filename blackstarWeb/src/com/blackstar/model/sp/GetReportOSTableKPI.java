package com.blackstar.model.sp;

public class GetReportOSTableKPI {
	
	private String serviceOrderId;
	private String office;
	private String comments;
	private String serviceComments;
	private String responsible;
	
	public GetReportOSTableKPI(){
	}
	
	public GetReportOSTableKPI(String office){
	  this.office = office;
	}
	
	public String getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(String serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getOffice() {
		return office;
	}
	public void setOffice(String office) {
		this.office = office;
	}
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}
	public String getServiceComments() {
		return serviceComments;
	}
	public void setServiceComments(String serviceComments) {
		this.serviceComments = serviceComments;
	}
	public String getResponsible() {
		return responsible;
	}
	public void setResponsible(String responsible) {
		this.responsible = responsible;
	}
	
}
