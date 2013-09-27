package com.blackstar.web;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.jmx.HibernateService;
import org.hibernate.jmx.HibernateServiceMBean;

import com.blackstar.model.*;
import com.google.appengine.repackaged.org.joda.time.DateTime;

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
		DateTime today = DateTime.now();
		DateTime today1 = today.plusDays(1);
		DateTime today2 = today1.plusDays(1);
		DateTime today3 = today2.plusDays(1);
		DateTime today4 = today3.plusDays(1);
		DateTime today5 = today4.plusDays(1);
		DateTime today6 = today5.plusDays(1);
		
		request.setAttribute("today", today.toString());
		request.setAttribute("today1", today1.toString());
		request.setAttribute("today2", today2.toString());
		request.setAttribute("today3", today3.toString());
		request.setAttribute("today4", today4.toString());
		request.setAttribute("today5", today5.toString());
		request.setAttribute("today6", today6.toString());
		
		List<ScheduledService> servicesToday; //TODO invocar lista de servicios programados
		
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
