package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;

import com.blackstar.logging.*;
import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.dao.interfaces.PolicyDAO;
import com.blackstar.model.Policy;
import com.google.appengine.api.log.LogService.LogLevel;

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
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from policy");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				policy = new Policy(rs.getString("officeId").charAt(0), rs.getString("policyTypeId").charAt(0), rs.getString("customerContract"),
						rs.getString("customer"), rs.getString("finalUser"), rs.getString("project"), rs.getString("cst"),
						rs.getString("equipmentTypeId").charAt(0), rs.getString( "brand"), rs.getString("model"),
						rs.getString("serialNumber"), rs.getString("capacity"), rs.getString("equipmentAddress"),
						rs.getString("equipmentLocation"), rs.getInt("policyContactId"), rs.getDate("startDate"),
						rs.getDate("endDate"), rs.getInt("visitsPerYear"), rs.getByte("responseTimeHr"),
						rs.getShort("solutionTimeHr"), rs.getString("penalty"), rs.getString("service"),
						rs.getString("includesParts").getBytes()[0], rs.getString("exceptionParts"),
						rs.getString("serviceCenterId").charAt(0), rs.getString("observations"), rs.getDate("created"),
						rs.getString("createdBy"), rs.getString("crratedByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
				lstPolicy.add(policy);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from policy where policyId = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				policy = new Policy(rs.getString("officeId").charAt(0), rs.getString("policyTypeId").charAt(0), rs.getString("customerContract"),
						rs.getString("customer"), rs.getString("finalUser"), rs.getString("project"), rs.getString("cst"),
						rs.getString("equipmentTypeId").charAt(0), rs.getString( "brand"), rs.getString("model"),
						rs.getString("serialNumber"), rs.getString("capacity"), rs.getString("equipmentAddress"),
						rs.getString("equipmentLocation"), rs.getInt("policyContactId"), rs.getDate("startDate"),
						rs.getDate("endDate"), rs.getInt("visitsPerYear"), rs.getByte("responseTimeHr"),
						rs.getShort("solutionTimeHr"), rs.getString("penalty"), rs.getString("service"),
						rs.getString("includesParts").getBytes()[0], rs.getString("exceptionParts"),
						rs.getString("serviceCenterId").charAt(0), rs.getString("observations"), rs.getDate("created"),
						rs.getString("createdBy"), rs.getString("crratedByUsr"), rs.getDate("modified"),
						rs.getString("modifiedBy"), rs.getString("modifiedByUsr"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO Auto-generated method stub
		return policy;
	}

	@Override
	public String getJsonEqupmentCollectionByCustomer(String customer){
		String retVal = "";
		
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			
			PreparedStatement ps = conn.prepareStatement(String.format("CALL blackstarDb.GetEquipmentCollectionByCustomer('%s');", customer));

			ResultSet rs = ps.executeQuery();
			
			retVal = ResultSetConverter.convertResultSetToJSONArray(rs).toString();
			
			conn.close();
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			Logger.Log(com.blackstar.logging.LogLevel.ERROR, e);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return retVal;
	}
}
