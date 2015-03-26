package com.codex.model.dto;

public class CstDTO {
	Integer cstId;
	String name;
	String officeId;
	String phone;
	String phoneExt;
	String mobile;
	String email;
	Integer autoAuthProjects;
	Integer scope;
	
	public Integer getCstId() {
		return cstId;
	}
	public void setCstId(Integer cstId) {
		this.cstId = cstId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getOfficeId() {
		return officeId;
	}
	public void setOfficeId(String officeId) {
		this.officeId = officeId;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPhoneExt() {
		return phoneExt;
	}
	public void setPhoneExt(String phoneExt) {
		this.phoneExt = phoneExt;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Integer getAutoAuthProjects() {
		return autoAuthProjects;
	}
	public void setAutoAuthProjects(Integer autoAuthProjects) {
		this.autoAuthProjects = autoAuthProjects;
	}
	public Integer getScope() {
		return scope;
	}
	public void setScope(Integer scope) {
		this.scope = scope;
	}
}
