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
		
		for (int i=1; i<numColumns+1; i++) {
			column_name = rsmd.getColumnLabel(i);
			String raw = rs.getObject(column_name).toString();
			raw = raw.replace("\\", " ")
        		    .replace("\"", " ")
        		    .replace("\r", ". ")
        		    .replace("\n", ". ")
        		    .replace("\u2028", "\\u2028")
        		    .replace("\u2029", "\\u2029");
			
			s.append(raw);
			s.append("\t");
	    }
		
		return s.toString();
	}
}
