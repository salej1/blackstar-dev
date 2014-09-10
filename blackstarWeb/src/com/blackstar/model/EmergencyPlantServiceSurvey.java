package com.blackstar.model;

public class EmergencyPlantServiceSurvey {

	public EmergencyPlantServiceSurvey(Integer epServiceId,
			Integer epServiceSurveyId, Integer levelOilFlag,
			Integer levelWaterFlag, String levelBattery, Integer tubeLeak,
			String batteryCap, String batterySulfate, String levelOil,
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
	private Integer levelOilFlag;
	private Integer levelWaterFlag;
	private String levelBattery;
	private Integer tubeLeak;
	private String batteryCap;
	private String batterySulfate;
	private String levelOil;
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
	public Integer getLevelOilFlag() {
		return levelOilFlag;
	}
	public void setLevelOilFlag(Integer levelOilFlag) {
		this.levelOilFlag = levelOilFlag;
	}
	public Integer getLevelWaterFlag() {
		return levelWaterFlag;
	}
	public void setLevelWaterFlag(Integer levelWaterFlag) {
		this.levelWaterFlag = levelWaterFlag;
	}
	public String getLevelBattery() {
		return levelBattery;
	}
	public void setLevelBattery(String levelBattery) {
		this.levelBattery = levelBattery;
	}
	public Integer getTubeLeak() {
		return tubeLeak;
	}
	public void setTubeLeak(Integer tubeLeak) {
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
	public String getLevelOil() {
		return levelOil;
	}
	public void setLevelOil(String levelOil) {
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
