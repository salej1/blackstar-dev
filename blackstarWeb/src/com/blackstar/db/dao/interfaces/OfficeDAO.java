package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Office;

public interface OfficeDAO {

	public Office findOffice();
	public List<Office> selectAllOffice();
	public Office getOfficeById(char id);
	public int insertOffice();
	public boolean updateOffice();
}
