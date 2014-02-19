package com.blackstar.web.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.Serviceorder;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.PlainServiceDTO;
import com.blackstar.model.dto.PlainServicePolicyDTO;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/customer")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class CustomerController extends AbstractController
{
	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	public String save(@ModelAttribute("customer") CustomerDTO customerDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		Customer customer;

		customer = new Customer();

		try
		{
			int idServicio = 0;
			// Verificar si existe una orden de servicio
			if(customerDTO.getServiceOrderId() == null)
			{
				// Crear orden de servicio
				Serviceorder servicioOrderSave = new Serviceorder();
				servicioOrderSave.setPolicyId((Short.parseShort(serviceOrder.getPolicyId().toString())));
				servicioOrderSave.setReceivedBy(serviceOrder.getReceivedBy());
				servicioOrderSave.setReceivedByPosition(serviceOrder.getReceivedByPosition());
				servicioOrderSave.setEmployeeListString(serviceOrder.getResponsible());
				servicioOrderSave.setServiceDate(serviceOrder.getServiceDate());
				servicioOrderSave.setServiceOrderNumber(serviceOrder.getServiceOrderNumber());
				servicioOrderSave.setServiceTypeId(serviceOrder.getServiceTypeId().toCharArray()[0]);
				servicioOrderSave.setSignCreated(serviceOrder.getSignCreated());
				servicioOrderSave.setSignReceivedBy(serviceOrder.getSignReceivedBy());
				servicioOrderSave.setReceivedByEmail(serviceOrder.getReceivedByEmail());
				servicioOrderSave.setClosed(new Date());
				servicioOrderSave.setStatusId("N");
				idServicio = service.saveServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserName());
			}
			else
			{
				// Actualizar orden de servicio
				Serviceorder servicioOrderSave = new Serviceorder();
				servicioOrderSave.setServiceOrderId(serviceOrder.getServiceOrderId());
				servicioOrderSave.setAsignee(serviceOrder.getResponsible());
				servicioOrderSave.setClosed(serviceOrder.getClosed());
				servicioOrderSave.setIsWrong(serviceOrder.getIsWrong() ? 1 : 0);
				servicioOrderSave.setStatusId(serviceOrder.getServiceStatusId());
				service.updateServiceOrder(servicioOrderSave, "PlainServiceController", userSession.getUser().getUserName());
			}
		}
		catch(Exception e)
		{
			StringBuilder details = new StringBuilder(e.toString() + "\n");
			for(StackTraceElement element : e.getStackTrace())
			{
				details.append(element.toString() + "\n");
			}
			model.addAttribute("errorDetails", details.toString());
			e.printStackTrace();
			return "error";
		}
		return "customers";
	}
}
