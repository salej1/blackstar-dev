/**
 * 
 */
package com.bloom.common.bean;

/**
 * @author oscar.martinez
 *
 */
public class TicketTeamBean {
	
	
	private Long id;
	private Long idTicket;
	private Long workerRoleId;
	private Long userId;
	private String userGroup;
	
	/*-----Estos campos no van a la base de datos-----*/
	private String email;
	private String userName;
	/*------------------------------------------------*/
	

	/**
	 * Constructor vacio.
	 */
	public TicketTeamBean() {
	}
	
	
	/**
	 * Constructor.
	 * @param idTicket
	 * @param workerRoleId
	 * @param userId
	 */
	public TicketTeamBean(Long idTicket, Long workerRoleId, Long userId, String userGroup) {
		super();
		this.idTicket = idTicket;
		this.workerRoleId = workerRoleId;
		this.userId = userId;
		this.userGroup = userGroup;
	}
	
	/**
	 * Constructor.
	 * @param idTicket
	 * @param workerRoleId
	 * @param userId
	 * @param email
	 * @param userName
	 */
	public TicketTeamBean(Long idTicket, Long workerRoleId, Long userId, String email,String userName, String userGroup) {
		super();
		this.idTicket = idTicket;
		this.workerRoleId = workerRoleId;
		this.userId = userId;
		this.email=email;
		this.userName=userName;
		this.userGroup = userGroup;
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


	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}


	/**
	 * @param email the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}


	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}


	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}


	public String getUserGroup() {
		return userGroup;
	}


	public void setUserGroup(String userGroup) {
		this.userGroup = userGroup;
	}
	
	
	
	
	

}
