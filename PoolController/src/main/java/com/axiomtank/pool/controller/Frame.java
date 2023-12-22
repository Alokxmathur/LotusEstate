package com.axiomtank.pool.controller;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Frame {
	public enum Type {
		Display, LongDisplay, LED, KeepAlive, WirelessKeyEvent, WiredKeyEvent, Unknown
	}
	public static int FRAME_TYPE_LOCAL_WIRED_KEY_PRESSED_EVENT = 0x01;
	public static int FRAME_TYPE_LOCAL_WIRED_KEY_RELEASED_EVENT = 0x02;
	public static int FRAME_TYPE_REMOTE_WIRED_KEY_EVENT = 0x03;
	public static int FRAME_TYPE_WIRELESS_KEY_EVENT = 0x83;
	public static int FRAME_TYPE_ON_OFF_EVENT = 0x05; // Seems to only work for some keys

	public static int FRAME_TYPE_KEEP_ALIVE = 0x0101;
	public static int FRAME_TYPE_LEDS = 0x0102;
	public static int FRAME_TYPE_DISPLAY_UPDATE = 0x0103;
	public static int FRAME_TYPE_LONG_DISPLAY_UPDATE = 0x040A;
	
	ArrayList<Byte> frameContents = new ArrayList<>();
	
	public byte[] getBytes() {
		byte bytes[] = new byte[frameContents.size()];
		int i = 0;
		for (Byte bite: frameContents) {
			bytes[i++] = bite;
		}
		return bytes;
	}
	
	public byte[] getContentBytes() {
		byte bytes[] = new byte[frameContents.size()-2];
		for (int i=2; i < bytes.length; i++) {
			bytes[i-2] = frameContents.get(i);
		}
		return bytes;
	}
	
	public void add(byte bite) {
		add(bite, false);
	}
	public void add(byte bite, boolean addNullAfterDLE) {
		frameContents.add(bite);
		if (addNullAfterDLE && bite == Controller.FRAME_DLE) {
			add (0x00, 1);
		}
	}
	public void add(char bite) {
		frameContents.add((byte)bite);
	}
	public void add(int integer, int byteLength) {
		//System.out.println("Adding " + integer + " as " + byteLength + " big endian bytes");
		byte bytes[] = ByteBuffer.allocate(4).order(ByteOrder.BIG_ENDIAN).putInt(integer).array(); 
		//System.out.println(Frame.byteArrayToHex(bytes, bytes.length) + " starting at " + (4-byteLength));
		for (int i = 4-byteLength; i <4; i++) {
			//System.out.println("Adding byte at position " + i + ": " + bytes[i]);
			add (bytes[i]);
		}
	}
	public void addLittleEndian(int integer, int byteLength) {
		//System.out.println("Adding " + integer + " as " + byteLength + " little endian bytes");
		byte bytes[] = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(integer).array(); 
		//System.out.println(Frame.byteArrayToHex(bytes, 4) + " starting at " + 0);
		for (int i = 0; i < byteLength; i++) {
			//System.out.println("Adding byte at position " + i + ": " + bytes[i]);
			add (bytes[i]);
		}
	}
	
	public Type getType() {
		if (frameContents.size() > 1) {
			int frameType = frameContents.get(0)<<8 &0xFF00 | frameContents.get(1)&0xFF;
			if (frameType == FRAME_TYPE_KEEP_ALIVE) {
				return Type.KeepAlive;
			}
			else if (frameType == FRAME_TYPE_DISPLAY_UPDATE) {
				return Type.Display;
			}
			else if (frameType == FRAME_TYPE_LONG_DISPLAY_UPDATE) {
				return Type.LongDisplay;
			}
			else if (frameType == FRAME_TYPE_LEDS) {
				return Type.LED;
			}
			else if (frameType == FRAME_TYPE_WIRELESS_KEY_EVENT) {
				return Type.WirelessKeyEvent;
			}
			else if (frameType == FRAME_TYPE_LEDS) {
				return Type.WiredKeyEvent;
			}
		}
		return Type.Unknown;
	}
	
	public boolean checkSumOK() {
		// Verify CRC
		int calculatedCRC = getCheckSum();
		int frameCRC = frameContents.get(frameContents.size() -2) <<8 & 0xFF00 | frameContents.get(frameContents.size() - 1) & 0xFF;
		
		if (calculatedCRC != frameCRC) {
			System.out.println("Bad CRC in frame: '" + this + "'");
			return false;
		}

		return true;
	}
	
	public int getCheckSum() {
		int calculatedCRC = Controller.FRAME_DLE + Controller.FRAME_STX;
		for (int i = 0; i < frameContents.size() - 2; i++) {
			calculatedCRC += frameContents.get(i) & 0xFF;
		}
		return calculatedCRC;
	}
	
	public static int getCheckSum(ArrayList<Byte> contents) {
		int calculatedCRC = 0;
		for (Byte bite: contents) {
			calculatedCRC += bite & 0xFF;
		}
		return calculatedCRC;
	}
	
	public void removeCheckSum() {
		if (frameContents.size() > 2) {
			frameContents.remove(frameContents.size()-1);
			frameContents.remove(frameContents.size()-1);
		}
	}
	
	public static String byteArrayToString(ArrayList<Byte> bytes) {
		StringBuilder sb = new StringBuilder(bytes.size() * 2);
		for (Byte b : bytes) {
			sb.append("" + b);
			sb.append(" ");
		}
		return sb.toString();
	}
	
	public static String byteArrayToHex(ArrayList<Byte> bytes) {
		StringBuilder sb = new StringBuilder(bytes.size() * 2);
		for (Byte b : bytes) {
			sb.append(String.format("%02x", b));
			sb.append(" ");
		}
		return sb.toString();
	}
	
	public static String byteArrayToHex(byte[] bytes) {
		return byteArrayToHex(bytes, bytes.length);
	}

	public static String byteArrayToHex(byte[] bytes, int length) {
		StringBuilder sb = new StringBuilder(bytes.length * 2);
		for (int i=0; i < length; i++) {
			Byte b = bytes[i];
			sb.append(String.format("%02x", b));
			sb.append(" ");
		}
		return sb.toString();
	}
	
	public String toString() {
		Type type = getType();
		if (type == Type.Display || type == Type.LongDisplay) {
			return type + ": '" + getDisplayText() + "'";
		}
		return type + ": " + byteArrayToHex(frameContents);
	}
	
	public String getDisplayText() {
		boolean lastByteWasNegative = false;
		StringBuffer text = new StringBuffer();
		for (int i = 0; i < frameContents.size() - 2; i++) {
			byte[] byteArray = new byte[1];
			byte frameByte = frameContents.get(i);
			if (frameByte == 0xba) {
				frameByte = 0x3A;
			}
			if (frameByte == 0xdf) {
				if (lastByteWasNegative) {
					text.append("</u>");
					lastByteWasNegative = false;
				}
				text.append(Controller.DEGREE_HTML);
			}
			else if (frameByte < 0) {
				if (!lastByteWasNegative) {
					text.append("<u>");
				}
				lastByteWasNegative = true;
				byteArray[0] = (byte) (frameByte & 0x7F);
				text.append(new String(byteArray, StandardCharsets.UTF_8));
			}
			else {
				if (lastByteWasNegative) {
					text.append("</u>");
				}
				lastByteWasNegative = false;

				byteArray[0] = frameByte;
				text.append(new String(byteArray, StandardCharsets.UTF_8));
			}
		}
		return text.toString();
	}
	
	/**
	 * Return byte contents put together as an integer
	 * @param start
	 * @param length
	 * @return
	 */
	public int getContentsAsInt(int start, int length) {
		if (frameContents.size() > start && start-length >= 0) {
			byte[] bytes = new byte[length];
			for (int i=start, j=0; i > start-length; i--, j++) {
				bytes[j] = frameContents.get(i);
			}
			//System.out.println("LEDs:" + byteArrayToHex(bytes, 4));
			return ByteBuffer.wrap(bytes).getInt();
		}
		return 0;
	}
}
