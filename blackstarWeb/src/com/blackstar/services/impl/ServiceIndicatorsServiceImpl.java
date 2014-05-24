package com.blackstar.services.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.blackstar.db.dao.interfaces.ServiceIndicatorsDAO;
import com.blackstar.model.Chart;
import com.blackstar.model.Servicecenter;
import com.blackstar.model.dto.AvailabilityKpiDTO;
import com.blackstar.model.sp.GetConcurrentFailuresKPI;
import com.blackstar.model.sp.GetReportOSTableKPI;
import com.blackstar.model.sp.GetStatisticsKPI;
import com.blackstar.services.AbstractService;
import com.blackstar.services.interfaces.ServiceIndicatorsService;

@SuppressWarnings("serial")
public class ServiceIndicatorsServiceImpl extends AbstractService 
implements ServiceIndicatorsService {

	private ServiceIndicatorsDAO dao = null;
	public static final Map<String , String> MONTHS = new HashMap<String , String>() {{
		put("01", "lbl-ENERO");
		put("02", "lbl-FEBRERO");
		put("03", "lbl-MARZO");
		put("04", "lbl-ABRIL");
		put("05", "lbl-MAYO");
		put("06", "lbl-JUNIO");
		put("07", "lbl-JULIO");
		put("08", "lbl-AGOSTO");
		put("09", "lbl-SEPTIEMBRE");
		put("10", "lbl-OCTUBRE");
		put("11", "lbl-NOVIEMBRE");
		put("12", "lbl-DICIEMBRE");
	}};

	public static final Map<String , String> OFFICES = new HashMap<String , String>() {{
		put("GDL", "lbl-GUADALAJARA");
		put("MXO", "lbl-MEXICO");
		put("QRO", "lbl-QUERETARO");
	}};

	public void setDao(ServiceIndicatorsDAO dao) {
		this.dao = dao;
	}

	public String getTickets() throws Exception{
		List<JSONObject> jsonData = dao.getTickets();
		String month = "";
		String lastMonth = "";
		Map <String, String> map = new HashMap<String , String>() {{
			put("DT_RowId", "1");
			put("ticketNumber", "");
			put("created", "");
			put("customer", "");
			put("equipmentType", "");
			put("ticketStatus", "");
			put("asignee", "");
			put("equipmentLocation", "");
			put("equipmentBrand", "");
			put("arrival", "");
			put("closed", "");
		}};
		for(int i = 0; i < jsonData.size();i++){
			month = jsonData.get(i).get("created").toString().substring(5,7);
			if(! month.equals(lastMonth)){
				lastMonth = month;
				map.put("ticketNumber", MONTHS.get(month));
				jsonData.add(i, new JSONObject(map));
			}
		}
		return jsonData != null ? jsonData.toString() : "";
	}

	public String getPolicies(String project, Date startDate, Date endDate) throws Exception{
		List<JSONObject> jsonData = dao.getPolicies(project, startDate, endDate);
		return jsonData != null ? jsonData.toString() : "";
	}

	public List<GetConcurrentFailuresKPI> getConcurrentFailures(String project, Date startDate, Date endDate) throws Exception{
		List<GetConcurrentFailuresKPI> data = dao.getConcurrentFailures(project, startDate, endDate);
		String month = "";
		String lastMonth = "";
		for(int i = 0; i < data.size();i++){
			month = data.get(i).getCreated().toString().substring(5,7);
			if(! month.equals(lastMonth)){
				lastMonth = month;
				data.add(i, new  GetConcurrentFailuresKPI(MONTHS.get(month)));
			}
		}
		return data;
	}

	public String getMaxPeportsByUser(String project, Date startDate, Date endDate) throws Exception {
		List<JSONObject> jsonData = dao.getMaxPeportsByUser(project, startDate, endDate);
		String month = "";
		String lastMonth = "";
		Map <String, String> map = new HashMap<String , String>() {{
			put("employee", "1");
			put("customer", "");
			put("created", "");
			put("counter", "");
			put("ticketList", "");
		}};
		for(int i = 0; i < jsonData.size();i++){
			month = jsonData.get(i).get("created").toString().substring(5,7);
			if(! month.equals(lastMonth)){
				lastMonth = month;
				map.put("employee", MONTHS.get(month));
				jsonData.add(i, new JSONObject(map));
			}
		}
		return jsonData != null ? jsonData.toString() : "";
	}

	public String getReportOSResumeKPI() throws Exception{
		List<JSONObject> jsonData = dao.getReportOSResume();
		return jsonData != null ? jsonData.toString() : "";
	}

	public List<GetReportOSTableKPI> getReportOSTable(){
		List<GetReportOSTableKPI> data = dao.getReportOSTable();
		String office = "";
		String lastOffice = "";
		for(int i = 0; i < data.size();i++){
			office = data.get(i).getOffice();
			if(! office.equals(lastOffice)){
				lastOffice = office;
				data.add(i, new  GetReportOSTableKPI(OFFICES.get(office)));
			}
		}
		return data;
	}

	public String getOSResume() throws Exception {
		List<JSONObject> jsonData = dao.getOSResume();
		String month = "";
		String lastMonth = "";
		Map <String, String> map = new HashMap<String , String>() {{
			put("serviceUnit", "");
			put("project", "");
			put("customer", "");
			put("equipmentLocation", "");
			put("equipmentAddress", "");
			put("serviceTypeId", "");
			put("serviceOrderNumber", "");
			put("ticketId", "");
			put("created", "");
			put("equipmentTypeId", "");
			put("brand", "");
			put("model", "");
			put("serialNumber", "");
			put("capacity", "");
			put("responsible", "");
			put("receivedBy", "");
			put("serviceComments", "");
			put("closed", "");
			put("hasErrors", "");
			put("materialUsed", "");
			put("cst", "");
			put("finalUser", "");
			put("qualification", "");
			put("comments", "");

		}};
		for(int i = 0; i < jsonData.size();i++){
			month = jsonData.get(i).get("created").toString().substring(5,7);
			if(! month.equals(lastMonth)){
				lastMonth = month;
				map.put("serviceUnit", MONTHS.get(month));
				jsonData.add(i, new JSONObject(map));
			}
		}
		return jsonData != null ? jsonData.toString() : "";
	}

	public List<Chart> getCharts(String project, Date startDate, Date endDate, String customer){
		List<Chart> charts = new ArrayList<Chart>();
		List<Servicecenter> serviceCenters = null;
		Chart chart = new Chart();
		chart.setTitle("TIPO DE EQUIPOS REPORTADOS");
		chart.setIs3d(true);
		chart.setType("pie");
		chart.setData(dao.getReportByEquipmentType(project, startDate, endDate, customer).toString().replaceAll("\"", "'"));
		charts.add(chart);

		chart = new Chart();
		chart.setTitle("TICKETS POR CENTRO DE SERVICIO");
		chart.setIs3d(false);
		chart.setType("bar");
		chart.setData(dao.getTicketsByServiceCenter(project, startDate, endDate, customer).toString().replaceAll("\"", "'"));
		charts.add(chart);

		serviceCenters = dao.getServiceCenterIdList();
		serviceCenters.add(0, new Servicecenter('%', "ESTATUS GENERAL", null));
		for(Servicecenter serviceCenter : serviceCenters){
			chart = new Chart();
			chart.setTitle(serviceCenter.getServiceCenter());
			chart.setIs3d(false);
			if(serviceCenter.getServiceCenterId() == '%'){
				chart.setType("donut");
			} else {
				chart.setType("pie");
			}
			chart.setData(dao.getStatus(String.valueOf(serviceCenter.getServiceCenterId()), project, startDate, endDate, customer)
					.toString().replaceAll("\"", "'"));
			charts.add(chart);
		}

		return charts;
	}
	
	public List<Chart> getDisplayCharts(String project, Date startDate, Date endDate, String customer){
		List<Chart> charts = new ArrayList<Chart>();
		List<Servicecenter> serviceCenters = null;
		Chart chart = new Chart();
		chart.setTitle("TIPO DE EQUIPOS REPORTADOS");
		chart.setIs3d(true);
		chart.setType("pie");
		chart.setData(dao.getReportByEquipmentType(project, startDate, endDate, customer).toString().replaceAll("\"", "'"));
		charts.add(chart);

		serviceCenters = new ArrayList<Servicecenter>();
		serviceCenters.add(0, new Servicecenter('%', "ESTATUS GENERAL", null));
		for(Servicecenter serviceCenter : serviceCenters){
			chart = new Chart();
			chart.setTitle(serviceCenter.getServiceCenter());
			chart.setIs3d(false);
			if(serviceCenter.getServiceCenterId() == '%'){
				chart.setType("donut");
			} else {
				chart.setType("pie");
			}
			chart.setData(dao.getStatus(String.valueOf(serviceCenter.getServiceCenterId()), project, startDate, endDate, customer)
					.toString().replaceAll("\"", "'"));
			charts.add(chart);
		}
	
		chart = new Chart();
		chart.setTitle("TICKETS POR CENTRO DE SERVICIO");
		chart.setIs3d(false);
		chart.setType("bar");
		chart.setData(dao.getTicketsByServiceCenter(project, startDate, endDate, customer).toString().replaceAll("\"", "'"));
		charts.add(chart);

		return charts;
	}

	public String getUserAverage(String project, Date startDate, Date endDate){
		List<JSONObject> jsonData = dao.getUserAverage(project, startDate, endDate);
		return jsonData != null ? jsonData.toString() : "";
	}

	public String getGeneralAverage(String project, Date startDate, Date endDate){
		List<JSONObject> jsonData = dao.getGeneralAverage(project, startDate, endDate);
		return jsonData != null ? jsonData.toString() : "";
	}

	public List<GetStatisticsKPI> getStatisticsKPI(String project, Date startDate, Date endDate){
		List<GetStatisticsKPI> statics = dao.getStatisticsKPI(project, startDate, endDate);
		return statics;
	}

	@Override
	public List<String> getProjectList() {
		return dao.getProjectList();
	}

	@Override
	public List<String> getLimitedProjectList(String user) {
		return dao.getLimitedProjectList(user);
	}

	@Override
	public AvailabilityKpiDTO getAvailability(String project, Date startDate,
			Date endDate, String user) throws Exception {
		return dao.getAvailability(project, startDate, endDate, user);
	}

}
