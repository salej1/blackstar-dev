package com.bloom.model.dto;

public class AdvisedUserDTO {
	Integer id;
	String email;
	String name;
	Integer workerRoleTypeId;
	
	public AdvisedUserDTO() {
		super();
	}

	public AdvisedUserDTO(Integer id, String email, String name,
			Integer workerRoleTypeId) {
		super();
		this.id = id;
		this.email = email;
		this.name = name;
		this.workerRoleTypeId = workerRoleTypeId;
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getWorkerRoleTypeId() {
		return workerRoleTypeId;
	}
	public void setWorkerRoleTypeId(Integer workerRoleTypeId) {
		this.workerRoleTypeId = workerRoleTypeId;
	}
	
	
}
