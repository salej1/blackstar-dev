package com.blackstar.db;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.logging.*;
import com.google.cloud.sql.jdbc.*;

public class DataAccess {

	public static ResultSet executeQuery(String sql) throws Exception {

		try {
			Class.forName("com.mysql.jdbc.GoogleDriver");

			String url = DBConnectionString.getConnectionString();
			
			Connection conn = (Connection) DriverManager.getConnection(url);
			
			PreparedStatement stmt = conn.prepareStatement(sql);

			ResultSet res = stmt.executeQuery();

			conn.close();

			return res;
			
		} catch (Exception e) {
			// Utilizando el logger del container! no hay acceso a la BD
			Logger log = Logger.getLogger(DataAccess.class.getName());
			log.log(Level.SEVERE, String.format(
					"Error al crear conexion a la base de datos: %s",
					e.getMessage()));
			throw e;
		}

	}
}
