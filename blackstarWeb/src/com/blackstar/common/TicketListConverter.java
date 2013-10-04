package com.blackstar.common;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.blackstar.model.Ticket;

public class TicketListConverter {
	
	  public static JSONArray getJsonFromTicketsList(List<Ticket> listTicket) throws JSONException
	  {
	    //JSONObject responseDetailsJson = new JSONObject();
	    JSONArray jsonArray = new JSONArray();
	    JSONObject obj = new JSONObject();
	    
	    for (int i = 0; i < listTicket.size(); i++)
	    {
	      obj = new JSONObject();
	      obj.put("ticketId", listTicket.get(i).getTicketId());
	      obj.put("created", listTicket.get(i).getCreated());
	      obj.put("asignee", listTicket.get(i).getAsignee());
	      obj.put("NS", listTicket.get(i).getRealResponseTime());
	      obj.put("Policy", listTicket.get(i).getPolicyId());
	      obj.put("Equipo", "PE");
	      obj.put("TR", listTicket.get(i).getRealResponseTime());
	      obj.put("Proyecto", "Project");
	      obj.put("Estatus", listTicket.get(i).getTicketStatusId());
	      obj.put("OS", "Crear OS");

	      jsonArray.put(obj);
	    }
	 
	    return jsonArray;
	  }

}
