package com.blackstar.web;

import java.io.IOException;
import java.util.Date;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.jmx.HibernateService;
import org.hibernate.jmx.HibernateServiceMBean;

import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.*;

/**
 * Servlet implementation class scheduleStatus
 */
public class scheduleStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public scheduleStatus() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		// Conexion a la BD		
		BlackstarDataAccess da = new BlackstarDataAccess();

		// Seccion de programa de servicios 
		printDates(request);
		List<ScheduledService> servicesToday = getScheduledServices(da);
		
		// Seccion de polizas por cliente
		List<String> customers = getCustomers(da);
		
		da.closeConnection();

		request.setAttribute("servicesToday", servicesToday);
		request.setAttribute("customers", customers);
		request.getRequestDispatcher("/scheduleStatus.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String policyId;
		String responsible;
		String additionalEmployees;
		String effectiveDate;
		
		try{
		
			policyId = request.getParameter("policyId");
			responsible = request.getParameter("responsible");
			additionalEmployees = request.getParameter("additionalEmployees");
			effectiveDate = request.getParameter("effectiveDate");
			
			BlackstarDataAccess da = new BlackstarDataAccess();
			
			da.executeQuery("CALL ScheduleService(" + policyId + ", '" + responsible + "', '" + additionalEmployees + "', '" + effectiveDate + "')");
			da.closeConnection();
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, ex);
		}
		
	}
	private void printDates(HttpServletRequest request){
		DateFormat dateFormatter = DateFormat.getDateInstance(DateFormat.FULL);
		Calendar cal = Calendar.getInstance();
		
		Date today = new Date();
		cal.setTime(today);
		cal.add(Calendar.DATE, 1);
		Date today1 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today2 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today3 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today4 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today5 = cal.getTime();
		cal.add(Calendar.DATE, 1);
		Date today6 = cal.getTime();
		
		request.setAttribute("today",  dateFormatter.format(today));
		request.setAttribute("today1", dateFormatter.format(today1));
		request.setAttribute("today2", dateFormatter.format(today2));
		request.setAttribute("today3", dateFormatter.format(today3));
		request.setAttribute("today4", dateFormatter.format(today4));
		request.setAttribute("today5", dateFormatter.format(today5));
		request.setAttribute("today6", dateFormatter.format(today6));
	}
	
	private List<ScheduledService> getScheduledServices(BlackstarDataAccess da){
				
		List<ScheduledService> servicesToday = new ArrayList<ScheduledService>(); 
		try{
			ResultSet rs = da.executeQuery("CALL GetServicesSchedule()");

			
			while(rs.next()){
				ScheduledService sch = new ScheduledService();
				sch.setScheduledServiceId(rs.getInt("serviceOrderId"));
				sch.setScheduledDate(rs.getDate("effectiveDate"));
				sch.setEquipmentType(rs.getString("equipmentType"));
				sch.setCustomer(rs.getString("customer"));
				sch.setSerialNumber(rs.getString("serialNumber"));
				sch.setAsignee(rs.getString("asignee"));
				sch.setAdditionalEmployees(rs.getString("additionalEmployees"));
				
				servicesToday.add(sch);
			}
		}catch(Exception ex){
		Logger.Log(LogLevel.ERROR, ex);	
		}
		// Leyendo los servicios programados de la BD
		
		return servicesToday;
	}
	
	private List<String> getCustomers(BlackstarDataAccess da){
		List<String> customers = new ArrayList<String>();
		try{

			ResultSet rs = da.executeQuery("CALL GetCustomerList()");
			
			while(rs.next()){
				customers.add(rs.getString("customer"));
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, ex);
		}
			return customers;
	}
}
