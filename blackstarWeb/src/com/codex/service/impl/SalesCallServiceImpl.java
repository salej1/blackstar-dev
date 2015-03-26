package com.codex.service.impl;

import java.util.List;

import com.blackstar.model.dto.WarrantProjectDTO;
import com.blackstar.services.interfaces.SalesService;
import com.codex.db.SalesCallDAO;
import com.codex.service.SalesCallService;

public class SalesCallServiceImpl implements SalesCallService {
	
	private SalesCallDAO dao;
	
	public void setDao(SalesCallDAO dao) {
		this.dao = dao;
	}

	@Override
	public void recordSalesCall(String cstEmail) {
		dao.recordSalesCall(cstEmail);
	}


}
