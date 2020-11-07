package com.blackstar.model;

public class EmergencyPlantServiceSurvey {

	public EmergencyPlantServiceSurvey(Integer epServiceId,
			Integer epServiceSurveyId, Boolean levelOilFlag,
			Boolean levelWaterFlag, Integer levelBattery, Boolean tubeLeak,
			String batteryCap, String batterySulfate, Integer levelOil,
			String heatEngine, String hoseOil, String hoseWater,
			String tubeValve, String stripBlades) {
		this.epServiceId = epServiceId;
		this.epServiceSurveyId = epServiceSurveyId;
		this.levelOilFlag = levelOilFlag;
		this.levelWaterFlag = levelWaterFlag;
		this.levelBattery = levelBattery;
		this.tubeLeak = tubeLeak;
		this.batteryCap = batteryCap;
		this.batterySulfate = batterySulfate;
		this.levelOil = levelOil;
		this.heatEngine = heatEngine;
		this.hoseOil = hoseOil;
		this.hoseWater = hoseWater;
		this.tubeValve = tubeValve;
		this.stripBlades = stripBlades;
	}
	
	private Integer epServiceId;
	private Integer epServiceSurveyId;
	private Boolean levelOilFlag;
	private Boolean levelWaterFlag;
	private Integer levelBattery;
	private Boolean tubeLeak;
	private String batteryCap;
	private String batterySulfate;
	private Integer levelOil;
	private String heatEngine;
	private String hoseOil;
	private String hoseWater;
	private String tubeValve;
	private String stripBlades;
	
	public Integer getEpServiceId() {
		return epServiceId;
	}
	public void setEpServiceId(Integer epServiceId) {
		this.epServiceId = epServiceId;
	}
	public Integer getEpServiceSurveyId() {
		return epServiceSurveyId;
	}
	public void setEpServiceSurveyId(Integer epServiceSurveyId) {
		this.epServiceSurveyId = epServiceSurveyId;
	}
	public Boolean getLevelOilFlag() {
		return levelOilFlag;
	}
	public void setLevelOilFlag(Boolean levelOilFlag) {
		this.levelOilFlag = levelOilFlag;
	}
	public Boolean getLevelWaterFlag() {
		return levelWaterFlag;
	}
	public void setLevelWaterFlag(Boolean levelWaterFlag) {
		this.levelWaterFlag = levelWaterFlag;
	}
	public Integer getLevelBattery() {
		return levelBattery;
	}
	public void setLevelBattery(Integer levelBattery) {
		this.levelBattery = levelBattery;
	}
	public Boolean getTubeLeak() {
		return tubeLeak;
	}
	public void setTubeLeak(Boolean tubeLeak) {
		this.tubeLeak = tubeLeak;
	}
	public String getBatteryCap() {
		return batteryCap;
	}
	public void setBatteryCap(String batteryCap) {
		this.batteryCap = batteryCap;
	}
	public String getBatterySulfate() {
		return batterySulfate;
	}
	public void setBatterySulfate(String batterySulfate) {
		this.batterySulfate = batterySulfate;
	}
	public Integer getLevelOil() {
		return levelOil;
	}
	public void setLevelOil(Integer levelOil) {
		this.levelOil = levelOil;
	}
	public String getHeatEngine() {
		return heatEngine;
	}
	public void setHeatEngine(String heatEngine) {
		this.heatEngine = heatEngine;
	}
	public String getHoseOil() {
		return hoseOil;
	}
	public void setHoseOil(String hoseOil) {
		this.hoseOil = hoseOil;
	}
	public String getHoseWater() {
		return hoseWater;
	}
	public void setHoseWater(String hoseWater) {
		this.hoseWater = hoseWater;
	}
	public String getTubeValve() {
		return tubeValve;
	}
	public void setTubeValve(String tubeValve) {
		this.tubeValve = tubeValve;
	}
	public String getStripBlades() {
		return stripBlades;
	}
	public void setStripBlades(String stripBlades) {
		this.stripBlades = stripBlades;
	}
	
	
}
