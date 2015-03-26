package com.codex.service.impl;

import java.util.List;

import com.codex.db.CstDAO;
import com.codex.model.dto.CstDTO;
import com.codex.service.CstService;

public class CstServiceImpl implements CstService {

	private CstDAO dao;

	public void setDao(CstDAO dao) {
		this.dao = dao;
	}
	
	@Override
	public CstDTO getCstByEmail(String email) {
		return dao.getCstByEmail(email);
	}

	@Override
	public List<CstDTO> getAllCst() {
		return dao.getAllCst();
	}
}
