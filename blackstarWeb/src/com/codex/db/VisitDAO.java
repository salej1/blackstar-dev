package com.codex.db;

import java.util.List;

import com.codex.model.dto.VisitDTO;
import com.codex.model.dto.VisitStatusDTO;

public interface VisitDAO {
	public int upsertVisit(VisitDTO visit);
	public List<VisitStatusDTO> getVisitStatusList();
	public String getVisitListJson(); // ALL
	public String getVisitListJson(String cstEmail); // Limited
	public VisitDTO getVisitById(Integer visitId);
}
