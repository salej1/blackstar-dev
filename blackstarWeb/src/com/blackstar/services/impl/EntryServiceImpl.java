package com.blackstar.services.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.EntryDAO;
import com.blackstar.model.Entry;
import com.blackstar.model.dto.EntryDTO;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.EntryService;

public class EntryServiceImpl extends AbstractService implements
EntryService{
	private EntryDAO dao = null;

	public EntryDAO getDao() {
		return dao;
	}

	@Override
	public EntryDTO getEntryById(Integer entryId) {
		return dao.getEntryById(entryId);
	}

	@Override
	public int saveEntryt(Entry entry) {
		return dao.insertEntryt(entry);
	}

	@Override
	public List<EntryDTO> getEntryList() {
		return dao.getEntryList();
	}

	@Override
	public String getEntryJSON() {
		List<JSONObject> entrys = dao.getEntryJSON();
		return entrys.toString();
	}

}
