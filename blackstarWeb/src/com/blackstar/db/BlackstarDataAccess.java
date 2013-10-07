package com.blackstar.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.logging.*;

public class BlackstarDataAccess {
	Connection conn = null;
	
	public ResultSet executeQuery(String sql) throws Exception {
		
		
		try {
			conn = DbConnectionProvider.getConnection("blackstarDb");

			ResultSet res = conn.createStatement().executeQuery(sql);
			
			return res;

		} catch (Exception e) {
			// Utilizando el logger del container! no hay acceso a la BD
			Logger log = Logger.getLogger(BlackstarDataAccess.class.getName());
			log.log(Level.SEVERE, String.format(
					"Error al crear conexion a la base de datos: %s",
					e.getMessage()));
			throw e;
		}		
	}
	
	public void closeConnection(){
		try{
			conn.close();
		}
		catch(Exception h){}
	}
	
	protected void finalize(){
		closeConnection();
	}
}