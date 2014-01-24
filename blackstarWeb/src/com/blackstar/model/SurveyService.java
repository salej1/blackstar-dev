package com.blackstar.model;

import java.util.Date;
import java.util.List;

public class SurveyService {

	private String company;
	private String name;
	private String email;
	private Integer telephone;
	private Date date;
	private List<String> lQuestionTreatment;
	private String reasontreatment;		
	private List<String> lQuestionIdentificationPersonal;	
	private List<String> lQuestionIdealEquipment;
	private String reasonIdealEquipment;	
	private List<String> lQuestionTime;
	private String reasonTime;	
	private List<String> lQuestionUniform;
	private List<String> reasonUniform;	
	private Integer qualification;
	private String suggestion;
	private Integer serviceOrderId;
	private String sign;
	
	public Integer getServiceOrderId() {
		return serviceOrderId;
	}
	public void setServiceOrderId(Integer serviceOrderId) {
		this.serviceOrderId = serviceOrderId;
	}
	public String getSign() {
		return sign;
	}
	public void setSign(String sign) {
		this.sign = sign;
	}
		
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public List<String> getlQuestionTreatment() {
		return lQuestionTreatment;
	}
	public void setlQuestionTreatment(List<String> lQuestionTreatment) {
		this.lQuestionTreatment = lQuestionTreatment;
	}
	public String getReasontreatment() {
		return reasontreatment;
	}
	public void setReasontreatment(String reasontreatment) {
		this.reasontreatment = reasontreatment;
	}
	public List<String> getlQuestionIdentificationPersonal() {
		return lQuestionIdentificationPersonal;
	}
	public void setlQuestionIdentificationPersonal(
			List<String> lQuestionIdentificationPersonal) {
		this.lQuestionIdentificationPersonal = lQuestionIdentificationPersonal;
	}
	public List<String> getlQuestionIdealEquipment() {
		return lQuestionIdealEquipment;
	}
	public void setlQuestionIdealEquipment(List<String> lQuestionIdealEquipment) {
		this.lQuestionIdealEquipment = lQuestionIdealEquipment;
	}
	public String getReasonIdealEquipment() {
		return reasonIdealEquipment;
	}
	public void setReasonIdealEquipment(String reasonIdealEquipment) {
		this.reasonIdealEquipment = reasonIdealEquipment;
	}
	public List<String> getlQuestionTime() {
		return lQuestionTime;
	}
	public void setlQuestionTime(List<String> lQuestionTime) {
		this.lQuestionTime = lQuestionTime;
	}
	public String getReasonTime() {
		return reasonTime;
	}
	public void setReasonTime(String reasonTime) {
		this.reasonTime = reasonTime;
	}
	public List<String> getlQuestionUniform() {
		return lQuestionUniform;
	}
	public void setlQuestionUniform(List<String> lQuestionUniform) {
		this.lQuestionUniform = lQuestionUniform;
	}
	public List<String> getReasonUniform() {
		return reasonUniform;
	}
	public void setReasonUniform(List<String> reasonUniform) {
		this.reasonUniform = reasonUniform;
	}
	public Integer getQualification() {
		return qualification;
	}
	public void setQualification(Integer qualification) {
		this.qualification = qualification;
	}
	public String getSuggestion() {
		return suggestion;
	}
	public void setSuggestion(String suggestion) {
		this.suggestion = suggestion;
	}
	
	public Integer getTelephone() {
		return telephone;
	}
	public void setTelephone(Integer telephone) {
		this.telephone = telephone;
	}
	
}
