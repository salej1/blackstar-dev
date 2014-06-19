package com.blackstar.model;

public class Chart {

	private String title;
	private String type;
	private String data;
	private boolean is3d;

	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	public boolean isIs3d() {
		return is3d;
	}
	public void setIs3d(boolean is3d) {
		this.is3d = is3d;
	}
}