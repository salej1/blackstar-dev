package com.codex.db.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.codex.db.VisitDAO;
import com.codex.model.dto.VisitDTO;
import com.codex.model.dto.VisitStatusDTO;

public class VisitDAOImpl extends AbstractDAO implements VisitDAO {

	@Override
	public int upsertVisit(VisitDTO visit) {
		String sql = "CALL UpsertCodexVisit(?,?,?,?,?,?,?,?,?,?,?,?)";
		
		Integer visitId = (int)getJdbcTemplate().queryForObject(sql, new Object[]{
			visit.getCodexVisitId(),
			visit.getCstId(),
			visit.getCodexClientId(),
			visit.getVisitDate(),
			visit.getDescription(),
			visit.getVisitStatusId(),
			visit.getCreated(),
			visit.getCreatedBy(),
			visit.getCreatedByUsr(),
			visit.getModified(),
			visit.getModifiedBy(),
			visit.getModifiedByUsr()}, Integer.class);
		
		return visitId;
	}

	@Override
	public List<VisitStatusDTO> getVisitStatusList() {
		String sql = "CALL GetAllVisitStatus()";
		
		List<VisitStatusDTO> list = (List<VisitStatusDTO>) getJdbcTemplate().query(sql, getMapperFor(VisitStatusDTO.class));
		
		return list;
	}

	@Override
	public String getVisitListJson(){
		String sql = "CALL GetVisitList(NULL)";

		List<JSONObject> list = (List<JSONObject>)getJdbcTemplate().query(sql, new JSONRowMapper());

		return list.toString();
	}

	@Override
	public String getVisitListJson(String cstEmail){
		String sql = "CALL GetVisitList(?)";

		List<JSONObject> list = (List<JSONObject>)getJdbcTemplate().query(sql, new Object[]{cstEmail}, new JSONRowMapper());

		return list.toString();
	}

	@Override
	public VisitDTO getVisitById(Integer visitId){
		String sql = "CALL getVisitById(?)";

		VisitDTO visit = (VisitDTO)getJdbcTemplate().queryForObject(sql, new Object[]{visitId}, getMapperFor(VisitDTO.class));

		return visit;
	}

}
