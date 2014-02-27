package com.blackstar.services.interfaces;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.model.Entry;
import com.blackstar.model.dto.EntryDTO;

public interface EntryService {
	public EntryDTO getEntryById(Integer entryId);
	
	public int saveEntryt(Entry entry);

	public List<EntryDTO> getEntryList();

	public String getEntryJSON();
}
