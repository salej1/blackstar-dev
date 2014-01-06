package com.blackstar.web;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Equipmenttype;
import com.blackstar.model.Followup;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Servicetype;
import com.blackstar.model.Ticket;
import com.blackstar.model.User;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.model.dto.FollowUpDTO;
import com.blackstar.model.dto.OrderserviceDTO;
import com.blackstar.services.IUserService;
import com.blackstar.services.UserServiceFactory;

/**
 * Servlet implementation class osDetail
 */
public class osDetail extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public osDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BlackstarDataAccess da = null;
		
		try {
			/// obtener del request el id de la orden de servicio 
			String idOS = request.getParameter("serviceOrderId");
			String numOs = request.getParameter("osNum");
			Serviceorder serviceOrder = null;
			da = new BlackstarDataAccess();
			
			if(idOS != null){
				serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(Integer.parseInt(idOS));
			}
			else if(numOs != null){
				serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderByNum(numOs);
			}
			if(serviceOrder.getServiceOrderId() != null)
			{
				/// Obtener la poliza asociada a la orden de servicio
				Policy policy  = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
				if(policy == null){
					Logger.Log(LogLevel.WARNING, "osDetail.doGet", "Referencia a poliza " + serviceOrder.getPolicyId() + " es nula" , "" );
				}
				/// Obtener el ticket asociado a la orden de servicio
				Ticket ticket =null;
				
				if( serviceOrder.getTicketId()!= null)
					 ticket  = this.daoFactory.getTicketDAO().getTicketById(serviceOrder.getTicketId());
				
				// Obtener el tipo de servicio asociado
				Servicetype st = null;
				if(serviceOrder.getServiceTypeId() != null){
					st = this.daoFactory.getServiceTypeDAO().getServiceTypeById(serviceOrder.getServiceTypeId());
				}
				
				// Obtener el tipo de equipo asociado
				Equipmenttype et = null;
				if(policy.getEquipmentTypeId() != null){
					et = this.daoFactory.getEquipmentTypeDAO().getEquipmentTypeById(policy.getEquipmentTypeId());
				}
				if(et == null){
					Logger.Log(LogLevel.WARNING, "osDetail.doGet", "Referencia a equipmentType " + policy.getEquipmentTypeId() + " es nula" , "" );
				}
				OrderserviceDTO serviceOrderDTO;
				
				if(ticket != null)
				{
				/// Crea el objeto DTO (OrderserviceDTO)
					serviceOrderDTO = new OrderserviceDTO(serviceOrder.getCoordinator(), serviceOrder.getServiceOrderId(), serviceOrder.getServiceOrderNumber(), ticket.getTicketNumber(),
																		ticket.getTicketId(), policy.getCustomer(), policy.getEquipmentAddress(), policy.getContactName(), serviceOrder.getServiceDate(), 
																		policy.getContactPhone(), et.getEquipmentType(), policy.getBrand(), policy.getModel(), policy.getSerialNumber(), 
																		ticket.getObservations(), st.getServiceType(), policy.getProject(), "", "", 
																		"", "", serviceOrder.getServiceComments(), serviceOrder.getSignCreated(), serviceOrder.getsignReceivedBy(), 
																		serviceOrder.getReceivedBy(), serviceOrder.getResponsible(), serviceOrder.getClosed(), serviceOrder.getReceivedByPosition(),
																		serviceOrder.getIsWrong());
				}
				else
				{
					serviceOrderDTO = new OrderserviceDTO(serviceOrder.getCoordinator(), serviceOrder.getServiceOrderId(), serviceOrder.getServiceOrderNumber(), "NA",
							0, policy.getCustomer(), policy.getEquipmentAddress(), policy.getContactName(), serviceOrder.getServiceDate(), 
							policy.getContactPhone(), et.getEquipmentType(), policy.getBrand(), policy.getModel(), policy.getSerialNumber(), 
							"", st.getServiceType(), policy.getProject(), "", "", 
							"", "", serviceOrder.getServiceComments(), serviceOrder.getSignCreated(), serviceOrder.getsignReceivedBy(), 
							serviceOrder.getReceivedBy(), serviceOrder.getResponsible(), serviceOrder.getClosed(), serviceOrder.getReceivedByPosition(),
							serviceOrder.getIsWrong());
					
				}
					
				request.setAttribute("serviceOrderDetail", serviceOrderDTO);
				
				IUserService dir = UserServiceFactory.getUserService();
				request.setAttribute("employees", dir.getEmployeeList());
				
				// Obtener los followups asociados a la orden de servicio
				List<FollowUpDTO> followUps = getFollowUpList(serviceOrder.getServiceOrderId(), da);
				request.setAttribute("followUps", followUps);

				request.getRequestDispatcher("/osDetail.jsp").forward(request, response);
			}
			else
			{	
				Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), "No hay Orden de Servicio con el Id " + idOS, "" );
				request.getRequestDispatcher("/osDetail.jsp").forward(request, response);
			}
		} catch (NumberFormatException e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		finally{
			if(da != null){
				da.closeConnection();
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = (String)request.getParameter("action");
		String pIsWrong = (String)request.getParameter("isWrong");
		String osId = (String)request.getParameter("serviceOrderId");
		BlackstarDataAccess da = null;;
		
		try {
			da = new BlackstarDataAccess();
			int serviceOrderId = Integer.parseInt(osId);
			
			if(action.equals("save")){

				if(serviceOrderId > 0){
					if(pIsWrong != null && !pIsWrong.equals("")){
						Serviceorder so = this.daoFactory.getServiceOrderDAO().getServiceOrderById(serviceOrderId);
						
						// actualizando los valores
						Integer isWrong = Integer.parseInt(pIsWrong);
						so.setIsWrong(isWrong);
						
						// guardando el nuevo OS
						this.daoFactory.getServiceOrderDAO().updateServiceOrder(so);
						
						response.sendRedirect(String.format("/osDetail?serviceOrderId=%s", so.getServiceOrderId()));
					}
				}
			}
			else if(action.equals("close")){

				String userId = "";
				
				User thisUsr = (User)request.getSession().getAttribute("user");
				if(thisUsr != null){
					userId = thisUsr.getUserEmail();
				}
				
				da.executeUpdate(String.format("CALL CloseOS(%s, '%s')", serviceOrderId, userId));
				
				response.sendRedirect(String.format("/osDetail?serviceOrderId=%s", serviceOrderId));
			}
		} catch (Exception e) {
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), e);
		}
		finally{
			if(da != null){
				da.closeConnection();
			}
		}
	}
	
	
	private List<FollowUpDTO> getFollowUpList(int osId, BlackstarDataAccess da){
		List<FollowUpDTO> list = new ArrayList<FollowUpDTO>();
		try{
			String sql = "CALL GetFollowUpByServiceOrder(%s)";
			sql = String.format(sql, osId);
			
			ResultSet rs = da.executeQuery(sql);
			
			while(rs.next()){
				FollowUpDTO fu = new FollowUpDTO(
						String.format("%s", rs.getTimestamp("created")),
						rs.getString("asignee"), 
						rs.getString("createdBy"), 
						rs.getString("followUp")
				);
				list.add(fu);
			}
			
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		return list;
	}
}
