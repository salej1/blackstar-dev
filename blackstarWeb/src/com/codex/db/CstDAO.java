package com.codex.db;

import com.codex.model.dto.CstDTO;

public interface CstDAO {
	public CstDTO getCstByEmail(String email); 
}
