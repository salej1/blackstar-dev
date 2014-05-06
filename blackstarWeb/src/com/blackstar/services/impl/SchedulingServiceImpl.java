package com.blackstar.services.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.OpenCustomerDAO;
import com.blackstar.db.dao.interfaces.SchedulingDAO;
import com.blackstar.interfaces.IEmailService;
import com.blackstar.model.OpenCustomer;
import com.blackstar.model.ScheduledService;
import com.blackstar.model.dto.ScheduledServiceDTO;
import com.blackstar.services.EmailServiceFactory;
import com.blackstar.services.GmailService;
import com.blackstar.services.interfaces.SchedulingService;

public class SchedulingServiceImpl implements SchedulingService {

	private SchedulingDAO dao;
	
	public void setDao(SchedulingDAO dao) {
		this.dao = dao;
	}
	
	private OpenCustomerDAO custDao;

	public void setCustDao(OpenCustomerDAO custDao) {
		this.custDao = custDao;
	}
	
	private GmailService gmService;

	public void setGmService(GmailService gmService) {
		this.gmService = gmService;
	}

	@Override
	public List<JSONObject> getFutureServices() {
		return dao.getFutureServices();
	}

	@Override
	public List<ScheduledServiceDTO> getScheduledServices(Date date) {
		return dao.getScheduledServices(date);
	}

	@Override
	public List<String> getProjectList() {
		return dao.getProjectList();
	}

	@Override
	public ScheduledServiceDTO getScheduledService(Integer serviceId) {
		ScheduledService rawService = dao.getScheduledService(serviceId);
		ScheduledServiceDTO service;
		
		OpenCustomer cust;
		List<Integer> policies;
		if(rawService.getOpenCustomerId() != null && rawService.getOpenCustomerId() > 0){
			// Open customer
			cust = custDao.GetOpenCustomerById(rawService.getOpenCustomerId());
			service = new ScheduledServiceDTO(rawService, cust);
		}else{
			// Policies
			service = new ScheduledServiceDTO(rawService);
			policies = dao.getScheduledServicePolicies(serviceId);
			service.setPolicyList(policies);
		}

		// Employees
		List<String> employees = dao.getScheduledServiceEmployees(serviceId);
		service.setEmployeeList(employees);
		
		// Dates
		List<Date> dates = dao.getScheduledServiceDates(serviceId);
		if(dates.size() > 0){
			service.setServiceStartDate(dates.get(0));
			service.setNumDays(dates.size());
		}
		
		return service;
	}

	@Override
	public Integer upsertScheduledService(ScheduledServiceDTO service, String who, String user){
		Calendar serviceDate = Calendar.getInstance();
		serviceDate.setTime(service.getServiceStartDate());
		
		ScheduledService saveService = new ScheduledService();
		saveService.setScheduledServiceId(service.getScheduledServiceId() != null? service.getScheduledServiceId() : 0);
		saveService.setServiceStatusId(service.getServiceStatusId());
		saveService.setDescription(service.getDescription());
		saveService.setOpenCustomerId(service.getOpenCustomerId());
		saveService.setProject(service.getProject());
		saveService.setServiceContact(service.getServiceContact());
		saveService.setServiceContactEmail(service.getServiceContactEmail());
		if(service.getScheduledServiceId() != null && service.getScheduledServiceId() > 0){
			saveService.setModifiedBy(who);
			saveService.setModifiedByUsr(user);
		}
		else{
			saveService.setCreatedBy(who);
			saveService.setCreatedByUsr(user);
		}
		
		if(service.getNoPolicy()){
			// open customer
			OpenCustomer cust = new OpenCustomer();
			cust.setOpenCustomerId(service.getOpenCustomerId());
			cust.setCustomerName(service.getCustomer());
			cust.setAddress(service.getAddress());
			cust.setPhone(service.getContactPhone());
			cust.setEquipmentTypeId(service.getEquipmentTypeId());
			cust.setBrand(service.getBrand());
			cust.setModel(service.getModel());
			cust.setSerialNumber(service.getSerialNumber());
			cust.setContactName(service.getContact());
			cust.setContactEmail(service.getContactEmail());
			cust.setCreatedBy(who);
			cust.setCreatedByUsr(user);
			cust.setModifiedBy(who);
			cust.setModifiedByUsr(user);
			cust.setOfficeId(service.getOfficeId());
			Integer customerId = custDao.SaveOpenCustomer(cust);
			saveService.setOpenCustomerId(customerId);
		}
		
		Integer serviceId = dao.upsertScheduledService(saveService);
		
		if(!service.getNoPolicy()){
			// Asociando equipos
			for(Integer policyId : service.getPolicyList()){
				dao.addScheduledServicePolicy(serviceId, policyId, who, user);
			}
		}
		
		// Asociando empleados
		int isDefault = 1;
		for(String employee : service.getEmployeeList()){				
			dao.addScheduledServiceEmployee(serviceId, employee, isDefault, who, user);
			isDefault = 0;
		}
		
		// Asociando fechas
		for(Integer offset = 0; offset < service.getNumDays(); offset++){
			dao.addScheduledServiceDate(serviceId, serviceDate.getTime(), who, user);
			serviceDate.add(Calendar.DATE, 1);
		}
		
		// envio de email
		notifyEmplyees(service);
		
		return serviceId;
	}

	@Override
	public List<JSONObject> getEquipmentList() {
		return dao.getEquipmentList();
	}

	private void notifyEmplyees(ScheduledServiceDTO service){
		String subject = "Servicio preventivo agendado";
		StringBuilder body = new StringBuilder();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
		
		body.append("El siguiente servicio ha sido asignado a usted:")
		.append("\r\n")
		.append("Agendado por: " + service.getCreatedByUsr())
		.append("Fecha y hora: " + sdf.format(service.getServiceStartDate()))
		.append("Numero de dias: " + service.getNumDays().toString())
		.append("Persona de contacto :" + service.getServiceContact())
		.append("Email de contacto: " + service.getServiceContactEmail())
		.append("Indicaciones: " + service.getDescription())
		.append("Ingenieros asignados: " + service.getEmployeeNamesString())
		.append("Equipos por revisar: " + service.getSerialNumberList());
		
		for(String employee : service.getEmployeeList()){
			IEmailService mail = EmailServiceFactory.getEmailService();
			mail.sendEmail(service.getCreatedByUsr(), employee, subject, body.toString());
		}
	}
}
