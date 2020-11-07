package com.blackstar.services.report.util;

import java.util.ArrayList;
import java.util.List;

import com.pdfjet.Box;
import com.pdfjet.Drawable;

public class DrawerPage {
	private List<Drawable> objects = new ArrayList<Drawable>();
	private List<Box> boxes = new ArrayList<Box>();
	
	public DrawerPage(){
		
	}
	
	public void add(Drawable d){
		objects.add(d);
	}
	
	public void add(Box b){
		boxes.add(b);
	}

	public List<Drawable> getObjects() {
		return objects;
	}

	public List<Box> getBoxes() {
		return boxes;
	}
	
}
