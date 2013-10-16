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
import java.util.List;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.db.DAOFactory;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.Followup;
import com.blackstar.model.Policy;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.Ticket;
import com.blackstar.model.User;
import com.blackstar.model.dto.EmployeeDTO;
import com.blackstar.model.dto.OrderserviceDTO;

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
		
		/// obtener del request el id de la orden de servicio 
		String idOS = request.getParameter("serviceOrderId").toString();
		Serviceorder serviceOrder = this.daoFactory.getServiceOrderDAO().getServiceOrderById(Integer.parseInt(idOS));
		
		if(serviceOrder.getServiceOrderId() != null)
		{
			/// Obtener la poliza asociada a la orden de servicio
			Policy policy  = this.daoFactory.getPolicyDAO().getPolicyById(serviceOrder.getPolicyId());
			
			/// Obtener el ticket asociado a la orden de servicio
			Ticket ticket =null;
			
			if( serviceOrder.getTicketId()!= null)
				 ticket  = this.daoFactory.getTicketDAO().getTicketById(serviceOrder.getTicketId());
			
			OrderserviceDTO serviceOrderDTO;
			
			if(ticket != null)
			{
			/// Crea el objeto DTO (OrderserviceDTO)
				serviceOrderDTO = new OrderserviceDTO(serviceOrder.getCoordinator(), serviceOrder.getServiceOrderId(), serviceOrder.getServiceOrderNumber(), ticket.getTicketNumber(),
																	ticket.getTicketId(), policy.getCustomer(), policy.getEquipmentAddress(), policy.getContactName(), serviceOrder.getServiceDate(), 
																	policy.getContactPhone(), policy.getEquipmentTypeId(), policy.getBrand(), policy.getModel(), policy.getSerialNumber(), 
																	ticket.getObservations(), serviceOrder.getServiceTypeId(), policy.getProject(), "", "", 
																	"", "", serviceOrder.getServiceComments(), serviceOrder.getSignCreated(), serviceOrder.getsignReceivedBy(), 
																	serviceOrder.getReceivedBy(), serviceOrder.getResponsible(), serviceOrder.getClosed(), serviceOrder.getReceivedByPosition());
			}
			else
			{
				serviceOrderDTO = new OrderserviceDTO(serviceOrder.getCoordinator(), serviceOrder.getServiceOrderId(), serviceOrder.getServiceOrderNumber(), "NA",
						0, policy.getCustomer(), policy.getEquipmentAddress(), policy.getContactName(), serviceOrder.getServiceDate(), 
						policy.getContactPhone(), policy.getEquipmentTypeId(), policy.getBrand(), policy.getModel(), policy.getSerialNumber(), 
						"", serviceOrder.getServiceTypeId(), policy.getProject(), "", "", 
						"", "", serviceOrder.getServiceComments(), serviceOrder.getSignCreated(), serviceOrder.getsignReceivedBy(), 
						serviceOrder.getReceivedBy(), serviceOrder.getResponsible(), serviceOrder.getClosed(), serviceOrder.getReceivedByPosition());
				
			}
				
			request.setAttribute("serviceOrderDetail", serviceOrderDTO);
			
			List<EmployeeDTO> UsuariosAsignados = getEmployeeList(); // TODO: Obtener los usuarios posibles a asignar una orden de servicio
			request.setAttribute("UsuariosAsignados", UsuariosAsignados);
			
			// Obtener los followups asociados a la orden de servicio
			List<Followup> followUps =  this.daoFactory.getFollowUpDAO().getFollowUpByServiceOrderId(serviceOrder.getServiceOrderId());
			request.setAttribute("ComentariosOS", followUps);
	
			request.getRequestDispatcher("/osDetail.jsp").forward(request, response);
		}
		else
		{	
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), "No hay Orden de Servicio con el Id " + idOS, "" );
			request.getRequestDispatcher("/osDetail.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		
		if(request.getParameter("datosComentario").toString().equals("")== false){
			  
			String[] datosComentario=request.getParameter("datosComentario").toString().split("&&");
			  String comentario = datosComentario[0];
			  String asignadoA = datosComentario[1];
			  String folioOS = datosComentario[2];
			  
			  //TODO: Guardar followup
			  Followup followup =  new Followup();
			  followup.setModified(new Date());
			  followup.setCreated(new Date());
		}
	}
	
	private List<EmployeeDTO> getEmployeeList(){
		List<EmployeeDTO> list = new ArrayList<EmployeeDTO>();
		try{
			BlackstarDataAccess da = new BlackstarDataAccess();
			ResultSet rs = da.executeQuery("CALL GetDomainEmployees()");
			
			while(rs.next()){
				EmployeeDTO emp = new EmployeeDTO();
				emp.setEmail(rs.getString("email"));
				emp.setName(rs.getString("name"));
				list.add(emp);
			}
			
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		return list;
	}
	
	
}
