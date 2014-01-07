package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;

import com.blackstar.logging.*;
import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.dao.interfaces.PolicyDAO;
import com.blackstar.model.Policy;

public class MySQLPolicyDAO implements PolicyDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4137438371500773507L;

	@Override
	public Policy findPolicy() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Policy> selectAllPolicy() {
		List<Policy> lstPolicy = new ArrayList<Policy>();
		Policy policy = null;
		Connection conn = null;;
		try {
			conn = (Connection) MySQLDAOFactory.createConnection();
			ResultSet rs = conn.createStatement().executeQuery(("Select * from policy"));
			
			while(rs.next()) {
				policy = new Policy(rs.getString("officeId").charAt(0), rs.getString("policyTypeId").charAt(0), rs.getString("customerContract"),
						rs.getString("customer"), rs.getString("finalUser"), rs.getString("project"), rs.getString("cst"),
						rs.getString("equipmentTypeId").charAt(0), rs.getString( "brand"), rs.getString("model"),
						rs.getString("serialNumber"), rs.getString("capacity"), rs.getString("equipmentAddress"),
						rs.getString("equipmentLocation"), rs.getString("contactName"), rs.getString("contactPhone"), rs.getString("contactEmail"),
						rs.getDate("startDate"),
						rs.getDate("endDate"), rs.getInt("visitsPerYear"), rs.getInt("responseTimeHr"),
						rs.getShort("solutionTimeHr"), rs.getString("penalty"), rs.getString("service"),
						rs.getBoolean("includesParts"), rs.getString("exceptionParts"),
						rs.getString("serviceCenterId").charAt(0), rs.getString("observations"), rs.getDate("created"),
						rs.getString("createdBy"), rs.getString("crratedByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
				policy.setPolicyId(rs.getInt("policyId"));
				lstPolicy.add(policy);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		// TODO Auto-generated method stub
		return lstPolicy;
	}

	@Override
	public int insertPolicy() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updatePolicy() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Policy getPolicyById(int id) {
		Policy policy = null;
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();

			ResultSet rs = conn.createStatement().executeQuery(String.format("Select * from policy where policyId = %d", id));
			
			while(rs.next()) {
				policy = new Policy(rs.getString("officeId").charAt(0), rs.getString("policyTypeId").charAt(0), rs.getString("customerContract"),
						rs.getString("customer"), rs.getString("finalUser"), rs.getString("project"), rs.getString("cst"),
						rs.getString("equipmentTypeId").charAt(0), rs.getString( "brand"), rs.getString("model"),
						rs.getString("serialNumber"), rs.getString("capacity"), rs.getString("equipmentAddress"),
						rs.getString("equipmentLocation"), rs.getString("contactName"), rs.getString("contactPhone"), rs.getString("contactEmail"),
						rs.getDate("startDate"),
						rs.getDate("endDate"), rs.getInt("visitsPerYear"), rs.getInt("responseTimeHr"),
						rs.getShort("solutionTimeHr"), rs.getString("penalty"), rs.getString("service"),
						rs.getBoolean("includesParts"), rs.getString("exceptionParts"),
						rs.getString("serviceCenterId").charAt(0), rs.getString("observations"), rs.getDate("created"),
						rs.getString("createdBy"), rs.getString("crratedByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
				policy.setPolicyId(rs.getInt("policyId"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		// TODO Auto-generated method stub
		return policy;
	}

	@Override
	public String getJsonEqupmentCollectionByCustomer(String customer){
		String retVal = "";
		
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			
			ResultSet rs = conn.createStatement().executeQuery(String.format("CALL blackstarDb.GetEquipmentCollectionByCustomer('%s');", customer));

			retVal = ResultSetConverter.convertResultSetToJSONArray(rs).toString();
			
			conn.close();
			
		} catch (ClassNotFoundException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		} catch (SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		} catch (JSONException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		
		return retVal;
	}

	@Override
	public Policy getPolicyBySerialNo(String serialNo) {
		Policy policy = null;
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();

			ResultSet rs = conn.createStatement().executeQuery(String.format("CALL blackstarDb.GetPolicyBySerialNo('%s');", serialNo));
			while(rs.next()) {
				policy = new Policy( rs.getString("officeId").charAt(0), rs.getString("policyTypeId").charAt(0), rs.getString("customerContract"),
						rs.getString("customer"), rs.getString("finalUser"), rs.getString("project"), rs.getString("cst"),
						rs.getString("equipmentTypeId").charAt(0), rs.getString( "brand"), rs.getString("model"),
						rs.getString("serialNumber"), rs.getString("capacity"), rs.getString("equipmentAddress"),
						rs.getString("equipmentLocation"), rs.getString("contactName"), rs.getString("contactPhone"), rs.getString("contactEmail"),
						rs.getDate("startDate"),
						rs.getDate("endDate"), rs.getInt("visitsPerYear"), rs.getInt("responseTimeHr"),
						rs.getShort("solutionTimeHr"), rs.getString("penalty"), rs.getString("service"),
						rs.getBoolean("includesParts"), rs.getString("exceptionParts"),
						rs.getString("serviceCenterId").charAt(0), rs.getString("observations"), rs.getDate("created"),
						rs.getString("createdBy"), rs.getString("crratedByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
				policy.setPolicyId(rs.getInt("policyId"));
			}
			
		}
		 catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(conn != null){
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		// TODO Auto-generated method stub
		return policy;
	}

}

