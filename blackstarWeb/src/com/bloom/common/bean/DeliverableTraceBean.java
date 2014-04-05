/**
 * 
 */
package com.bloom.common.bean;

import java.util.Date;

/**
 * @author Oscar.Martinez
 *
 */
public class DeliverableTraceBean {
	
	
	private Long ticketId;
	private Long deliverableId;
	private Date deliverableDate;
	/**
	 * @return the ticketId
	 */
	public Long getTicketId() {
		return ticketId;
	}
	/**
	 * @param ticketId the ticketId to set
	 */
	public void setTicketId(Long ticketId) {
		this.ticketId = ticketId;
	}
	/**
	 * @return the deliverableId
	 */
	public Long getDeliverableId() {
		return deliverableId;
	}
	/**
	 * @param deliverableId the deliverableId to set
	 */
	public void setDeliverableId(Long deliverableId) {
		this.deliverableId = deliverableId;
	}
	/**
	 * @return the deliverableDate
	 */
	public Date getDeliverableDate() {
		return deliverableDate;
	}
	/**
	 * @param deliverableDate the deliverableDate to set
	 */
	public void setDeliverableDate(Date deliverableDate) {
		this.deliverableDate = deliverableDate;
	}
	
	
	

}
