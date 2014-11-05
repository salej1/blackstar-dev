package com.blackstar.model;
import java.util.Date;
 
public class BlackstarGuid {
	private String guid;
	private Date expires;
	public String getGuid() {
		return guid;
	}
	public void setGuid(String guid) {
		this.guid = guid;
	}
	public Date getExpires() {
		return expires;
	}
	public void setExpires(Date expires) {
		this.expires = expires;
	}
}
