package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.WarrantProjectDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.WarrantProject;
import com.blackstar.model.dto.CustomerListDTO;
import com.blackstar.model.dto.PaymentTermsDTO;
import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.model.dto.WarrantProjectListDTO;

public class WarrantProjectDAOImpl extends AbstractDAO implements WarrantProjectDAO
{

	@SuppressWarnings("deprecation")
	@Override
	public int insertWarrantProject(WarrantProject warrantProject) 
	{
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddWarrantProject(0,?,4,?,?,?,?,?,?,?,?,?,?,?,1);");
		Object[] args = new Object[]
		{
				warrantProject.getStatus() + "",
				//warrantProject.getCustomerId() + "",
				warrantProject.getCostCenter() + "",
				warrantProject.getExchangeRate() + "",
				warrantProject.getUpdateDate() + "",
				warrantProject.getContactName() + "",
				warrantProject.getUbicationProject() + "",
				warrantProject.getPaymentTermsId() + "",
				warrantProject.getDeliveryTime() + "",
				warrantProject.getIntercom() + "",
				warrantProject.getTotalProject() + "",
				warrantProject.getBonds() + "",
				warrantProject.getTotalProductsServices()
				
		};
		return getJdbcTemplate().queryForInt(sqlBuilder.toString(),args);
	}

	@Override
	public WarrantProjectDTO getWarrantProjectById(Integer warrantProjectid) 
	{
		WarrantProjectDTO warrantProject = null;
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetWarrantProjectById(?)");
		warrantProject = (WarrantProjectDTO) getJdbcTemplate().queryForObject(
				sqlBuilder.toString(), new Object[] { warrantProjectid },
				getMapperFor(WarrantProjectDTO.class));
		return warrantProject;	
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CustomerListDTO> getCustomerList() {
		return (List<CustomerListDTO>) getJdbcTemplate().query(
				"CALL GetAllCustomers('C');",
				getMapperFor(CustomerListDTO.class));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<WarrantProjectListDTO> getWarrantProjectList() {
		return (List<WarrantProjectListDTO>) getJdbcTemplate().query(
				"CALL GetAllWarrantProjects;",
				getMapperFor(WarrantProjectListDTO.class));
	}

	@Override
	public List<JSONObject> getWarrantProjectJSON() {
		String sqlQuery = "CALL GetAllWarrantProjects;";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper());
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<PaymentTermsDTO> getPaymentTermsList() {
		return (List<PaymentTermsDTO>) getJdbcTemplate().query(
				"CALL GetAllPaymentTerms();",
				getMapperFor(PaymentTermsDTO.class));
	}

}
