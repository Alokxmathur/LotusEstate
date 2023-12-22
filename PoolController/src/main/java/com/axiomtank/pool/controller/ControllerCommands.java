package com.axiomtank.pool.controller;

public class ControllerCommands {
    public static final int[] POOL_SPA = {0x0040};
    public static final int[] FILTER = {0x0080};
    public static final int[] LIGHTS = {0x0100};
    public static final int[] CLEANER = {0x0200};
    public static final int[] JETS = {0x0400};
    public static final int[] SPA_LIGHT = {0x0800};
    public static final int[] MENU = {0x0002};
    public static final int[] HEATER = {0x00040000};
    public static final int[] LEFT_KEY = {0x0004};
    public static final int[] RIGHT_KEY = {0x0001};
    public static final int[] PLUS_KEY = {0x0020};
    public static final int[] MINUS_KEY = {0x0010};
    public static final int[] LEFT_AND_RIGHT_KEY = {0x0004, 0x0001};

    
    
    public static int[] getCommandForRequest(Request request) {
		switch (request.getType()) {
			case PoolLightsOn:
			case PoolLightsOff:
				return LIGHTS;
			case SpaLightOn:
			case SpaLightOff:
				return SPA_LIGHT;
			case HeaterOn:
			case HeaterOff:
				return HEATER;
			case JetsOn:
			case JetsOff:
				return JETS;
			case FilterOn:
			case FilterOff:
				return FILTER;
			case CleanerOn:
			case CleanerOff:
				return CLEANER;
			case PoolMode:
			case SpaMode:
			case SpillOverMode:
				return POOL_SPA;
			case DefaultMenuMode:
			case TimersMenuMode:
			case SettingsMenuMode:
			case DiagnosticMenuMode:
			case ConfigurationMenuMode:
				return MENU;
			case LeftKey:
				return LEFT_KEY;
			case RightKey:
				return RIGHT_KEY;
			case PlusKey:
				return PLUS_KEY;
			case MinusKey:
				return MINUS_KEY;
			case LeftAndRightKey:
				return LEFT_AND_RIGHT_KEY;
				
			default:
				return new int[0];
		}
    }
}
