package com.codex.db.impl;

import java.util.Date;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.SalesCallDAO;

public class SalesCallDAOImpl extends AbstractDAO implements SalesCallDAO {

	@Override
	public void recordSalesCall(String cstEmail) {
		String sql = "CALL RecordSalesCall(?,?)";
				
		getJdbcTemplate().update(sql, new Object[]{cstEmail, new Date()});	

	}
}
