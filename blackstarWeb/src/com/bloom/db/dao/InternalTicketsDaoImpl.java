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
import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.common.bean.TicketTeamBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.mapper.CatalogoMapper;

public class InternalTicketsDaoImpl extends AbstractDAO implements
		InternalTicketsDao {

	private static final String QUERY_TICKETS_PENDIENTES = "CALL getBloomPendingTickets(%d)";
	private static final String QUERY_TICKETS = "CALL getBloomTickets(%d)";

	private static final String QUERY_HISTORICAL_TICKETS = "SELECT"
			+ " ti._id as id,"
			+ " ti.ticketNumber,"
			+ " ti.created,"
			+ " ti.applicantAreaId,"
			+ " ba.name as areaName,"
			+ " ti.serviceTypeId,"
			+ " st.name as serviceName,"
			+ " st.responseTime,"
			+ " ti.project,"
			+ " ti.officeId,"
			+ " o.officeName,"
			+ " ti.statusId,"
			+ " s.name as statusTicket"
			+ " FROM bloomticket ti"
			+ " INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId)"
			+ " INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId)"
			+ " INNER JOIN office o on (o.officeId = ti.officeId)"
			+ " INNER JOIN bloomStatusType s on (s._id = ti.statusId)"
			+ " WHERE ti.created>= '%fechaIni%' "
			+ " AND ti.created <= '%fechaFin%'";

	private static final String QUERY_TICKET_NUMBER = "CALL GetNextInternalTicketNumber()";

	private static final String ERROR_CONSULTA = "Error al consultar el cat�logo";

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
			ticket.setOfficeName(rs.getString("officeName"));
			ticket.setOfficeId(rs.getString("officeId"));

			ticket.setStatusId(rs.getInt("statusId"));
			ticket.setStatusDescr(rs.getString("statusTicket"));

			return ticket;
		}
	}

	@Override
	public String generarTicketNumber() throws DAOException {

		String ticketNumber = "";

		try {

			ticketNumber = getJdbcTemplate().queryForObject(
					QUERY_TICKET_NUMBER, String.class);

			return ticketNumber;

		} catch (DataAccessException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException("Error al generar numero de ticket", e);
		}
	}

	/**
	 * Tickets asignados a un perfil y usuario
	 */
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

	/**
	 * Vista para el coordinador
	 * 
	 * @param userId
	 * @return
	 * @throws DAOException
	 */
	@Override
	public List<InternalTicketBean> getTickets(Long userId) throws DAOException {

		List<InternalTicketBean> listaRegistros = new ArrayList<InternalTicketBean>();

		try {

			listaRegistros.addAll(getJdbcTemplate().query(
					String.format(QUERY_TICKETS, userId),
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

	/**
	 * Vista del reporte de historico del ticket para mesa de ayuda.
	 * 
	 * @param userId
	 * @return
	 * @throws DAOException
	 */
	@Override
	public List<InternalTicketBean> getHistoricalTickets(String fechaIni,
			String fechaFin, Integer idStatusTicket, Long idResponsable)
			throws DAOException {

		List<InternalTicketBean> listaRegistros = new ArrayList<InternalTicketBean>();

		try {
			
			StringBuilder sq = new StringBuilder();
			sq.append(QUERY_HISTORICAL_TICKETS.replace("%fechaIni%",fechaIni).replace("%fechaFin%",fechaFin));
			
			if(idStatusTicket!=-1){
				sq.append(" AND ti.statusId=");
				sq.append(idStatusTicket);
			}
			
			if(idResponsable!=-1){
				sq.append(" AND ti._id in (SELECT tm.ticketId FROM bloomticketteam tm WHERE tm.blackstarUserId=");
				sq.append(idResponsable);
				sq.append(" AND tm.workerRoleTypeId=1)");
			}
			
			sq.append(" ORDER BY ti.created DESC");

			listaRegistros.addAll(getJdbcTemplate().query(sq.toString(),new InternalTicketMapper()));

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

		StringBuilder sqlBuilder = new StringBuilder();

		sqlBuilder.append("CALL AddInternalTicket(?,?,?,?,?,?,?,?,?,?,?,?,?)");

		int idTicket = 0;

		try {

			Object[] args = new Object[] { ticket.getApplicantUserId(),
					ticket.getOfficeId(), ticket.getServiceTypeId(),
					ticket.getStatusId(), ticket.getApplicantAreaId(),
					ticket.getDeadline(), ticket.getProject(),
					ticket.getTicketNumber(), ticket.getDescription(),
					ticket.getCreated(), ticket.getCreatedUserName(),
					ticket.getCreatedUserId(), ticket.getReponseInTime() };

			idTicket = getJdbcTemplate().queryForInt(sqlBuilder.toString(),
					args);

		} catch (Exception e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			throw new DAOException("Error en DAO");
		}

		return (long) idTicket;
	}

	@Override
	public Long registrarDocumentTrace(DeliverableTraceBean document)
			throws DAOException {

		StringBuilder sqlBuilder = new StringBuilder();

		sqlBuilder.append("CALL AddDeliverableTrace(?,?,?,?)");

		int idTicket = 0;

		try {

			Object[] args = new Object[] { document.getTicketId(),
					document.getDeliverableId(), document.getDelivered(),
					document.getDeliverableDate() };

			idTicket = getJdbcTemplate().queryForInt(sqlBuilder.toString(),
					args);

		} catch (Exception e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			throw new DAOException("Error en DAO");
		}

		return (long) idTicket;
	}

	@Override
	public Long registrarMiembroTicket(TicketTeamBean teamMember)
			throws DAOException {

		StringBuilder sqlBuilder = new StringBuilder();

		sqlBuilder.append("CALL AddMemberTicketTeam(?,?,?)");

		int idTeamMemberTicket = 0;

		try {

			Object[] args = new Object[] { teamMember.getIdTicket(),
					teamMember.getWorkerRoleId(), teamMember.getUserId() };

			idTeamMemberTicket = getJdbcTemplate().queryForInt(
					sqlBuilder.toString(), args);

		} catch (Exception e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			throw new DAOException("Error en DAO");
		}

		return (long) idTeamMemberTicket;
	}

}