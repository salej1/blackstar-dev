package com.blackstar.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.logging.*;



public class ManageDataAccess {

	public static void executeUpdate(String sql) throws Exception {
		Connection conn = null;
		
		try {
			conn = DbConnectionProvider.getConnection("blackstarManage");

			conn.createStatement().executeUpdate(sql);

			conn.close();

		} catch (Exception e) {
			// Utilizando el logger del container! no hay acceso a la BD
			Logger log = Logger.getLogger(BlackstarDataAccess.class.getName());
			log.log(Level.SEVERE, String.format(
					"Error al crear conexion a la base de datos: %s",
					e.getMessage()));
			throw e;
		}		
		finally{
			if(conn!= null){
				conn.close();
			}
		}
	}
}