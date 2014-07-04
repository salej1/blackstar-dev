package com.codex.db;

import java.util.List;

import com.codex.vo.CurrencyTypesVO;
import com.codex.vo.ProjectEntryItemTypesVO;
import com.codex.vo.ProjectEntryTypesVO;
import com.codex.vo.TaxesTypesVO;

public interface ProjectDAO {
	
	public List<ProjectEntryTypesVO> getAllEntryTypes();
	public List<ProjectEntryItemTypesVO> getAllEntryItemTypes();
	public List<CurrencyTypesVO> getAllCurrencyTypes();
	public List<TaxesTypesVO> getAllTaxesTypes();

}
