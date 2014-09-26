package com.codex.db.impl;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.CstDAO;
import com.codex.model.dto.CstDTO;

public class CstDAOImpl extends AbstractDAO implements CstDAO{

	@Override
	public CstDTO getCstByEmail(String email) {
		String sql = "CALL GetCstByEmail(?)";
		
		return (CstDTO) getJdbcTemplate().queryForObject(sql, new Object[]{ email }, getMapperFor(CstDTO.class));
	}

}
