package com.blackstar.services.report.util;
import java.io.ByteArrayOutputStream;

import com.pdfjet.A4;
import com.pdfjet.Box;
import com.pdfjet.Color;
import com.pdfjet.CoreFont;
import com.pdfjet.Font;
import com.pdfjet.Image;
import com.pdfjet.ImageType;
import com.pdfjet.Line;
import com.pdfjet.PDF;
import com.pdfjet.Page;
import com.pdfjet.TextLine;

public class PDFDrawer {
	
  private Page page = null;
  private PDF pdf = null;
  private ByteArrayOutputStream  stream;
  
  private static final int DEFAULT_FONT_SIZE = 8;
  private static final float DEFAULT_LINE_WIDTH = .5F;
  private static final int DEFAULT_COLOR = Color.black;
  private static final int LEFT_MARGIN = 20;
  private static final int TOP_MARGIN = 20;
  
  public PDFDrawer() throws Exception {
	stream = new ByteArrayOutputStream ();
	pdf  = new PDF(stream);
	page = new Page(pdf, A4.PORTRAIT);
  }
  
  public ByteArrayOutputStream getStream(){
	return stream;
  }
  
  public void close() throws Exception {
	pdf.close();  
  }
  
  
  public void line(int x1, int y1, int x2, int y2, int color, float width) throws Exception {
	Line line = new Line(x1 + LEFT_MARGIN, y1 + TOP_MARGIN, x2 + LEFT_MARGIN, y2 + TOP_MARGIN);
	line.setColor(color);
	line.setWidth(width);
	line.drawOn(page);
  }
  
  public void hLine(int x1, int x2, int y) throws Exception {
	line(x1, y, x2, y , DEFAULT_COLOR, DEFAULT_LINE_WIDTH);
  }
  
  public void hLine(int x1, int x2, int y, int color) throws Exception {
	line(x1, y, x2, y , color, DEFAULT_LINE_WIDTH);
  }
  
  public void vLine(int y1, int y2, int x) throws Exception {
	line(x, y1, x, y2 , DEFAULT_COLOR, DEFAULT_LINE_WIDTH);
  }
  
  public void vLine(int y1, int y2, int x, int color) throws Exception {
	line(x, y1, x, y2 , color, DEFAULT_LINE_WIDTH);
  }
  
  public void text(String text, float x, float y) throws Exception {
	text(text, x, y, false);
  }
  
  public void text(String text, float x, float y, boolean isBold) throws Exception {
	text(text, x, y, isBold, Color.black);
  }
  
  public void text(String text, float x, float y, boolean isBold, int color) throws Exception {
	text(text, x, y, isBold, color, DEFAULT_FONT_SIZE);
  }
  
  public void text(String text, float x, float y, boolean isBold, int color, int size) 
		                                                            throws Exception {
	TextLine box = new TextLine(getFont(isBold, size), text);
	box.setColor(color == 0 ? DEFAULT_COLOR : color );
	box.setPosition(x + LEFT_MARGIN, y + TOP_MARGIN);
	box.drawOn(page);
  }
  
  public void image(String path, float x, float y) throws Exception {
	Image image = new Image(pdf, getClass().getClassLoader().getResourceAsStream(path)
			                                                         , ImageType.JPG);
	image.setPosition(x + LEFT_MARGIN, y + TOP_MARGIN);
	image.drawOn(page);
  }
  
  public void box(int x, int y, int width, int height, boolean fill) throws Exception{
	box(x,y, width, height, DEFAULT_COLOR, fill);
  }
  
  public void box(int x, int y, int width, int height, int color, boolean fill) throws Exception{
	Box box = new Box();
	box.setLocation(x + LEFT_MARGIN, y + TOP_MARGIN);
	box.setSize(width, height);
	box.setColor(color);
	box.setFillShape(fill);
	box.drawOn(page);
  }
  
  private Font getFont(boolean isBold, int size) throws Exception{
	Font font = isBold ? new Font(pdf, CoreFont.TIMES_BOLD)
	                   : new Font(pdf, CoreFont.TIMES_ROMAN);
	font.setSize(size);
	return font;
  }

}
