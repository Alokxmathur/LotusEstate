package com.axiomtank.pool.controller;

public class ControllerStates {
	public static final int HEATER_1 = 1 << 0;
	public static final int VALVE_3 = 1 << 1;
	public static final int CHECK_SYSTEM = 1 << 2;
	public static final int POOL = 1 << 3;
	public static final int SPA = 1 << 4;
	public static final int FILTER = 1 << 5;
	public static final int LIGHTS = 1 << 6;
	public static final int CLEANER = 1 << 7;
	public static final int JETS = 1 << 8;
	public static final int SERVICE = 1 << 9;
	public static final int SPA_LIGHT = 1 << 10;
	public static final int AUX_4 = 1 << 11;
	public static final int AUX_5 = 1 << 12;
	public static final int AUX_6 = 1 << 13;
	public static final int VALVE_4 = 1 << 14;
	public static final int SPILLOVER = 1 << 15;
	public static final int SYSTEM_OFF = 1 << 16;
	public static final int AUX_7 = 1 << 17;
	public static final int AUX_8 = 1 << 18;
	public static final int AUX_9 = 1 << 19;
	public static final int AUX_10 = 1 << 20;
	public static final int AUX_11 = 1 << 21;
	public static final int AUX_12 = 1 << 22;
	public static final int AUX_13 = 1 << 23;
	public static final int AUX_14 = 1 << 24;
	public static final int SUPER_CHLORINATE = 1 << 25;
	public static final int HEATER = 1 << 30;  // This is a kludge for the heater auto mode
	public static final int FILTER_LOW_SPEED = 1 << 31;  // This is a kludge for the low-speed filter
}
