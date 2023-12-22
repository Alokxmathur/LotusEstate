package com.axiomtank.pool.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import javax.json.Json;
import javax.json.JsonObject;


public class ControllerState {
	Date ledBasedUpdateTime = new Date(), displayBasedUpdateTime = new Date();
	int poolTemp = -99, spaTemp=-99, airTemp=-99, saltLevel=0, poolChlorinator = -99, spaChlorinator = -99, spaCountDown=-99;
	boolean filterOn, cleanerOn, heaterOn, jetsOn, spaLightOn, poolLightsOn;
	ArrayList<Request> pendingRequests = new ArrayList<>();
	String lastSystemMessage = "";
	boolean messageChanged = false;
	public enum Mode {
		Pool, Spa, Spillover, Unknown
	}
	public enum Menu {
		Default, Settings, Timers, Diagnostic, Configuration
	}
	public static final String COLON_STRING = 
			new String(new byte[] { (byte) 0xef, (byte) 0xbf, (byte) 0xbd});
	Mode mode = Mode.Unknown;
	Menu menu = Menu.Default;
	String checkSystem = "", controllerMessage = "";
	
	public int getPoolTemp() {
		return poolTemp;
	}
	public void setPoolTemp(int poolTemp) {
		this.poolTemp = poolTemp;
	}
	public void setPoolTemp(String poolTemp) {
		try {
			this.poolTemp = Integer.parseInt(poolTemp);
		}
		catch (Throwable e) {
			this.poolTemp = -99;
		}
	}
	public int getSpaTemp() {
		return spaTemp;
	}
	public void setSpaTemp(int spaTemp) {
		this.spaTemp = spaTemp;
	}
	public void setSpaTemp(String spaTemp) {
		try {
			this.spaTemp = Integer.parseInt(spaTemp);
		}
		catch (Throwable e) {
			this.spaTemp = -99;
		}
	}
	public int getSpaCountDownMinutes() {
		return spaCountDown;
	}
	public void setSpaCoutDown(int spaCountDown) {
		this.spaCountDown = spaCountDown;
	}
	public void setSpaCountDown(String spaCountDown) {
		this.spaCountDown = -99;
		String[] spaCountDownParts = spaCountDown.replaceAll("<u>", "").replaceAll("</u>", "").split(":");
		if  (spaCountDownParts.length == 2) {
			try {
				this.spaCountDown = Integer.parseInt(spaCountDownParts[0]) * 60 
					+ Integer.parseInt(spaCountDownParts[1]);
			}
			catch (Throwable e) {
				e.printStackTrace();
				byte[] myBytes;
				try {
					myBytes = spaCountDown.getBytes("UTF-8");
					System.out.println(Frame.byteArrayToHex(myBytes, myBytes.length));
				} catch (UnsupportedEncodingException e1) {
					e1.printStackTrace();
				}
			}
		}
		else {
			System.out.println("Unable to get spa countdown from " + spaCountDown + ", parts count=" + spaCountDownParts.length);
		}
	}
	public int getAirTemp() {
		return airTemp;
	}
	public void setAirTemp(int airTemp) {
		this.airTemp = airTemp;
	}
	public void setAirTemp(String airTemp) {
		try {
			this.airTemp = Integer.parseInt(airTemp);
		}
		catch (Throwable e) {
			this.airTemp = -99;
		}
	}
	public int getPoolChlorinator() {
		return poolChlorinator;
	}
	public void setPoolChlorinator(int poolChlorinator) {
		this.poolChlorinator = poolChlorinator;
	}
	public void setPoolChlorinator(String poolChlorinator) {
		try {
			this.poolChlorinator = Integer.parseInt(poolChlorinator);
		}
		catch (Throwable e) {
			this.poolChlorinator = -99;
		}
	}
	public int getSpaChlorinator() {
		return spaChlorinator;
	}
	public void setSpaChlorinator(int spaChlorinator) {
		this.airTemp = spaChlorinator;
	}
	public void setSpaChlorinator(String spaChlorinator) {
		try {
			this.spaChlorinator = Integer.parseInt(spaChlorinator);
		}
		catch (Throwable e) {
			this.spaChlorinator = -99;
		}
	}
	public boolean isFilterOn() {
		return filterOn;
	}
	public void setFilterOn(boolean filterOn) {
		this.filterOn = filterOn;
	}
	public boolean isCleanerOn() {
		return cleanerOn;
	}
	public void setCleanerOn(boolean cleanerOn) {
		this.cleanerOn = cleanerOn;
	}
	public boolean isHeaterOn() {
		return heaterOn;
	}
	public void setHeaterOn(boolean heaterOn) {
		this.heaterOn = heaterOn;
	}
	public boolean areJetsOn() {
		return jetsOn;
	}
	public void setJetsOn(boolean jetsOn) {
		this.jetsOn = jetsOn;
	}
	public boolean isSpaLightOn() {
		return spaLightOn;
	}
	public void setSpaLightOn(boolean spaLightOn) {
		this.spaLightOn = spaLightOn;
	}
	public boolean arePoolLightsOn() {
		return poolLightsOn;
	}
	public void setPoolLightsOn(boolean poolLightsOn) {
		this.poolLightsOn = poolLightsOn;
	}
	public Mode getMode() {
		return mode;
	}
	public void setMode(Mode mode) {
		this.mode = mode;
	}
	public Menu getMenu() {
		return menu;
	}
	/**
	 * Return the next expected menu when the Menu key is pressed on the controller
	 * 
	 * @param menu
	 * @return
	 */
	public Menu getNextMenu(Menu menu) {
		switch (menu) {
			case Default:
				return Menu.Settings;
			case Settings:
				return Menu.Timers;
			case Timers:
				return Menu.Diagnostic;
			case Diagnostic:
				return Menu.Configuration;
			case Configuration:
				return Menu.Default;
			default: return Menu.Settings;
		}
	}
	public void setMenu(Menu menu) {
		this.menu = menu;
	}
	public void setMenu(String menu) {
		//System.out.println("Setting menu: " + menu);
		if ("Default".equals(menu)) {
			this.menu = Menu.Default;
		}
		else if ("Timers".equals(menu)) {
			this.menu = Menu.Timers;
		}
		else if ("Settings".equals(menu)) {
			this.menu = Menu.Settings;
		}
		else if ("Diagnostic".equals(menu)) {
			this.menu = Menu.Diagnostic;
		}
		else if ("Config".equals(menu)) {
			this.menu = Menu.Timers;
		}
		else if ("Configuration".equals(menu)) {
			this.menu = Menu.Configuration;
		}
	}
	
	public int getSaltLevel() {
		return saltLevel;
	}
	public void setSaltLevel(int saltLevel) {
		this.saltLevel = saltLevel;
	}
	public void setSaltLevel(String saltLevel) {
		try {
			this.saltLevel = Integer.parseInt(saltLevel);
		}
		catch (Throwable e) {
			this.saltLevel = -99;
		}
	}
	public String getCheckSystem() {
		return checkSystem;
	}
	public void setCheckSystem(String checkSystem) {
		this.checkSystem = checkSystem;
	}
	public String getControllerMessage() {
		return controllerMessage;
	}
	public void setControllerMessage(String controllerMessage) {
		if (!controllerMessage.equals(lastSystemMessage)) {
			this.controllerMessage = controllerMessage;
			lastSystemMessage = controllerMessage;
			messageChanged = true;
		}
		else {
			messageChanged = false;
		}
	}
	public Date getLedBasedUpdateTime() {
		return ledBasedUpdateTime;
	}
	public void setLedBasedUpdateTime() {
		this.ledBasedUpdateTime = new Date();
	}
	public Date getDisplayBasedUpdateTime() {
		return displayBasedUpdateTime;
	}
	public void setDisplayBasedUpdateTime() {
		this.displayBasedUpdateTime = new Date();
	}
	public ArrayList<Request> getPendingRequests() {
		return pendingRequests;
	}
	public void setPendingRequests(ArrayList<Request> pendingRequests) {
		this.pendingRequests = pendingRequests;
	}
	public boolean isHotTubSetup() {
		return heaterOn && filterOn && mode == Mode.Spa;
	}
	public boolean canCleanerBeOn() {
		return mode == Mode.Pool && isFilterOn();
	}
	public boolean didMessageChange() {
		return messageChanged;
	}
	
	
	
	public String getPendingRequestsStatus() {
		 StringBuffer pendingStatus = new StringBuffer();
		 for (Request pendingRequest: pendingRequests) {
			 if (!pendingStatus.isEmpty()) {
				 pendingStatus.append(", ");
			 }
			 pendingStatus.append(pendingRequest.getType()); 
		 }
		 return pendingStatus.toString();
	}
	public String toString() {
		return String.format(Locale.getDefault(), 
				"\n\t\tMode: %s,\n\t FilterOn: %b,\n\tCleanerOn: %b,\n\tLightsOn: %b,\n\tSpaLightOn: %b,\n\tBlowerOn: %b, \n\tHeaterOn: %b,\n\tAir Temp:%2d",
				mode, filterOn, cleanerOn, poolLightsOn, spaLightOn, jetsOn, heaterOn, airTemp);
	}

	
	public JsonObject toJSON() {
		JsonObject json = Json.createObjectBuilder()
			.add("SystemWarning", checkSystem)
			.add("Mode", getMode().toString())
			.add("Filter", isFilterOn() ? "On": "Off")
			.add("Cleaner", isCleanerOn() ? "On": "Off")
			.add("Lights", arePoolLightsOn() ? "On": "Off")
			.add("Spa Light", isSpaLightOn() ? "On": "Off")
			.add("Jets", areJetsOn() ? "On": "Off")
			.add("Heater", isHeaterOn() ? "On": "Off")
			.add("Air Temp", airTemp)
			.add("Pool Temp", poolTemp)	
			.add("Spa Temp", spaTemp)
			.add("Salt Level", saltLevel)
			.add("Pool Chlorinator", poolChlorinator)
			.add("Spa Chlorinator", spaChlorinator)
			.build();
		return json;
	}

}
