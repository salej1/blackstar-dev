package com.codex.service;

import java.util.List;

import com.codex.model.dto.CstDTO;

public interface CstService {
	public CstDTO getCstByEmail(String email);
	public List<CstDTO> getAllCst();
}
