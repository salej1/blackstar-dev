package com.blackstar.dataAccess.test;

import static org.junit.Assert.*;

import java.sql.ResultSet;
import java.sql.SQLException;

import junit.framework.Assert;

import org.junit.Test;

import com.blackstar.dataAccess.dataAccess;

public class dataAccessTest {

	@SuppressWarnings("deprecation")
	@Test
	public final void testExecuteQuery() {
		String sql = "select * from ploicy";
		try {
			ResultSet res = dataAccess.executeQuery(sql);
			
			int count=0;
			
			while(res.next()){
				count++;
			}
			
		} catch (SQLException e) {
			Assert.fail(e.getMessage());
		}
	}

}
