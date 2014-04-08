/**
 * 
 */
package com.bloom.common.bean;

/**
 * @author usuario
 *
 */
public class TicketTeamBean {
	
	
	private Long id;
	private Long idTicket;
	private Long workerRoleId;
	private Long userId;
	
	/**
	 * Constructor.
	 * @param idTicket
	 * @param workerRoleId
	 * @param userId
	 */
	public TicketTeamBean(Long idTicket, Long workerRoleId, Long userId) {
		super();
		this.idTicket = idTicket;
		this.workerRoleId = workerRoleId;
		this.userId = userId;
	}
	
	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return the idTicket
	 */
	public Long getIdTicket() {
		return idTicket;
	}
	/**
	 * @param idTicket the idTicket to set
	 */
	public void setIdTicket(Long idTicket) {
		this.idTicket = idTicket;
	}
	/**
	 * @return the workerRoleId
	 */
	public Long getWorkerRoleId() {
		return workerRoleId;
	}
	/**
	 * @param workerRoleId the workerRoleId to set
	 */
	public void setWorkerRoleId(Long workerRoleId) {
		this.workerRoleId = workerRoleId;
	}
	/**
	 * @return the userId
	 */
	public Long getUserId() {
		return userId;
	}
	/**
	 * @param userId the userId to set
	 */
	public void setUserId(Long userId) {
		this.userId = userId;
	}
	
	
	
	
	

}
