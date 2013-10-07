package com.blackstar.db.test;

import static org.junit.Assert.*;

import java.sql.ResultSet;

import org.junit.Test;

import com.blackstar.db.BlackstarDataAccess;

public class BlackstarDataAccessTest {

	@Test
	public final void testExecuteQuery() {
		String sql = "select * from ploicy";
		int count = 0;
		
		try {
			BlackstarDataAccess da = new BlackstarDataAccess();
			ResultSet res = da.executeQuery(sql);
						
			while(res.next()){
				count++;
			}
			
		} catch (Exception e) {
			fail(e.getMessage());
		}
		assertTrue("Cuenta de polizas en cero", count > 0);
	}

}
