package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.ServiceCenterDAO;
import com.blackstar.model.Servicecenter;

public class MySQLServiceCenterDAO implements ServiceCenterDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4137438371500773507L;

	@Override
	public Servicecenter findServiceCenter() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Servicecenter> selectAllServiceCenter() {
		List<Servicecenter> lstServiceCenter = new ArrayList<Servicecenter>();
		Servicecenter serviceCenter = null;
		Connection conn = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from serviceCenter");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				serviceCenter = new Servicecenter(rs.getString("serviceCenterId").charAt(0), rs.getString("serviceCenter"), rs.getString("serviceCenterEmail"));
				lstServiceCenter.add(serviceCenter);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
		return lstServiceCenter;
	}

	@Override
	public int insertServiceCenter() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateServiceCenter() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Servicecenter getServiceCenterById(char id) {
		Servicecenter serviceCenter = null;
		Connection conn  = null;
		try {
			conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from serviceCenter where serviceCenterId = ?");
			ps.setString(1, Character.toString(id));
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				serviceCenter = new Servicecenter(rs.getString("serviceCenterId").charAt(0), rs.getString("serviceCenter"), rs.getString("serviceCenterEmail"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
		return serviceCenter;
	}

}
