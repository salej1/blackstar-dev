package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
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
import com.blackstar.model.Followup;
import com.blackstar.model.User;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.bloom.common.bean.DeliverableTraceBean;
import com.bloom.common.bean.InternalTicketBean;
import com.bloom.model.dto.DeliverableFileDTO;
import com.bloom.model.dto.DeliverableTypeDTO;
import com.bloom.model.dto.PendingAppointmentsDTO;
import com.bloom.model.dto.PendingSurveysDTO;
import com.bloom.model.dto.TicketDetailDTO;
import com.bloom.model.dto.TicketTeamDTO;
import com.bloom.common.bean.TicketTeamBean;
import com.bloom.common.exception.DAOException;
import com.bloom.common.utils.DataTypeUtil;
import com.bloom.db.dao.mapper.CatalogoMapper;

@SuppressWarnings("unchecked")
public class InternalTicketsDaoImpl extends AbstractDAO implements InternalTicketsDao {


	private static final String QUERY_TICKETS_PENDIENTES = "CALL getBloomPendingTickets(%d)";
	private static final String QUERY_TICKETS = "CALL getBloomTickets(%d)";

	private static final String QUERY_HISTORICAL_TICKETS = "CALL GetBloomHistoricalTickets(%d,'%s','%s',%d)";

	private static final String QUERY_TICKET_NUMBER = "CALL GetNextInternalTicketNumber()";

	private static final String ERROR_CONSULTA = "Error al consultar el catálogo";

	private static final String EMPTY_CONSULTA = "No se encontraron registros";

	public List<TicketDetailDTO> getTicketDetail(Integer ticketId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomTicketDetail(?);");
		return (List<TicketDetailDTO>) getJdbcTemplate().query(
				sqlBuilder.toString(), new Object[] { ticketId },
				getMapperFor(TicketDetailDTO.class));
	}

	public Integer getTicketId(String ticketNumber) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomTicketId(?);");
		return getJdbcTemplate().queryForInt(sqlBuilder.toString(),
				new Object[] { ticketNumber });
	}

	public List<TicketTeamDTO> getTicketTeam(Integer ticketId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomTicketTeam(?);");
		return (List<TicketTeamDTO>) getJdbcTemplate().query(
				sqlBuilder.toString(), new Object[] { ticketId },
				getMapperFor(TicketTeamDTO.class));
	}

	public List<User> getAsigneedUser(Integer ticketId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomTicketResponsible(?);");
		return (List<User>) getJdbcTemplate().query(sqlBuilder.toString(),
				new Object[] { ticketId }, getMapperFor(User.class));
	}

	public List<User> getResponseUser(Integer ticketId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomTicketUserForResponse(?);");
		return (List<User>) getJdbcTemplate().query(sqlBuilder.toString(),
				new Object[] { ticketId }, getMapperFor(User.class));
	}

	public void addFollowUp(Integer ticketId, String asignee, String sender, String comment) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL AddFollowUpToBloomTicket(?, ?, ? ,?);");
		getJdbcTemplate().update(sqlBuilder.toString(),
				new Object[] { ticketId, asignee, sender, comment });
	}

	public void addTicketTeam(Integer ticketId, Integer roleId, String userId, String userGroup) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL AddMemberTicketTeam(?, ?, ?, ?);");
		getJdbcTemplate().update(sqlBuilder.toString(),
				new Object[] { ticketId, roleId, userId, userGroup });
	}

	public List<Followup> getFollowUps(Integer ticketId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomFollowUpByTicket(?);");
		return (List<Followup>) getJdbcTemplate().query(sqlBuilder.toString(),
				new Object[] { ticketId }, getMapperFor(Followup.class));
	}

	public List<DeliverableTypeDTO> getDeliverableTypes(Integer ticketTypeId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL GetBloomDeliverableType(?);");
		return (List<DeliverableTypeDTO>) getJdbcTemplate().query(
				sqlBuilder.toString(), new Object[]{ticketTypeId}, getMapperFor(DeliverableTypeDTO.class));
	}

	  
	public List<PendingAppointmentsDTO> getPendingAppointments(){
	    StringBuilder sqlBuilder = new StringBuilder("CALL getBloomPendingAppointments();");
		return (List<PendingAppointmentsDTO>) getJdbcTemplate().query(sqlBuilder.toString()
					                             , getMapperFor(DeliverableTypeDTO.class));
	}
	  
	public List<PendingSurveysDTO> getPendingSurveys(){
		StringBuilder sqlBuilder = new StringBuilder("CALL GetBloomPendingSurveys();");
		return (List<PendingSurveysDTO>) getJdbcTemplate().query(sqlBuilder.toString()
						                    , getMapperFor(DeliverableTypeDTO.class));
	}
	 
	  
	public void addDeliverableTrace(Integer ticketId, Integer deliverableTypeId, String docId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL AddBloomDelivarable(?,?,?);");
		getJdbcTemplate().update(sqlBuilder.toString(),
				new Object[] { ticketId, deliverableTypeId, docId });
	}


    public List<DeliverableFileDTO> getTicketDeliverable(Integer ticketId){
		StringBuilder sqlBuilder = new StringBuilder("CALL GetBloomTicketDeliverable(?);");
		return (List<DeliverableFileDTO>) getJdbcTemplate().query(sqlBuilder.toString()
					 , new Object[]{ticketId}, getMapperFor(DeliverableFileDTO.class));
	}

	public void closeTicket(Integer ticketId, Integer userId, Integer statusId) {
		StringBuilder sqlBuilder = new StringBuilder(
				"CALL CloseBloomTicket(?,?,?);");
		getJdbcTemplate().update(sqlBuilder.toString(),
				new Object[] { ticketId, userId, statusId });
	}

	private static final class InternalTicketMapper implements
			RowMapper<InternalTicketBean> {

		@Override
		public InternalTicketBean mapRow(ResultSet rs, int rowNum)
				throws SQLException {
			// log.debug(rowNum + ": Ticket=" + rs.getString("ticketNumber"));
			InternalTicketBean ticket = new InternalTicketBean();

			ticket.setId(rs.getLong("id"));
			ticket.setTicketNumber(rs.getString("ticketNumber"));
			ticket.setCreated(rs.getDate("created"));
			ticket.setPetitionerArea(rs.getString("areaName"));
			ticket.setPetitionerAreaId(rs.getInt("applicantAreaId"));
			ticket.setServiceTypeDescr(rs.getString("serviceName"));
			ticket.setServiceTypeId(rs.getInt("serviceTypeId"));
			ticket.setServiceArea(rs.getString("serviceArea"));

			// responseTime
			ticket.setDueDate(rs.getDate("dueDate"));
			ticket.setDesiredDate(rs.getDate("desiredDate"));
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
			listaRegistros = new ArrayList<InternalTicketBean>();
			return listaRegistros;
		} catch (DataAccessException e) {
			System.out.println("Error => " + e);
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
			listaRegistros = new ArrayList<InternalTicketBean>();
			return listaRegistros;

		} catch (DataAccessException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}

	}

	/**
	 * Vista del reporte de historico del ticket para mesa de ayuda.
	 */
	@Override
	public List<InternalTicketBean> getHistoricalTickets(
			String createDateStart, String createDateEnd,
			Integer idStatusTicket, Integer showHidden) throws DAOException {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		List<InternalTicketBean> listaRegistros = new ArrayList<InternalTicketBean>();

		try {

			listaRegistros.addAll(getJdbcTemplate().query(
					String.format(QUERY_HISTORICAL_TICKETS, idStatusTicket,
							createDateStart, createDateEnd, showHidden),
					new InternalTicketMapper()));
			// listaRegistros.addAll(getJdbcTemplate().query(sq.toString(),new
			// InternalTicketMapper()));
			return listaRegistros;

		} catch (EmptyResultDataAccessException e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			listaRegistros = new ArrayList<InternalTicketBean>();
			return listaRegistros;
		} catch (DataAccessException e) {
			Logger.Log(LogLevel.ERROR, e.getStackTrace()[0].toString(), e);
			throw new DAOException(ERROR_CONSULTA, e);
		}

	}

	@Override
	public Long registrarNuevoTicket(InternalTicketBean ticket)
			throws DAOException {

		StringBuilder sqlBuilder = new StringBuilder();

		sqlBuilder.append("CALL AddInternalTicket(?,?,?,?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?,?,?,?,"
				+ "?,?)");

		int idTicket = 0;

		try {

			Object[] args = new Object[] { ticket.getApplicantUserId(),
					ticket.getOfficeId(), ticket.getServiceTypeId(),
					ticket.getStatusId(), ticket.getApplicantAreaId(),
					ticket.getDueDate(), ticket.getProject(),
					ticket.getTicketNumber(), ticket.getDescription(),
					ticket.getCreated(), ticket.getCreatedUserName(),
					ticket.getCreatedUserEmail(), ticket.getReponseInTime(),
					
					
					ticket.getPurposeVisitVL(),
					ticket.getPurposeVisitVISAS(),
					ticket.getDraftCopyDiagramVED(),
					ticket.getFormProjectVED(),
					ticket.getObservationsVEPI(),
					ticket.getDraftCopyPlanVEPI(),
					ticket.getFormProjectVEPI(),
					ticket.getObservationsVRCC(),
					ticket.getCheckListVRCC(),
					ticket.getFormProjectVRCC(),
					ticket.getQuestionVPT(),
					ticket.getObservationsVSA(),
					ticket.getFormProjectVSA(),
					ticket.getProductInformationVSP(),
					ticket.getObservationsISED(),
					ticket.getDraftCopyPlanISED(),
					ticket.getObservationsISRC(),
					ticket.getAttachmentsISRC(),
					ticket.getApparatusTraceISSM(),
					ticket.getObservationsISSM(),
					ticket.getQuestionISPT(),
					ticket.getTicketISRPR(),
					ticket.getModelPartISRPR(),
					ticket.getObservationsISRPR(),
					ticket.getProductInformationISSPC(),
					ticket.getPositionPGCAS(),
					ticket.getCollaboratorPGCAS(),
					ticket.getJustificationPGCAS(),
					ticket.getSalaryPGCAS(),
					ticket.getPositionPGCCP(),
					ticket.getCommentsPGCCP(),
					ticket.getDevelopmentPlanPGCCP(),
					ticket.getTargetPGCCP(),
					ticket.getSalaryPGCCP(),
					ticket.getPositionPGCNC(),
					ticket.getDevelopmentPlanPGCNC(),
					ticket.getTargetPGCNC(),
					ticket.getSalaryPGCNC(),
					ticket.getJustificationPGCNC(),
					ticket.getPositionPGCF(),
					ticket.getCollaboratorPGCF(),
					ticket.getJustificationPGCF(),
					ticket.getPositionPGCAA(),
					ticket.getCollaboratorPGCAA(),
					ticket.getJustificationPGCAA(),
					ticket.getRequisitionFormatGRC(),
					ticket.getLinkDocumentGM(),
					ticket.getSuggestionGSM(),
					ticket.getDocumentCodeGSM(),
					ticket.getJustificationGSM(),
					ticket.getProblemDescriptionGPTR(),
					ticket.getDesiredDate()
};

			idTicket = getJdbcTemplate().queryForInt(sqlBuilder.toString(),
					args);

		} catch (Exception e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			throw new DAOException("Error en DAO:"+e.getMessage());
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
			throw new DAOException("Error en DAO:"+e.getMessage());
		}

		return (long) idTicket;
	}

	@Override
	public Long registrarMiembroTicket(TicketTeamBean teamMember)
			throws DAOException {

		StringBuilder sqlBuilder = new StringBuilder();

		sqlBuilder.append("CALL AddMemberTicketTeam(?,?,?,?)");

		int idTeamMemberTicket = 0;

		try {

			Object[] args = new Object[] { teamMember.getIdTicket(), teamMember.getWorkerRoleId(), teamMember.getEmail(), teamMember.getUserGroup() };

			idTeamMemberTicket = getJdbcTemplate().queryForInt(sqlBuilder.toString(), args);

		} catch (Exception e) {
			Logger.Log(LogLevel.WARNING, EMPTY_CONSULTA, e);
			throw new DAOException("Error en DAO:"+e.getMessage());
		}

		return (long) idTeamMemberTicket;
	}
	
	@Override
	public Integer userCanAssign(Integer ticketId, String currentUser){
		String sql = "CALL UserCanAssignBloomTicket(?,?)";
		
		Integer val = getJdbcTemplate().queryForObject(sql, new Object[]{ticketId, currentUser}, Integer.class);
		
		return val;
	}
}
