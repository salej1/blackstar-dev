package com.blackstar.db.dao.mapper;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class PlainTextMapper implements RowMapper<String> {
	
	@Override
	public String mapRow(ResultSet rs, int index) throws SQLException {
		ResultSetMetaData rsmd = rs.getMetaData();
		int numColumns = rsmd.getColumnCount();
		String column_name;
		StringBuilder s = new StringBuilder();
		
		if(rs != null){
			for (int i=1; i<numColumns+1; i++) {
				column_name = rsmd.getColumnLabel(i);
				Object raw = rs.getObject(column_name);
				if(raw == null){
					s.append("N/A");
				}
				else{
					String rawStr = raw.toString();
					rawStr = rawStr.replace("\\", " ")
		        		    .replace("\"", " ")
		        		    .replace("\r", ". ")
		        		    .replace("\n", ". ")
		        		    .replace("\u2028", "\\u2028")
		        		    .replace("\u2029", "\\u2029");
					
					s.append(rawStr);
					s.append("\t");
				}
		    }
		}
				
		return s.toString();
	}
}
