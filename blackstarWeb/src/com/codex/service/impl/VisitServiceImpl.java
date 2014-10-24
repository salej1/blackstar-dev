package com.codex.service.impl;

import java.util.List;

import com.codex.db.VisitDAO;
import com.codex.model.dto.VisitDTO;
import com.codex.model.dto.VisitStatusDTO;
import com.codex.service.VisitService;

public class VisitServiceImpl implements VisitService {
	VisitDAO dao;

	public void setDao(VisitDAO dao) {
		this.dao = dao;
	}

	@Override
	public Integer upsertVisit(VisitDTO visit) {
		return dao.upsertVisit(visit);
	}

	@Override
	public List<VisitStatusDTO> getVisitaStatusList() {
		return dao.getVisitStatusList();
	}

	@Override
	public String getVisitListJson(){
		return dao.getVisitListJson();
	}

	@Override
	public String getVisitListJson(String cstEmail){
		return dao.getVisitListJson(cstEmail);
	}

	@Override
	public VisitDTO getVisitById(Integer visitId){
		return dao.getVisitById(visitId);
	}
}
