package com.codex.service;

import java.util.List;

import com.codex.model.dto.VisitDTO;
import com.codex.model.dto.VisitStatusDTO;

public interface VisitService {
	Integer upsertVisit(VisitDTO visit);
	List<VisitStatusDTO> getVisitaStatusList();	
	String getVisitListJson(); // ALL
	String getVisitListJson(String cstEmail); // Limited
	VisitDTO getVisitById(Integer visitId);
}
