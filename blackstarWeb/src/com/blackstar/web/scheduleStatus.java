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
import org.json.JSONArray;

import com.blackstar.common.Globals;
import com.blackstar.common.ResultSetConverter;
import com.blackstar.db.BlackstarDataAccess;
import com.blackstar.logging.LogLevel;
import com.blackstar.logging.Logger;
import com.blackstar.model.*;
import com.blackstar.services.IUserService;
import com.blackstar.services.UserServiceFactory;

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
		// Conexion a la BD		
		BlackstarDataAccess da = new BlackstarDataAccess();
		Calendar cal = Calendar.getInstance();
		
		try{
			// Servicios programados
			printDates(request);
			for(Integer i = 0; i < 7; i++){
				request.setAttribute("servicesToday" + i.toString(), getScheduledServices(da, cal.getTime()));
				cal.add(Calendar.DATE, 1);
			}
			request.setAttribute("futureServices", getFutureServices(da));
			// Lista de proyectos
			request.setAttribute("projects", getProjects(da));
			// Lista de empleados del directorio
			request.setAttribute("employees", getEmployeeList(da));
			// Lista de equipos
			request.setAttribute("equipments", getEquipmentList(da));
			
			// Redireccionando el request
			request.getRequestDispatcher("/scheduleStatus.jsp").forward(request, response);
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		finally{
			if(da!= null){
				da.closeConnection();
			}
		}		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		BlackstarDataAccess da = null;
		String[] policies;
		String responsible;
		String[] engineers;
		String effectiveDate;
		String rawDays;
		String userId = "";
		Integer scheduledServiceId = 0;
		
		try{
			User thisUser = (User)request.getSession().getAttribute("user");
			if(thisUser != null){
				userId = thisUser.getUserEmail();
			}
			
			policies = request.getParameterValues("policy");
			responsible = request.getParameter("isDefaultEmployee");
			engineers = request.getParameterValues("employee");
			effectiveDate = request.getParameter("serviceDateStart");
			rawDays = request.getParameter("serviceDays");
			Integer days = 1;
			
			try{
				days = Integer.parseInt(rawDays);
			}catch(Exception o){}
			
			@SuppressWarnings("deprecation")
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			Calendar serviceDate = Calendar.getInstance();
			serviceDate.setTime(new Date(Date.parse(effectiveDate)));

			da = new BlackstarDataAccess();
			// Creando / Actualizando scheduledService
			ResultSet rs = da.executeQuery(String.format("CALL UpsertScheduledService(%s, '%s')", scheduledServiceId, userId));
	
			if(scheduledServiceId == 0){
				while(rs.next()){
					scheduledServiceId = rs.getInt("scheduledServiceId");
					break;
				}
			}
			
			// Asociando empleados
			for(int i = 0; i < engineers.length; i++){
				Integer isDefault;
				isDefault = engineers[i].equals(responsible)?1:0;
				
				da.executeUpdate(String.format("CALL AddScheduledServiceEmployee(%s, '%s', %s, '%s')", scheduledServiceId, engineers[i], isDefault, userId));
			}
			
			// Asociando equipos
			for(int i = 0; i < policies.length; i++){

				da.executeUpdate(String.format("CALL AddScheduledServicePolicy(%s, %s, '%s')", scheduledServiceId, policies[i], userId));
			}
			
			// Asociando fechas
			for(int i = 0; i < days; i++){
				da.executeUpdate(String.format("CALL AddScheduledServiceDate(%s, '%s', '%s')", scheduledServiceId, formatter.format(serviceDate.getTime()), userId));
				serviceDate.add(Calendar.DATE, 1);
			}
			
			response.sendRedirect("/scheduleStatus");
		}
		catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		finally{
			if(da!= null){
				da.closeConnection();
			}
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
	
	private List<ScheduledService> getScheduledServices(BlackstarDataAccess da, Date date){
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");		
		List<ScheduledService> servicesToDate = new ArrayList<ScheduledService>(); 
		
		try{
			ResultSet rs = da.executeQuery(String.format("CALL GetServicesSchedule('%s')", formatter.format(date)));
			
			while(rs.next()){
				ScheduledService sch = new ScheduledService();
				sch.setScheduledServiceId(rs.getInt("scheduledServiceId"));
				sch.setScheduledDate(rs.getDate("scheduledDate"));
				sch.setEquipmentType(rs.getString("equipmentType"));
				sch.setCustomer(rs.getString("customer"));
				sch.setSerialNumber(rs.getString("serialNumber"));
				sch.setAsignee(rs.getString("employee"));
				
				servicesToDate.add(sch);
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);	
		}
		// Leyendo los servicios programados de la BD
		
		return servicesToDate;
	}
	
	private List<String> getProjects(BlackstarDataAccess da){
		List<String> projects = new ArrayList<String>();
		try{

			ResultSet rs = da.executeQuery("CALL GetProjectList()");
			
			while(rs.next()){
				projects.add(rs.getString("project"));
			}
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		
		return projects;
	}
	
	private JSONArray getEquipmentList(BlackstarDataAccess da){
		JSONArray list = new JSONArray();
		
		try{

			ResultSet rs = da.executeQuery("CALL GetEquipmentList()");
			list = ResultSetConverter.convertResultSetToJSONArray(rs);
			
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		
		return list;
	}
	
	private JSONArray getEmployeeList(BlackstarDataAccess da){
		JSONArray list = new JSONArray();
		
		try{

			ResultSet employees = da.executeQuery(String.format("CALL GetDomainEmployeesByGroup('%s');", Globals.GROUP_SERVICE));
			list = ResultSetConverter.convertResultSetToJSONArray(employees);
			
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		
		return list;
	}
	
	private JSONArray getFutureServices(BlackstarDataAccess da){
		JSONArray list = new JSONArray();
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, 7);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try{

			ResultSet services = da.executeQuery(String.format("CALL GetFutureServicesSchedule('%s');", sdf.format(cal.getTime())));
			list = ResultSetConverter.convertResultSetToJSONArray(services);
			
		}catch(Exception ex){
			Logger.Log(LogLevel.ERROR, Thread.currentThread().getStackTrace()[1].toString(), ex);
		}
		
		return list;
	}
}
