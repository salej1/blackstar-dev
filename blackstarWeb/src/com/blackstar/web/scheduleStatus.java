package com.blackstar.web;

import java.io.IOException;
import java.util.Date;
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
		//SimpleDateFormat dateFormatter = new SimpleDateFormat("EEEE, MMMM d, 'yyyy", new Locale("es", "ES"));
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
		
		List<ScheduledService> servicesToday; //TODO invocar lista de servicios programados
		servicesToday = new ArrayList<ScheduledService>(); // Esto es un stub, habra que cambiarlo por la llamada a datos
		
		request.setAttribute("servicesToday", servicesToday);
		
		request.getRequestDispatcher("/scheduleStatus.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
