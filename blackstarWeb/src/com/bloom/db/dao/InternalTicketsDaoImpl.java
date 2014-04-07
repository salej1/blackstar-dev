package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.bloom.common.bean.CatalogoBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.mapper.CatalogoMapper;

public class InternalTicketsDaoImpl extends AbstractDAO implements
		InternalTicketsDao {

	private static final String perfilCodinador = "Error al consultar el catálogo";

	private static final String QUERY_TICKETS_PENDIENTES = "CALL getBloomPendingTickets(%s)";

	private static final String QUERY_INSERT_NEW_TICKET = "insert into bloomTicket ("
			+ " applicantUserId,officeId,serviceTypeId,statusId,applicantAreaId,dueDate,project,ticketNumber,description,created,createdBy,createdByUsr) "
			+ " values ("
			+ " :applicantUserId,:officeId,:serviceTypeId,:statusId,:applicantAreaId,:dueDate,:project,:ticketNumber,:description,:created,:createdBy,:createdByUsr)";

	private static final String ERROR_CONSULTA = "Error al consultar el catálogo";

	private static final String EMPTY_CONSULTA = "No se encontraron registros";

	private static final class InternalTicketMapper implements
			RowMapper<InternalTicketBean> {

		@Override
		public InternalTicketBean mapRow(ResultSet rs, int rowNum)
				throws SQLException {
			// log.debug(rowNum + ": Ticket=" + rs.getString("ticketNumber"));
			InternalTicketBean ticket = new InternalTicketBean();

			ticket.setId(rs.getLong("id"));
			ticket.setTicketNumber(rs.getString("ticketNumber"));
			ticket.setCreated(rs.getTimestamp("created"));
			ticket.setCreatedStr(DataTypeUtil
					.formatearFechaDD_MM_AAAA_HH_MM_SS(rs
							.getTimestamp("created")));
			ticket.setPetitionerArea(rs.getString("areaName"));
			ticket.setPetitionerAreaId(rs.getInt("applicantAreaId"));
			ticket.setServiceTypeDescr(rs.getString("serviceName"));
			ticket.setServiceTypeId(rs.getInt("serviceTypeId"));

			// responseTime
			ticket.setDeadline(rs.getTimestamp("created"));
			ticket.setDeadlineStr(DataTypeUtil.formatearFechaDD_MM_AAAA(ticket
					.getCreated()));

			ticket.setProject(rs.getString("project"));
			ticket.setOfficeName(rs.getString("officeId"));
			ticket.setOfficeId(rs.getString("officeId"));

			return ticket;
		}
	}

	@Override
	public List<InternalTicketBean> getPendingTickets(Long userId)
			throws DAOException {

		List<InternalTicketBean> listaRegistros = new ArrayList<InternalTicketBean>();

		try {

			listaRegistros.addAll(getJdbcTemplate().query(
					String.format(QUERY_TICKETS_PENDIENTES, userId),
					new InternalTicketMapper()));

			return listaRegistros;

		} catch (EmptyResultDataAccessException e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			return Collections.emptyList();
		} catch (DataAccessException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}

	}

	@Override
	public Long registrarNuevoTicket(InternalTicketBean ticket)
			throws DAOException {

		// Insertamos el registro en caso de que no exista
		MapSqlParameterSource bindValues = new MapSqlParameterSource();
		agregarParametrosTicket(ticket, bindValues);
		KeyHolder keyHolder = new GeneratedKeyHolder();

		try {

			getJdbcTemplate().update(QUERY_INSERT_NEW_TICKET, bindValues,
					keyHolder);

		} catch (Exception e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			throw new DAOException("Error en DAO");
		}

		return Long.parseLong(keyHolder.getKey().toString());
	}

	private void agregarParametrosTicket(InternalTicketBean ticket,
			MapSqlParameterSource params) {
		//34,'Q',4,1,4,CURDATE(),'CM267','SAC124','ggggggggggggg',CURDATE(),'Oscar 2',35

		 ticket.setApplicantUserId(34L);
		 ticket.setOfficeId("Q");
		 ticket.setServiceTypeId(4);
		 ticket.setStatusId(1);
		 ticket.setApplicantAreaId(4);
		 ticket.setDeadline(new Date());
		 ticket.setProject("CM267");
		 ticket.setTicketNumber("SAC124");
		 ticket.setDescription("ggggggggggggg");
		 ticket.setCreated(new Date());
		 ticket.setCreatedUserName("Oscar 2");
		 ticket.setCreatedUserId(35L);

		if (ticket.getApplicantAreaId() == null) {
			params.addValue("applicantUserId", null);
		} else {
			params.addValue("applicantUserId", ticket.getApplicantUserId());
		}

		if (ticket.getOfficeId() == null || ticket.getOfficeId().isEmpty()) {
			params.addValue("officeId", null);
		} else {
			params.addValue("officeId", ticket.getOfficeId());
		}

		if (ticket.getServiceTypeId() == null) {
			params.addValue("serviceTypeId", null);
		} else {
			params.addValue("serviceTypeId", ticket.getServiceTypeId());
		}

		if (ticket.getStatusId() == null) {
			params.addValue("statusId", null);
		} else {
			params.addValue("statusId", ticket.getStatusId());
		}

		if (ticket.getApplicantAreaId() == null) {
			params.addValue("applicantAreaId", null);
		} else {
			params.addValue("applicantAreaId", ticket.getApplicantAreaId());
		}

		
		java.sql.Date d=new java.sql.Date(ticket.getDeadline().getTime());
		
		if (ticket.getDeadline() == null) {
			params.addValue("dueDate", null);
		} else {
			params.addValue("dueDate", d);
		}

		if (ticket.getProject() == null || ticket.getProject().isEmpty()) {
			params.addValue("project", null);
		} else {
			params.addValue("project", ticket.getProject());
		}

		if (ticket.getCreatedUserName() == null
				|| ticket.getCreatedUserName().isEmpty()) {
			params.addValue("ticketNumber", null);
		} else {
			params.addValue("ticketNumber", ticket.getTicketNumber());
		}

		if (ticket.getDescription() == null
				|| ticket.getDescription().isEmpty()) {
			params.addValue("description", null);
		} else {
			params.addValue("description", ticket.getDescription());
		}

		if (ticket.getCreated() == null) {
			params.addValue("created", null);
		} else {
			params.addValue("created", d);
		}

		if (ticket.getCreatedUserName() == null
				|| ticket.getCreatedUserName().isEmpty()) {
			params.addValue("createdBy", null);
		} else {
			params.addValue("createdBy", ticket.getCreatedUserName());
		}

		if (ticket.getCreatedUserId() == null) {
			params.addValue("createdByUsr", null);
		} else {
			params.addValue("createdByUsr", ticket.getCreatedUserId());
		}

		// if (ticket.getReponseInTime() == null) {
		// params.addValue("reponseInTime", null);
		// } else {
		// params.addValue("reponseInTime", ticket.getReponseInTime());
		// }

	}

}
