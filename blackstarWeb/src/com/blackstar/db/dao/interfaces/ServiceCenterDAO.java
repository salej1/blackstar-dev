package com.blackstar.db.dao.interfaces;

import java.util.List;

import com.blackstar.model.Servicecenter;

public interface ServiceCenterDAO {

	public Servicecenter findServiceCenter();
	public List<Servicecenter> selectAllServiceCenter();
	public Servicecenter getServiceCenterById(char id);
	public int insertServiceCenter();
	public boolean updateServiceCenter();
}
