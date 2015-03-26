package com.codex.db;

import java.util.List;

import com.codex.model.dto.CstDTO;

public interface CstDAO {
	public CstDTO getCstByEmail(String email); 
	public List<CstDTO> getAllCst();
}
