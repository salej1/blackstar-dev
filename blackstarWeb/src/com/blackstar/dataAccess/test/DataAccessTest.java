package com.blackstar.dataAccess.test;

import static org.junit.Assert.*;

import java.sql.*;

import org.junit.Test;

import com.blackstar.db.DataAccess;

public class DataAccessTest {

	@Test
	public final void testExecuteQuery() {
		String sql = "select * from ploicy";
		int count = 0;
		
		try {
			ResultSet res = DataAccess.executeQuery(sql);
						
			while(res.next()){
				count++;
			}
			
		} catch (Exception e) {
			fail(e.getMessage());
		}
		assertTrue("Cuenta de polizas en cero", count > 0);
	}
}
