package com.blackstar.db.dao.mapper;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.jdbc.core.RowMapper;

public class JSONRowMapper implements RowMapper<JSONObject>{

  @Override
  public JSONObject mapRow(ResultSet rs, int index) throws SQLException {
	ResultSetMetaData rsmd = rs.getMetaData();
	int numColumns = rsmd.getColumnCount();
	JSONObject obj = new JSONObject();
	String column_name = null;
	String s = null;
	try {
	     for (int i=1; i<numColumns+1; i++) {
	       column_name = rsmd.getColumnLabel(i);
	       if(rsmd.getColumnType(i)==java.sql.Types.ARRAY){
	         obj.put(column_name, rs.getArray(column_name));
	       } else if(rsmd.getColumnType(i)==java.sql.Types.BIGINT){
	         obj.put(column_name, rs.getInt(column_name));
	       } else if(rsmd.getColumnType(i)==java.sql.Types.BOOLEAN){
	         obj.put(column_name, rs.getBoolean(column_name));
	       } else if(rsmd.getColumnType(i)==java.sql.Types.BLOB){
	         obj.put(column_name, rs.getBlob(column_name));
	       } else if(rsmd.getColumnType(i)==java.sql.Types.DOUBLE){
	         obj.put(column_name, rs.getDouble(column_name)); 
	       } else if(rsmd.getColumnType(i)==java.sql.Types.FLOAT){
	         obj.put(column_name, rs.getFloat(column_name));
	       } else if(rsmd.getColumnType(i)==java.sql.Types.INTEGER){
	         obj.put(column_name, rs.getInt(column_name));
	       } else if(rsmd.getColumnType(i)==java.sql.Types.NVARCHAR){
	           s = rs.getNString(column_name);
	           if(s != null){
		          s = s.replace("\\", " ")
		        	   .replace("\"", " ")
		        	   .replace("\r", ". ")
		        	   .replace("\n", ". ")
		        	   .replace("\u2028", "\\u2028")
		        	   .replace("\u2029", "\\u2029");
	        	}
	            obj.put(column_name, s);
	        } else if(rsmd.getColumnType(i)==java.sql.Types.VARCHAR){
	        	s = rs.getString(column_name);
	        	if(s != null){
		        	s = s.replace("\\", " ")
		        		    .replace("\"", " ")
		        		    .replace("\r", ". ")
		        		    .replace("\n", ". ")
		        		    .replace("\u2028", "\\u2028")
		        		    .replace("\u2029", "\\u2029");
	        	}
	           obj.put(column_name, s);
	        } else if(rsmd.getColumnType(i)==java.sql.Types.TINYINT){
	            obj.put(column_name, rs.getInt(column_name));
	        } else if(rsmd.getColumnType(i)==java.sql.Types.SMALLINT){
	            obj.put(column_name, rs.getInt(column_name));
	        } else if(rsmd.getColumnType(i)==java.sql.Types.DATE){
	            obj.put(column_name, rs.getDate(column_name));
	        } else if(rsmd.getColumnType(i)==java.sql.Types.TIMESTAMP){
	            obj.put(column_name, rs.getTimestamp(column_name));   
	        } else{
	            obj.put(column_name, rs.getObject(column_name));
	        }
	      }
	} catch(JSONException je){
		throw new SQLException(je);
	}
	return obj;
  }

}
