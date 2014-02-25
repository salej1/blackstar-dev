package com.blackstar.model.dto;

import java.util.Date;
import java.util.List;

import com.blackstar.model.SurveyService;

public class SurveyServiceDTO {

	private Integer surveyServiceId;
	private String company;
	private String name;
	private String email;
	private String phone;
	private Date date;
	private String reasonTreatment;			
	private String questionIdentificationPersonal;	
	private String questionIdealEquipment;
	private String reasonIdealEquipment;	
	private String questionTime;
	private String reasonTime;	
	private String questionUniform;
	private String reasonUniform;	
	private Integer score;
	private String suggestion;	
	private String sign;
	private String questionTreatment;
	private Date created;
	private String createdBy;
	private String createdByUsr;
	private Date modified;
	private String modifiedBy;
	private String modifiedByUsr;
	private String serviceOrderList;
	
	public SurveyServiceDTO(){}
	
	public SurveyServiceDTO(SurveyService source){
		this.company = source.getCompany();
		this.name = source.getName();
		this.email = source.getEmail();	
		this.phone = source.getPhone();
		this.date = source.getDate();
		this.reasonTreatment = source.getReasonTreatment();
		this.questionIdentificationPersonal = source.getQuestionIdentificationPersonal();
		this.questionIdealEquipment = source.getQuestionIdealEquipment();
		this.reasonIdealEquipment = source.getReasonIdealEquipment();
		this.questionTime = source.getQuestionTime();
		this.reasonTime = source.getReasonTime();
		this.questionUniform = source.getQuestionUniform();
		this.reasonUniform = source.getReasonUniform();
		this.score = source.getScore();
		this.suggestion = source.getSuggestion();
		this.sign = source.getSign();
		this.questionTreatment = source.getQuestionTreatment();
		this.created = source.getCreated();
		this.createdBy = source.getCreatedBy();
		this.createdByUsr = source.getCreatedByUsr();
		this.modified = source.getModified();
		this.modifiedBy = source.getModifiedBy();
		this.modifiedByUsr = source.getModifiedByUsr();
	}
	
	public SurveyServiceDTO(SurveyService source, List<String>servicesList){
		this.company = source.getCompany();
		this.name = source.getName();
		this.email = source.getEmail();	
		this.phone = source.getPhone();
		this.date = source.getDate();
		this.reasonTreatment = source.getReasonTreatment();
		this.questionIdentificationPersonal = source.getQuestionIdentificationPersonal();
		this.questionIdealEquipment = source.getQuestionIdealEquipment();
		this.reasonIdealEquipment = source.getReasonIdealEquipment();
		this.questionTime = source.getQuestionTime();
		this.reasonTime = source.getReasonTime();
		this.questionUniform = source.getQuestionUniform();
		this.reasonUniform = source.getReasonUniform();
		this.score = source.getScore();
		this.suggestion = source.getSuggestion();
		this.sign = source.getSign();
		this.questionTreatment = source.getQuestionTreatment();
		this.created = source.getCreated();
		this.createdBy = source.getCreatedBy();
		this.createdByUsr = source.getCreatedByUsr();
		this.modified = source.getModified();
		this.modifiedBy = source.getModifiedBy();
		this.modifiedByUsr = source.getModifiedByUsr();
		setServiceOrderList(servicesList);
	}
	
	private void setServiceOrderList(List<String> list){
		StringBuilder buff = new StringBuilder();
		for(String so : list){
			if(buff.length() > 0){
				buff.append(", ");
			}
			buff.append(so);
		}
		this.serviceOrderList = buff.toString();
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
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getReasonTreatment() {
		return reasonTreatment;
	}
	public void setReasonTreatment(String reasontreatment) {
		this.reasonTreatment = reasontreatment;
	}
	public String getQuestionIdentificationPersonal() {
		return questionIdentificationPersonal;
	}
	public void setQuestionIdentificationPersonal(
			String questionIdentificationPersonal) {
		this.questionIdentificationPersonal = questionIdentificationPersonal;
	}
	public String getQuestionIdealEquipment() {
		return questionIdealEquipment;
	}
	public void setQuestionIdealEquipment(String questionIdealEquipment) {
		this.questionIdealEquipment = questionIdealEquipment;
	}
	public String getReasonIdealEquipment() {
		return reasonIdealEquipment;
	}
	public void setReasonIdealEquipment(String reasonIdealEquipment) {
		this.reasonIdealEquipment = reasonIdealEquipment;
	}
	public String getQuestionTime() {
		return questionTime;
	}
	public void setQuestionTime(String questionTime) {
		this.questionTime = questionTime;
	}
	public String getReasonTime() {
		return reasonTime;
	}
	public void setReasonTime(String reasonTime) {
		this.reasonTime = reasonTime;
	}
	public String getQuestionUniform() {
		return questionUniform;
	}
	public void setQuestionUniform(String questionUniform) {
		this.questionUniform = questionUniform;
	}
	public String getReasonUniform() {
		return reasonUniform;
	}
	public void setReasonUniform(String reasonUniform) {
		this.reasonUniform = reasonUniform;
	}
	public Integer getScore() {
		return score;
	}
	public void setScore(Integer score) {
		this.score = score;
	}
	public String getSuggestion() {
		return suggestion;
	}
	public void setSuggestion(String suggestion) {
		this.suggestion = suggestion;
	}
	public String getSign() {
		return sign;
	}
	public void setSign(String sign) {
		this.sign = sign;
	}
	public String getQuestionTreatment() {
		return questionTreatment;
	}
	public void setQuestionTreatment(String questionTreatment) {
		this.questionTreatment = questionTreatment;
	}
	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedByUsr() {
		return createdByUsr;
	}
	public void setCreatedByUsr(String createdByUsr) {
		this.createdByUsr = createdByUsr;
	}
	public Date getModified() {
		return modified;
	}
	public void setModified(Date modified) {
		this.modified = modified;
	}
	public String getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(String modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedByUsr() {
		return modifiedByUsr;
	}
	public void setModifiedByUsr(String modifiedByUsr) {
		this.modifiedByUsr = modifiedByUsr;
	}
	public String getServiceOrderList() {
		return serviceOrderList;
	}
	public void setServiceOrderList(String serviceOrderList) {
		this.serviceOrderList = serviceOrderList;
	}

	public Integer getSurveyServiceId() {
		return surveyServiceId;
	}

	public void setSurveyServiceId(Integer surveyServiceId) {
		this.surveyServiceId = surveyServiceId;
	}
	
}
