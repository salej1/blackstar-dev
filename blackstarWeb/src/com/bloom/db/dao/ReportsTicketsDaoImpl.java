package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.json.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.bloom.common.bean.ReportTicketBean;
import com.bloom.common.exception.DAOException;

@SuppressWarnings("unchecked")
public class ReportsTicketsDaoImpl extends AbstractDAO implements
		ReportsTicketsDao {

	private static final String QUERY_STATISTICS_AREA = "CALL GetBloomStatisticsByAreaSupport(%d,'%s','%s','%s')";

	private static final String QUERY_SUPPORT_AREAS = "CALL GetBloomSupportAreasWithTickets('%s','%s')";

	private static final String QUERY_PORCENT_TIMECLOSE = "CALL GetBloomPercentageTimeClosedTickets('%s','%s')";

	private static final String QUERY_PORCENT_EVALUATION = "CALL GetBloomPercentageEvaluationTickets(%d,'%s','%s')";

	private static final String QUERY_TICKETS_AREAS = "CALL GetBloomNumberTicketsByArea('%s','%s')";

	private static final String QUERY_UNSATISFATORY_AREA = "CALL GetBloomUnsatisfactoryTicketsByUserByArea(%d,%d,'%s','%s')";

	private static final String ERROR_CONSULTA = "Error al consultar el catálogo";

	private static final String EMPTY_CONSULTA = "No se encontraron registros";

	private static final Integer INIT_EVALUATION_SATISFACTORY = 7;

	private static final Integer AREA_ENGINEERING_SERVICE = 5;

	private static final class InternalTicketMapper implements
			RowMapper<ReportTicketBean> {

		private String nameStoreProcedure;

		private DecimalFormat df = new DecimalFormat();

		public InternalTicketMapper(String nameStoreProcedure) {
			this.nameStoreProcedure = nameStoreProcedure;
			df.setMaximumFractionDigits(2);
		}

		@Override
		public ReportTicketBean mapRow(ResultSet rs, int rowNum)
				throws SQLException {

			ReportTicketBean bean = new ReportTicketBean();

			if (nameStoreProcedure.equals("GetBloomSupportAreasWithTickets")) {
				bean.setValue5(rs.getInt("UserGroupId"));
				bean.setValue1(rs.getString("name"));
			} else if (nameStoreProcedure
					.equals("GetBloomStatisticsByAreaSupport")) {

				bean.setValue1(rs.getString("groupName"));
				bean.setValue2(df.format(rs.getFloat("maxTime")));
				bean.setValue3(df.format(rs.getFloat("minTime")));
				bean.setValue4(df.format(rs.getFloat("promTime")));

			} else if (nameStoreProcedure
					.equals("GetBloomPercentageTimeClosedTickets")
					|| nameStoreProcedure
							.equals("GetBloomPercentageEvaluationTickets")) {

				bean.setValue1(df.format(rs.getFloat("satisfactoryPercentage"))
						+ "%");
				bean.setValue2(df.format(rs
						.getFloat("unsatisfactoryPercentage")) + "%");

			} else if (nameStoreProcedure.equals("GetBloomNumberTicketsByArea")) {

				bean.setValue2(rs.getString("noTickets"));
				bean.setValue1(rs.getString("userGroup"));

			} else if (nameStoreProcedure
					.equals("GetBloomUnsatisfactoryTicketsByUserByArea")) {

				bean.setValue2(rs.getString("noTickets"));
				bean.setValue1(rs.getString("userName"));

			}

			return bean;
		}
	}

	public List<JSONObject> getStatisticsByAreaSupport(Date startCreation, Date endCreation)
			throws DAOException {
		String sql = "CALL GetBloomStatisticsByAreaSupport(?,?)";
		
		return getJdbcTemplate().query(sql, new Object[]{startCreation, endCreation}, new JSONRowMapper());
	}

	public List<ReportTicketBean> getStatisticsByHelpDesk(String startCreation, String endCreation) throws DAOException {

		List<ReportTicketBean> listStatistics = new ArrayList<ReportTicketBean>();

		try {

			listStatistics = getJdbcTemplate()
					.query(String.format(QUERY_STATISTICS_AREA, 4,
							"Mesa de Ayuda",startCreation,endCreation),
							new InternalTicketMapper(
									"GetBloomStatisticsByAreaSupport"));

			return listStatistics;

		} catch (EmptyResultDataAccessException e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			

			listStatistics = new ArrayList<ReportTicketBean>();

			return listStatistics;
		} catch (DataAccessException e) {
			System.out.println("Error => " + e);
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}
	}

	public List<ReportTicketBean> getPercentageTimeClosedTickets(String startCreation, String endCreation)
			throws DAOException {

		List<ReportTicketBean> listData = new ArrayList<ReportTicketBean>();

		ReportTicketBean inTime = new ReportTicketBean();

		ReportTicketBean outTime = new ReportTicketBean();

		ReportTicketBean data = new ReportTicketBean();

		try {

			List<ReportTicketBean> listPorcent = getJdbcTemplate().query(
					String.format(QUERY_PORCENT_TIMECLOSE,startCreation,endCreation),
					new InternalTicketMapper(
							"GetBloomPercentageTimeClosedTickets"));

			data = listPorcent.get(0);

			inTime.setValue1("Tickets cerrados en tiempo");
			inTime.setValue2(data.getValue1());

			outTime.setValue1("Tickets cerrados fuera de tiempo");
			outTime.setValue2(data.getValue2());

			listData.add(inTime);
			listData.add(outTime);

		} catch (DataAccessException e) {
			
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}

		return listData;

	}

	public List<ReportTicketBean> getPercentageEvaluationTickets(String startCreation, String endCreation)
			throws DAOException {

		List<ReportTicketBean> listData = new ArrayList<ReportTicketBean>();

		ReportTicketBean satisfactoryPercentage = new ReportTicketBean();

		ReportTicketBean unsatisfactoryPercentage = new ReportTicketBean();

		ReportTicketBean data = new ReportTicketBean();

		try {

			List<ReportTicketBean> listPorcent = getJdbcTemplate().query(
					String.format(QUERY_PORCENT_EVALUATION,
							INIT_EVALUATION_SATISFACTORY,startCreation,endCreation),
					new InternalTicketMapper(
							"GetBloomPercentageEvaluationTickets"));

			data = listPorcent.get(0);

			satisfactoryPercentage
					.setValue1("Tickets evaluados satisfactoriamente");
			satisfactoryPercentage.setValue2(data.getValue1());

			unsatisfactoryPercentage
					.setValue1("Tickets evaluados no satisfactoriamente");
			unsatisfactoryPercentage.setValue2(data.getValue2());

			listData.add(satisfactoryPercentage);
			listData.add(unsatisfactoryPercentage);

		} catch (DataAccessException e) {
			
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}

		return listData;

	}

	public List<ReportTicketBean> getNumberTicketsByArea(String startCreation, String endCreation) throws DAOException {

		List<ReportTicketBean> listData = new ArrayList<ReportTicketBean>();

		try {

			listData = getJdbcTemplate().query(String.format(QUERY_TICKETS_AREAS,startCreation,endCreation),
					new InternalTicketMapper("GetBloomNumberTicketsByArea"));

			return listData;

		} catch (EmptyResultDataAccessException e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			

			listData = new ArrayList<ReportTicketBean>();

			return listData;
		} catch (DataAccessException e) {
			System.out.println("Error => " + e);
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}

	}

	public List<JSONObject> getUnsatisfactoryTicketsByUserEngineeringService(Date startDate, Date endDate)
			throws DAOException {
		
		String sql = "CALL GetBloomUnsatisfactoryTicketsByUserByArea(?,?)";
		
		return getJdbcTemplate().query(sql, new Object[]{startDate, endDate}, new JSONRowMapper());
	}

}