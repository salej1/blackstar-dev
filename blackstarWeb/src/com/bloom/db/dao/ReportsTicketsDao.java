package com.bloom.db.dao;

import java.util.List;

import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.exception.DAOException;

public interface ReportsTicketsDao {

	/**
	 * Obtener ESTADISTICAS DE LAS AREAS DE APOYO
	 * @return
	 * @throws DAOException
	 */
	public List<ReportTicketBean> getStatisticsByAreaSupport()
			throws DAOException;


}
