package com.blackstar.db.dao.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Entry;
import com.blackstar.model.dto.EntryDTO;
import com.blackstar.model.dto.ServiceTypeDTO;


public interface EntryDAO {
	public int insertEntryt(Entry entry);

	public EntryDTO getEntryById(Integer entryId);

	public List<EntryDTO> getEntryList();

	public List<JSONObject> getEntryJSON();
	
	public List<ServiceTypeDTO> getServiceTypeList();



}
