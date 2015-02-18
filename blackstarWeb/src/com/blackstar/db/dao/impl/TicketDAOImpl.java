package com.blackstar.db.dao.impl;

import java.util.List;

import org.json.JSONObject;

import com.blackstar.db.dao.AbstractDAO;
import com.blackstar.db.dao.interfaces.TicketDAO;
import com.blackstar.db.dao.mapper.JSONRowMapper;
import com.blackstar.model.Ticket;
import com.blackstar.model.dto.TicketDTO;

public class TicketDAOImpl extends AbstractDAO implements TicketDAO {

	@Override
	public List<JSONObject> getEquipmentList(String customerEmail) {
		String sql = "Call GetEquipmentListByCustomer(?)";
		
		return getJdbcTemplate().query(sql, new Object[]{customerEmail}, new JSONRowMapper());
	}

	@Override
	public List<JSONObject> getEquipmentList() {
		String sql = "Call GetEquipmentListAll()";
		
		return getJdbcTemplate().query(sql, new JSONRowMapper());
	}


	@Override
	public List<JSONObject> getPolicyData(Integer policyId) {
		String sql = "Call GetPolicyById(?)";
		
		return getJdbcTemplate().query(sql,  new Object[]{policyId}, new JSONRowMapper());
	}
	
	
	@Override
	public synchronized Integer saveTicket(TicketDTO ticket) throws Exception {
		String sql = "Call InsertTicket(?,?,?,?,?,?,?,?,?)";
		Integer ticketId = 0;
		
		try{
			ticketId = getJdbcTemplate().queryForObject(sql, new Object[]{
					ticket.getPolicyId(),
					ticket.getUser(),
					ticket.getObservations(),
					ticket.getCreated(),
					ticket.getCreatedBy(),
					ticket.getCreatedByUsr(),
					ticket.getContact(),
					ticket.getContactEmail(),
					ticket.getContactPhone()
			}, Integer.class);
		}
		catch(Exception e){
			throw new Exception("Cannot create ticket for policy " + ticket.getPolicyId().toString());
		}
		return ticketId;
	}


	@Override
	public TicketDTO getTicketDTOById(Integer ticketId) {
		String sql = "CALL GetTicketById(?)";
		
		List<TicketDTO> result = (List<TicketDTO>) getJdbcTemplate().query(sql, new Object[]{ticketId}, getMapperFor(TicketDTO.class)); 
		
		if(result.size() > 0){
			return result.get(0);
		}
		else{
			return null;
		}
	}

	
// Soporte de obsolescencia
	@Override
	public Ticket findTicket() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Ticket> selectAllTicket() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Ticket getTicketById(int id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Ticket getTicketByNumber(String number) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertTicket() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean updateTicket() {
		// TODO Auto-generated method stub
		return false;
	}


}
