package com.codex.db.impl;

import java.util.List;

import com.blackstar.db.dao.AbstractDAO;
import com.codex.db.CstDAO;
import com.codex.model.dto.CstDTO;

public class CstDAOImpl extends AbstractDAO implements CstDAO{

	@Override
	public CstDTO getCstByEmail(String email) {
		String sql = "CALL GetCstByEmail(?)";
		
		List<CstDTO> res = (List<CstDTO>) getJdbcTemplate().query(sql, new Object[]{ email }, getMapperFor(CstDTO.class));
		
		if(res.size() > 0){
			return res.get(0);
		}
		else{
			return null;
		}
	}

	@Override
	public List<CstDTO> getAllCst() {
		String sql = "CALL GetAllCst()";
		
		return (List<CstDTO>) getJdbcTemplate().query(sql, getMapperFor(CstDTO.class));
	}

}
