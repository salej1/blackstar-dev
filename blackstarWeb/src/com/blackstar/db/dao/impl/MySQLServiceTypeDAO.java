package com.blackstar.db.dao.impl;

import java.sql.ResultSet;
import java.util.List;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.dao.interfaces.ServiceTypeDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Servicetype;
import com.blackstar.model.dto.ServiceTypeDTO;

public class MySQLServiceTypeDAO implements ServiceTypeDAO{

	@Override
	public Servicetype getServiceTypeById(char id) {
		String sql = "Select * from serviceType where serviceTypeId = '%s'";
		sql = String.format(sql, id);
		Servicetype st = null;
		
		BlackstarDataAccess da = new BlackstarDataAccess();
		ResultSet rs;
		try {
			rs = da.executeQuery(sql);
				
			if(rs.next()){
				String stId;
				String type;
				stId = rs.getString("serviceTypeId");
				type = rs.getString("serviceType");
				if(stId != null && type != null){
					st = new Servicetype(stId.toString().charAt(0), type);
				}
			}
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
		}
		finally{
			if(da != null){
				da.closeConnection();
			}
		}
		return st;
	}

	@Override
	public List<ServiceTypeDTO> getServiceTypeList() {
		// TODO Auto-generated method stub
		return null;
	}

}
