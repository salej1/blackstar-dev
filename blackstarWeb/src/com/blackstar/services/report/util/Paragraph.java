package com.blackstar.services.report.util;
import java.util.ArrayList;
import java.util.List;

import com.pdfjet.*;

public class Paragraph {
	Align alignment;
	List<String> lines = new ArrayList<String>();
	Point position;
	int width = 540;
	Font font;
	int color;
	
	private static final int DEFAULT_COLOR = Color.black;
	  
	public void drawOn(Page page) throws Exception{
		List<TextLine> outLines = new ArrayList<TextLine>();
		
		// capture
		for(String rawLine : lines){
			String[] tokens = rawLine.split(" ");
			StringBuilder line = new StringBuilder();
			TextLine outLine = null;
			
			for(String token : tokens){
				
				int fitChars = font.getFitChars(line.toString(), this.width);
				if(line.length() + token.length() + 1 <= fitChars){
					line.append(" " + token);
				}
				else{
					outLine = new TextLine(font);
					outLine.setText(line.toString());
					outLines.add(outLine);
					line = new StringBuilder();
				}
			}
		}
		
		// alignment
		
		// print
		double y = position.getY();
		double x = 0;
		for(TextLine outLine : outLines){
			outLine.setColor(color == 0 ? DEFAULT_COLOR : color );
			if(alignment == Align.CENTER){
				x = (width - font.stringWidth(outLine.getText())) /2;
			}
			outLine.setPosition(position.getX(), y);
			outLine.drawOn(page);
			y = font.getBodyHeight() + 2;
		}
	}

	public void add(String line){
		lines.add(line);
	}
	
	public Align getAlignment() {
		return alignment;
	}

	public void setAlignment(Align alignment) {
		this.alignment = alignment;
	}
	
	public void setPosition(int x, int y){
		position = new Point(x, y);
	}
	
	public Font getFont() {
		return font;
	}

	public void setFont(Font font) {
		this.font = font;
	}
	
	public enum Align{
		LEFT,
		RIGHT,
		CENTER,
		JUSTIFY
	}

	public int getColor() {
		return color;
	}

	public void setColor(int color) {
		this.color = color;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}
}


