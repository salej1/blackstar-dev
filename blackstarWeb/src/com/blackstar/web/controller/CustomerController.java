package com.blackstar.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.blackstar.common.Globals;
import com.blackstar.model.Customer;
import com.blackstar.model.UserSession;
import com.blackstar.model.dto.CustomerDTO;
import com.blackstar.services.interfaces.CustomerService;
import com.blackstar.web.AbstractController;

@Controller
@RequestMapping("/customer")
@SessionAttributes({ Globals.SESSION_KEY_PARAM })
public class CustomerController extends AbstractController
{
	private CustomerService customerService;

	public void setCustomerService(CustomerService customerService)
	{
		this.customerService = customerService;
	}

	@RequestMapping(value = "/add.do", method = RequestMethod.GET)
	public String add(@ModelAttribute("customerDTO") CustomerDTO customerDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("classificationList", customerService.getClassficationList());
		model.addAttribute("currencyList", customerService.getCurrencyList());
		model.addAttribute("governmentList", customerService.getGovernmentList());
		model.addAttribute("ivaList", customerService.getIVAList());
		model.addAttribute("originList", customerService.getOriginList());
		model.addAttribute("paymentTermsList", customerService.getPaymentTermsList());
		model.addAttribute("sellerList", customerService.getSellerList());
		return "customer";
	}

	@RequestMapping(value = "/show.do", method = RequestMethod.GET)
	public String show(ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		model.addAttribute("leafletList", customerService.getLeafletList());
		model.addAttribute("customerList", customerService.getCustomerList());
		return "customers";
	}

	@RequestMapping(value = "/save.do", method = RequestMethod.POST)
	public String save(@ModelAttribute("customerDTO") CustomerDTO customerDTO, @ModelAttribute(Globals.SESSION_KEY_PARAM) UserSession userSession, ModelMap model, HttpServletRequest req, HttpServletResponse resp)
	{
		Customer customer;
		int idCustomer;

		try
		{
			idCustomer = 0;
			if(customerDTO.getCustomerId() == null)
			{
				customer = new Customer();
				customer.setAdvance(customerDTO.getAdvance());
				customer.setCityId(customerDTO.getCityId());
				customer.setClassificationId(customerDTO.getClassificationId());
				customer.setColony(customerDTO.getColony());
				customer.setCompanyName(customerDTO.getCompanyName());
				customer.setContactPerson(customerDTO.getContactPerson());
				customer.setCountry(customerDTO.getCountry());
				customer.setCurp(customerDTO.getCurp());
				customer.setCurrencyId(customerDTO.getCurrencyId());
				customer.setEmail1(customerDTO.getEmail1());
				customer.setEmail2(customerDTO.getEmail2());
				customer.setExtension1(customerDTO.getExtension1());
				customer.setExtension2(customerDTO.getExtension2());
				customer.setExternalNumber(customerDTO.getExternalNumber());
				customer.setInternalNumber(customerDTO.getInternalNumber());
				customer.setIvaId(customerDTO.getIvaId());
				customer.setOriginId(customerDTO.getOriginId());
				customer.setPaymentTermsId(customerDTO.getPaymentTermsId());
				customer.setPhone1(customerDTO.getPhone1());
				customer.setPhone2(customerDTO.getPhone2());
				customer.setPhoneCode1(customerDTO.getPhoneCode1());
				customer.setPhoneCode2(customerDTO.getPhoneCode2());
				customer.setPostcode(customerDTO.getPostcode());
				customer.setRetention(customerDTO.getRetention());
				customer.setRfc(customerDTO.getRfc());
				customer.setSeller(customerDTO.getSeller());
				customer.setSettlementTimeLimit(customerDTO.getSettlementTimeLimit());
				customer.setStreet(customerDTO.getStreet());
				customer.setTimeLimit(customerDTO.getTimeLimit());
				customer.setTown(customerDTO.getTown());
				customer.setTradeName(customerDTO.getTradeName());
				idCustomer = customerService.saveCustomer(customer);
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
