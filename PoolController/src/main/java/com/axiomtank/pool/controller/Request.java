package com.axiomtank.pool.controller;

import java.util.ArrayList;
import java.util.Date;

import com.axiomtank.pool.controller.ControllerState.Menu;
import com.axiomtank.pool.controller.ControllerState.Mode;

public class Request {
	public enum Type {
		PoolLightsOn, PoolLightsOff, 
		HeaterOn, HeaterOff, 
		FilterOn, FilterOff, 
		JetsOn, JetsOff, 
		SpaLightOn, SpaLightOff, 
		CleanerOn, CleanerOff,
		PoolMode, 
		SpaMode, 
		SpillOverMode,
		HotTubOn, HotTubOff,
		DefaultMenuMode,
		TimersMenuMode,
		SettingsMenuMode,
		DiagnosticMenuMode,
		ConfigurationMenuMode,
		RightKey,
		LeftKey,
		LeftAndRightKey,
		PlusKey,
		MinusKey
	}
	String description;
	Type type;
	ArrayList<Frame> frames = null;
	int issueCount = 0, statusCheckCount = 0;;
	
	Date lastIssueTime = null, firstIssueTime = null;
	
	public Request(Type type) {
		this.type = type;
		makeFramesForRequest();
	}
	
	public void setupForIssuance() {
		this.lastIssueTime = new Date();
		if (this.firstIssueTime == null) {
			this.firstIssueTime = this.lastIssueTime;
			//System.out.println("Set first issue time = " + this.firstIssueTime);
		}
		issueCount++;
		//System.out.println("Issuing " + type + " command");
	}

	public int getIssueCount() {
		return issueCount;
	}

	public boolean wasIssued() {
		return lastIssueTime != null;
	}
	
	public Type getType() {
		return type;
	}

	/**
	 * Check if this request has been satisfied
	 * @param state
	 * @return
	 */
	public boolean isComplete(ControllerState state) {
		if (!wasIssued()) {
			//even if a request was never issued, if the state says it's already there, we don't issue it
			return stateAchieved(state);
		}
		//check if we have received a status update from display or led
		else {
			if (statusCheckCount ++ >1) {
				return stateAchieved(state);
			}
			return false;
		}
	}
	
	public long getElapsedSinceFirstIssue() {
		if (wasIssued()) {
			return new Date().getTime() - firstIssueTime.getTime();
		}
		return 0;
	}
	public long getElapsedSinceLastIssue() {
		if (wasIssued()) {
			return new Date().getTime() - lastIssueTime.getTime();
		}
		return 0;
	}
	
	public boolean stateAchieved(ControllerState state) {
		switch (this.type) {
			case PoolLightsOn:
				return state.arePoolLightsOn();
			case PoolLightsOff:
				return !state.arePoolLightsOn();
			case SpaLightOn:
				return state.isSpaLightOn();
			case SpaLightOff:
				return !state.isSpaLightOn();
			case HeaterOn:
				return state.isHeaterOn();
			case HeaterOff:
				return !state.isHeaterOn();
			case JetsOn:
				return state.areJetsOn();
			case JetsOff:
				return !state.areJetsOn();
			case FilterOn:
				return state.isFilterOn();
			case FilterOff:
				return !state.isFilterOn();
			case CleanerOn:
				return state.isCleanerOn();
			case CleanerOff:
				return !state.isCleanerOn();
			case PoolMode:
				return state.getMode() == Mode.Pool;
			case SpaMode:
				return state.getMode() == Mode.Spa;
			case SpillOverMode:
				return state.getMode() == Mode.Spillover;
			case HotTubOn:
			case HotTubOff:
				return true;
			case DefaultMenuMode:
				return state.getMenu() == Menu.Default;
			case TimersMenuMode:
				return state.getMenu() == Menu.Timers;
			case SettingsMenuMode:
				return state.getMenu() == Menu.Settings;
			case DiagnosticMenuMode:
				return state.getMenu() == Menu.Diagnostic;
			case ConfigurationMenuMode:
				return state.getMenu() == Menu.Configuration;
			case RightKey:
			case PlusKey:
			case MinusKey:
			case LeftKey:
			case LeftAndRightKey:
				return state.didMessageChange();
			default:
				return true;
		}
	}
	/**
	 * Make a frame for this request
	 */
    public void makeFramesForRequest() {
    	if (this.frames == null) {
    		this.frames = new ArrayList<>();
    		int requestCodes[] = ControllerCommands.getCommandForRequest(this);
    		for (int requestCode: requestCodes) {
    			Frame frame = new Frame();
    	        frame.add((byte)Controller.FRAME_DLE, false);
    	        frame.add((byte)Controller.FRAME_STX);
    	        
    	        if (requestCode > 0xffff) {
    	            frame.add(Frame.FRAME_TYPE_WIRELESS_KEY_EVENT, 2);
    	            frame.add(0x01, 1);
    	            frame.addLittleEndian(requestCode, 4);
    	            frame.addLittleEndian(requestCode, 4);
    	            frame.add(0x00, 1);	            
    	        }
    	        else {
    	            frame.add(Frame.FRAME_TYPE_LOCAL_WIRED_KEY_RELEASED_EVENT, 2);
    	            frame.addLittleEndian(requestCode, 2);
    	            frame.add(0x00, 1);
    	            frame.add(0x00, 1);
    	            frame.addLittleEndian(requestCode, 2);
    	            frame.add(0x00, 1);
    	            frame.add(0x00, 1);    
    	        }
    	        
    	        int checksum = Frame.getCheckSum(frame.frameContents);
    	        //System.out.println("Checksum = " + checksum);
    	        frame.add(checksum, 2);
    	        
    	        frame.add((byte) Controller.FRAME_DLE, false);
    	        frame.add(Controller.FRAME_ETX, 1);
    	        
    	        this.frames.add(frame);
    		}
	        System.out.println("Generated " + this.frames.size() + " frames for " + this.type + " request");
    	}

    }

	public ArrayList<Frame> getFrames() {
		return this.frames;
	}


	public Date getIssueTime() {
		return lastIssueTime;
	}

	public boolean statusChecked() {
		return statusCheckCount > 0;
	}
}
