package com.blackstar.dataAccess;

import java.sql.DriverManager;
import java.util.Date;
import java.util.List;

import com.blackstar.model.ScheduledService;
import com.google.cloud.sql.jdbc.*;

public class ScheduledServiceDataProvider {
	
	public void getScheduledServices(Date date){
		String sql = "CALL serviceOrderData_getSchedule";
		//ResultSet dataAccess.executeQuery(sql);
		
        // TODO: convertir a objeto DTO
	   
	}
}
