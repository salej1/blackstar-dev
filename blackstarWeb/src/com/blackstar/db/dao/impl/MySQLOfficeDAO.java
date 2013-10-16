package com.blackstar.db.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.blackstar.db.dao.interfaces.OfficeDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Office;

public class MySQLOfficeDAO implements OfficeDAO, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4137438371500773507L;

	@Override
	public Office findOffice() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Office> selectAllOffice() {
		List<Office> lstOffice = new ArrayList<Office>();
		Office office = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from office");
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				office = new Office(rs.getString("officeId").charAt(0), rs.getString("officeName"), rs.getString("officeEmail"));
				lstOffice.add(office);
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		// TODO Auto-generated method stub
		return lstOffice;
	}

	@Override
	public int insertOffice() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateOffice() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Office getOfficeById(char id) {
		Office office = null;
		try {
			Connection conn = MySQLDAOFactory.createConnection();
			PreparedStatement ps = conn.prepareStatement("Select * from office where officeId = ?");
			ps.setString(1, Character.toString(id));
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				office = new Office(rs.getString("officeId").charAt(0), rs.getString("officeName"), rs.getString("officeEmail"));
						
			}
		} catch (ClassNotFoundException | SQLException e) {
			Logger.Log(LogLevel.CRITICAL, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		// TODO Auto-generated method stub
		return office;
	}

}
