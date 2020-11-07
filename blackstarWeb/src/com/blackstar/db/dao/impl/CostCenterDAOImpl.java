package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.CostCenterDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.CostCenter;
import com.blackstar.model.dto.CostCenterDTO;

public class CostCenterDAOImpl extends AbstractDAO implements CostCenterDAO {
	
	private static final String SP_ADD_COSTCENTER = "AddCostCenter";
	private static final String SP_GET_ALL_COSTCENTER_BY_OFFICE_ID = "GetAllCostCenterByOfficeId";

	public CostCenterDAOImpl() {
	}

	@Override
	public int insertCostCenter(CostCenter costCenter) {
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL ").append(SP_ADD_COSTCENTER).append("(?,?);");
		Object[] args = new Object[]{
				costCenter.getCostCenterId(),
				costCenter.getOfficeId()
		};
		
		return getJdbcTemplate().queryForInt(sqlBuilder.toString(), args);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CostCenter> getAllCostCenterByOfficeId(char office_id) {
		return (List<CostCenter>) getJdbcTemplate().query(
				"CALL "+SP_GET_ALL_COSTCENTER_BY_OFFICE_ID+"('"+office_id+"');",
				getMapperFor(CostCenter.class));
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CostCenterDTO> getAllCostCenterByOfficeIdDTO(char office_id) {
		return (List<CostCenterDTO>) getJdbcTemplate().query(
				"CALL "+SP_GET_ALL_COSTCENTER_BY_OFFICE_ID+"('"+office_id+"');",
				getMapperFor(CostCenterDTO.class));
	}

	@Override
	public List<JSONObject> getAllCostCenterByOfficeIdJSON(char office_id) {
		String sqlQuery = "CALL "+SP_GET_ALL_COSTCENTER_BY_OFFICE_ID+"('"+office_id+"');";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper());
	}

}
