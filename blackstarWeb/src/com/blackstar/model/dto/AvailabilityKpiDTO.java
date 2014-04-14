package com.blackstar.model.dto;

import java.io.Serializable;

public class AvailabilityKpiDTO implements Serializable{

	private static final long serialVersionUID = 8587987210322310970L;

	Double availability;
	Double solutionAverageTime;
	Double onTimeResolvedTickets;
	Double onTimeAttendedTickets;
	Integer totalTickets;
	
	public Double getAvailability() {
		return availability;
	}
	public void setAvailability(Double availability) {
		this.availability = availability;
	}
	public Double getSolutionAverageTime() {
		return solutionAverageTime;
	}
	public void setSolutionAverageTime(Double solutionAverageTime) {
		this.solutionAverageTime = solutionAverageTime;
	}
	public Double getOnTimeResolvedTickets() {
		return onTimeResolvedTickets;
	}
	public void setOnTimeResolvedTickets(Double onTimeResolvedTickets) {
		this.onTimeResolvedTickets = onTimeResolvedTickets;
	}
	public Double getOnTimeAttendedTickets() {
		return onTimeAttendedTickets;
	}
	public void setOnTimeAttendedTickets(Double onTimeAttendedTickets) {
		this.onTimeAttendedTickets = onTimeAttendedTickets;
	}
	public Integer getTotalTickets() {
		return totalTickets;
	}
	public void setTotalTickets(Integer totalTickets) {
		this.totalTickets = totalTickets;
	}
}
