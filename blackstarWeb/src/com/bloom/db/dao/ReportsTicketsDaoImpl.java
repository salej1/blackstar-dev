package com.bloom.db.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import com.blackstar.db.dao.AbstractDAO;
import com.bloom.common.bean.ReportTicketBean;

@SuppressWarnings("unchecked")
public class ReportsTicketsDaoImpl extends AbstractDAO implements
	ReportsTicketsDao {

	private static final String QUERY_STATISTICS_AREA = "CALL GetBloomStatisticsByAreaSupport(%d,%s)";

	private static final String QUERY_SUPPORT_AREAS = "CALL GetBloomSupportAreasWithTickets()";
	
	
	

	private static final class InternalTicketMapper implements
			RowMapper<ReportTicketBean> {

		private String nameStoreProcedure;
		
		private DecimalFormat df = new DecimalFormat();

		public InternalTicketMapper(String nameStoreProcedure) {
			this.nameStoreProcedure = nameStoreProcedure;
			df.setMaximumFractionDigits(2);
		}

		@Override
		public ReportTicketBean mapRow(ResultSet rs, int rowNum)
				throws SQLException {
			
			ReportTicketBean bean = new ReportTicketBean();
			
			if(nameStoreProcedure.equals("GetBloomSupportAreasWithTickets")){
				bean.setValue5(rs.getInt("UserGroupId"));
				bean.setValue1(rs.getString("name"));
			}
			else if(nameStoreProcedure.equals("GetBloomStatisticsByAreaSupport")){
				
				bean.setValue1(rs.getString("groupName"));
				bean.setValue2(df.format(rs.getFloat("maxTime")));
				bean.setValue3(df.format(rs.getFloat("minTime")));
				bean.setValue4(df.format(rs.getFloat("promTime")));
				
			}else if(nameStoreProcedure.equals("GetBloomPercentageTimeClosedTickets") || 
					nameStoreProcedure.equals("GetBloomPercentageEvaluationTickets")){
				
				bean.setValue1(df.format(rs.getFloat("satisfactoryPercentage"))+"%");
				bean.setValue2(df.format(rs.getFloat("unsatisfactoryPercentage"))+"%");
				
			}else if(nameStoreProcedure.equals("GetBloomNumberTicketsByArea")){
				
				bean.setValue5(rs.getInt("noTickets"));
				bean.setValue1(rs.getString("userGroup"));
				
			}else if(nameStoreProcedure.equals("GetBloomUnsatisfactoryTicketsByUserByArea")){
				
				bean.setValue5(rs.getInt("noTickets"));
				bean.setValue1(rs.getString("userName"));
				
			}

			return bean;
		}
	}

	public List<ReportTicketBean> getStatisticsByAreaSupport() {
		
		
		List<ReportTicketBean> listStatisticsArea = new ArrayList<ReportTicketBean>();
		
		List<ReportTicketBean> listAreas;
		
		
		listAreas=getJdbcTemplate().query(QUERY_SUPPORT_AREAS, new InternalTicketMapper("GetBloomSupportAreasWithTickets"));
		
		
		for(ReportTicketBean bean:listAreas){
			List<ReportTicketBean> listDataArea = getJdbcTemplate().query(
					String.format(QUERY_STATISTICS_AREA, bean.getValue5(),bean.getValue1()), 
					new InternalTicketMapper("GetBloomStatisticsByAreaSupport"));
				
				ReportTicketBean area;
				area = listDataArea.get(0);
				listStatisticsArea.add(area);
			
		}
		
		
		return listStatisticsArea;
	
	}

}