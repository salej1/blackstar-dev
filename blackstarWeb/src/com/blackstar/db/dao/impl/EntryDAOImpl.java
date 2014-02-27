package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.EntryDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Entry;

import com.blackstar.model.dto.EntryDTO;

public class EntryDAOImpl extends AbstractDAO implements EntryDAO
{

	@SuppressWarnings("deprecation")
	@Override
	public int insertEntryt(Entry entry) {

		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL AddEntry(0,?,?,?,?,?,?,?,?);");
		Object[] args = new Object[]
		{
				entry.getType() + "",
				entry.getReference() + "",
				entry.getDescription() + "",
				entry.getAmount() + "",
				entry.getUnitPrice() + "",
				entry.getDiscount() + "",
				entry.getTotal() + "",
				entry.getObservations() + ""
		};
		return getJdbcTemplate().queryForInt(sqlBuilder.toString(), args);
	}

	@Override
	public EntryDTO getEntryById(Integer entryId) {
		EntryDTO entry = null;
		StringBuilder sqlBuilder = new StringBuilder();
		sqlBuilder.append("CALL GetEntryById(?)");
		entry = (EntryDTO) getJdbcTemplate().queryForObject(
				sqlBuilder.toString(), new Object[] { entryId },
				getMapperFor(EntryDTO.class));
		return entry;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<EntryDTO> getEntryList() {
		return (List<EntryDTO>) getJdbcTemplate().query(
				"CALL GetAllEntrys;",
				getMapperFor(EntryDTO.class));
	}

	@Override
	public List<JSONObject> getEntryJSON() {
		String sqlQuery = "CALL GetAllEntrys;";
		return getJdbcTemplate().query(sqlQuery, new JSONRowMapper());
	} 

}
