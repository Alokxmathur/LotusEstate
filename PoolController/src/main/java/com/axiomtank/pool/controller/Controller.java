package com.axiomtank.pool.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.commons.lang3.StringUtils;

@WebListener
public class Controller extends Thread implements ServletContextListener {
	public static final short FRAME_DLE = 0x10;
	public static final short FRAME_STX = 0x02;
	public static final short FRAME_ETX = 0x03;
	
	public static final String DEGREE_HTML = "&deg;";

	int READ_TIMEOUT = 2000, CONNECT_TIMEOUT = 2000;

	Socket socket = new Socket();
	InputStream inputStream;
	OutputStream outputStream;
	String host;
	int port;
	boolean isMetric, filterIsO;
	int airTemp, spaTemp, poolTemp, saltLevel;

	byte[] byteBuffer = new byte[4096];
	int bytePointer = 0;
	int bytesRead = -1;

	boolean keepRunning = true;
	Object synchronizer = new Object();
	static Object classSynchronizer = new Object();
	Object requestSynchronizer = new Object();

	ControllerState controllerState = new ControllerState();
	
	int consecutiveKeepAliveCount = 0;

	public ControllerState.Mode getMode() {
		return getControllerState().getMode();
	}

	ArrayList<Request> requests = new ArrayList<>();
	
	private static Controller controller = null;
	
	public static Controller getController() {
		synchronized(classSynchronizer) {
			if (controller == null) {
				controller = new Controller("10.5.5.165", 8000);
				controller.start();
			}
			return controller;
		}
	}
	
	public Controller() {
		Controller.getController();
	}

	public Controller(String host, int port) {
		isMetric = false;
		this.host = host;
		this.port = port;
	}

	public static void main(String args[]) throws IOException {
		Controller controller = Controller.getController();
 
		Scanner scanner = new Scanner(System.in);
        // Reading data using readLine
        String input;
		while (true) {
			input = scanner.nextLine();
			if (input.equalsIgnoreCase("stop")) {
				controller.stopRunning();
				break;
			}
			else {
				controller.addRequest(input);
			}
			
		}
		scanner.close();
	}
	
	public void addRequest(String input) {
		for (Request.Type type: Request.Type.values()) {
			if (input.equals(type.toString())) {
				addRequest(type);
			}
		}
	}
	
	public void addRequest(Request.Type type) {		
		synchronized(requestSynchronizer) {
			//prepend actual requests before the compound hot tub request
			if (type == Request.Type.HotTubOn) {
				this.addRequest(Request.Type.PoolMode); //issued to reset spa countdown
				this.addRequest(Request.Type.SpaMode);
				this.addRequest(Request.Type.HeaterOn);
				this.addRequest(Request.Type.FilterOn);
			}
			else if (type == Request.Type.HotTubOff) {
				this.addRequest(Request.Type.HeaterOff);
				this.addRequest(Request.Type.FilterOff);
				this.addRequest(Request.Type.SpaLightOff);
				this.addRequest(Request.Type.JetsOff);
			}
			this.requests.add(new Request(type));
			System.out.println("Added " + type.toString() + " request");
		}
	}

	public ControllerState getControllerState() {
		synchronized (synchronizer) {
			return controllerState;
		}
	}

	private void connect() throws IOException {
		//System.out.println("Connecting to " + host + ":" + port);
		socket = new Socket();
		socket.connect(new InetSocketAddress(host, port), CONNECT_TIMEOUT);
		socket.setSoTimeout(READ_TIMEOUT);
		inputStream = socket.getInputStream();
		outputStream = socket.getOutputStream();
	}

	private byte readByte() throws IOException {
		if (bytesRead == 0 || bytePointer > bytesRead - 1) {
			bytesRead = inputStream.read(byteBuffer);
			bytePointer = 0;
		}
		return byteBuffer[bytePointer++];
	}
	
	private boolean keepRunning() {
		synchronized(synchronizer) {
			return keepRunning;
		}
	}
	private void stopRunning() {
		synchronized(synchronizer) {
			keepRunning = false;
		}
	}

	public void run() {
		System.out.println("Process thread started");
		String lastState = "";
		while (keepRunning()) {
			try {
				if (!socket.isConnected()) {
					this.connect();
				}
				else {
					Frame frame = this.getFrame();
					if (frame != null) {
						this.processState(frame);
						String newState = this.getControllerState().toJSON().toString();
						if (!newState.equals(lastState)) {
							System.out.println(new Date().toString() + ": " + newState);
							lastState = newState;
						}						
					}
				}
			} catch (Throwable e) {
				try {
					if (socket != null) {
						socket.close();
					}
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				e.printStackTrace();
				System.out.println("Error: " + e.getLocalizedMessage());
			}
			try {
				Thread.yield();
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}
		System.out.println("Process thread stopped");
	}
	
	private void handlePendingRequests() {
		//we check if there are requests pending to be sent
		synchronized(requestSynchronizer) {
			if (this.requests.size() > 0) {
				Request request = this.requests.get(0);
				if (request.isComplete(this.getControllerState())) {
					System.out.println("Completed " + request.getType() + " in " + ((int) (request.getElapsedSinceFirstIssue()/1000) + 1) + " seconds");
					this.requests.remove(0);
				}
				else if (request.getIssueCount() >= 500) {
					this.requests.remove(0);
					System.out.println("Gave up on " + request.getType() + " after 500 attempts");
				}
				//issue request if it was not issued or we have already checked status after is was issued
				else if (!request.wasIssued() || request.statusChecked()) {
					issueRequest(request);
				}
			}
		}
	}
	
	/**
	 * Issue a request to the controller by sending a frame that might get us to the state we desire
	 * @param request
	 */
	
	public void issueRequest(Request request) {		
		request.setupForIssuance();
		if (request.getType() == Request.Type.HotTubOn
				|| request.getType() == Request.Type.HotTubOff) {
			//we do nothing if the request type is hotub on or off
			//these should have been handled by preceding requests that should have been queued 
			return;
		}
		try {
			for (Frame frame: request.getFrames()) {
				outputStream.write(frame.getBytes());
				outputStream.flush();
				System.out.println(new Date().toString() + " " + request.getType() 
					+ " issued. Count = " + request.getIssueCount()
					+ ", sending: " + Frame.byteArrayToHex(frame.getBytes()));
				
			}

		}
		catch (Throwable e) {
			e.printStackTrace();
			try {
				socket.close();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}

	}
	
	public ArrayList<Request> getPendingRequests() {
		synchronized(requestSynchronizer) {
			return this.requests;
		}
	}
	

	/**
	 * Read and return a frame from the controller
	 * 
	 * 
	 * 
	 */

	private Frame getFrame() {
		// Data framing (from the AQ-CO-SERIAL manual):
		//
		// Each frame begins with a DLE (10H) and STX (02H) character start
		// sequence, followed by a 2 to 61 byte long Command/Data field, a
		// 2-byte Checksum and a DLE (10H) and ETX (03H) character end
		// sequence.
		//
		// The DLE, STX and Command/Data fields are added together to
		// provide the 2-byte Checksum. If any of the bytes of the
		// Command/Data Field or Checksum are equal to the DLE character
		// (10H), a NULL character (00H) is inserted into the transmitted
		// data stream immediately after that byte. That NULL character
		// must then be removed by the receiver.
		ArrayList<Byte> discards = new ArrayList<>();

		try {
			byte bite;
			while (true) {
				byte readByte = readByte();
				// Search for FRAME_DLE + FRAME_STX
				if (readByte == FRAME_DLE) {
					readByte = readByte();
					if (readByte == FRAME_STX) {
						break;
					}
					else {
						System.out.println("No STX after DLE, found: " + String.format("%02x", readByte));
					}
				}
				else {
					discards.add(readByte);
				}
			}

			Frame frame = new Frame();
			while (true) {
				// gather the frame
				if ((bite = readByte()) == FRAME_DLE) {
					// Should be FRAME_ETX or 0 according to
					// the AQ-CO-SERIAL manual
					Byte nextByte = readByte();
					if (nextByte == FRAME_ETX) {
						break;
					} else if (nextByte != 0x00) {
						System.out.println("Did not receive null byte after DLE, read: " + String.format("%02x", nextByte) + ", frame=" + frame);
						throw new IOException("Did not receive null byte after DLE, read: " + nextByte);
					}
				}
				// add byte to the frame
				frame.add(bite);
			}
			if (!frame.checkSumOK()) {
				return null;
			}
			frame.removeCheckSum();
			
			if (discards.size() > 0) {
				System.out.println("Discarded: " + Frame.byteArrayToHex(discards));
				System.out.println("Discarded: " + Frame.byteArrayToString(discards));
			}
			//System.out.println("Received " + frame.getType() + " frame. ");

			return frame;

		} catch (Throwable e) {
			try {
				connect();
			}
			catch (Throwable e1) {
			}
			return null;
		}
	}

	/**
	 * Set state of controller based on passed bits
	 * 
	 * @param frame
	 * 
	 *              We currently do not handle flashing LEDs
	 */

	public void processState(Frame frame) {
		synchronized (synchronizer) {
			switch (frame.getType()) {
				case KeepAlive: {
					if (consecutiveKeepAliveCount++ %5 == 1) {
						handlePendingRequests();
					}
					break;
				}
				case LED: {	
					consecutiveKeepAliveCount = 0;
					int reportedcontrollerState = frame.getContentsAsInt(5, 4);
					if ((reportedcontrollerState & ControllerStates.POOL) != 0) {
						controllerState.setMode(ControllerState.Mode.Pool);
					}
					if ((reportedcontrollerState & ControllerStates.SPA) != 0) {
						controllerState.setMode(ControllerState.Mode.Spa);
					}
					if ((reportedcontrollerState & ControllerStates.SPILLOVER) != 0) {
						controllerState.setMode(ControllerState.Mode.Spillover);
					}
					controllerState.setFilterOn((reportedcontrollerState & ControllerStates.FILTER) != 0);
					controllerState.setCleanerOn((reportedcontrollerState & ControllerStates.CLEANER) != 0);
					controllerState.setSpaLightOn((reportedcontrollerState & ControllerStates.SPA_LIGHT) != 0);
					controllerState.setPoolLightsOn((reportedcontrollerState & ControllerStates.LIGHTS) != 0);
					controllerState.setJetsOn((reportedcontrollerState & ControllerStates.JETS) != 0);
					
					controllerState.setLedBasedUpdateTime();
					//System.out.println("State after LED: " + controllerState.toString());
					break;
				}
				case Display: {
					consecutiveKeepAliveCount = 0;
					String unporocessedReceivedText = frame.getDisplayText();
					String receivedText = unporocessedReceivedText.trim();
							
					//System.out.println("Unprocessed: '" + unporocessedReceivedText + "'");
					//System.out.println("Processed: '" + receivedText + "'");
					//System.out.println(frame.getType() + ": " + Frame.byteArrayToHex(frame.getContentBytes()));
					if (controllerState.getMenu() == ControllerState.Menu.Default) {
						if (StringUtils.startsWith(receivedText, "Air Temp")) {
							String temp = StringUtils.substringBetween(receivedText, "Air Temp", "_F").trim();
							controllerState.setAirTemp(temp);
						} else if (StringUtils.startsWith(receivedText, "Pool Temp")) {
							String temp = StringUtils.substringBetween(receivedText, "Pool Temp", "_F").trim();
							controllerState.setPoolTemp(temp);
							if (controllerState.isFilterOn()) {
								if (controllerState.getMode() == ControllerState.Mode.Pool || controllerState.getMode() == ControllerState.Mode.Spillover) {
									controllerState.setSpaTemp(controllerState.getPoolTemp());
								}
							}
						} else if (StringUtils.startsWith(receivedText, "Spa Temp")) {
							String temp = StringUtils.substringBetween(receivedText, "Spa Temp", "_F").trim();
							controllerState.setSpaTemp(temp);
						} else if (StringUtils.startsWith(receivedText, "Spa-CountDn")) {
							String spaCountDown = StringUtils.substringBetween(receivedText, "Spa-CountDn", "remaining").trim();
							controllerState.setSpaCountDown(spaCountDown);
						} else if (StringUtils.startsWith(receivedText, "Salt Level")) {
							String saltLevel = StringUtils.substringBetween(receivedText, "Salt Level", " PPM").trim();
							controllerState.setSaltLevel(saltLevel);
						} else if (StringUtils.startsWith(receivedText, "Heater1")) {
							String heaterMode = StringUtils.substringAfter(receivedText, "Heater1").trim();
							controllerState.setHeaterOn(heaterMode.equals("Auto Control"));
						} else if (StringUtils.startsWith(receivedText, "Pool Chlorinator")) {
							String poolChlorinatorPercent = StringUtils.substringBetween(receivedText, "Pool Chlorinator", "%")
									.trim();
							controllerState.setPoolChlorinator(poolChlorinatorPercent);
						} else if(StringUtils.startsWith(receivedText, "Spa Chlorinator")) {
							String spaChlorinatorPercent = StringUtils.substringBetween(receivedText, "Spa Chlorinator", "%")
									.trim();
							controllerState.setSpaChlorinator(spaChlorinatorPercent);
						} else if (StringUtils.startsWith(receivedText, "Check System")) {
							String checkSystem = StringUtils.substringAfter(receivedText, "Check System").trim();
							controllerState.setCheckSystem(checkSystem);
						}
					}
					else {
					}
					controllerState.setDisplayBasedUpdateTime();

					controllerState.setControllerMessage(receivedText);
					if (receivedText.indexOf("Menu") >=0) {
						String menuReceived = StringUtils.substringBefore(receivedText, "Menu").trim();
						controllerState.setMenu(menuReceived);
						System.out.println("Menu=" + receivedText);
					}
					
					//System.out.println("Processed Display update");
					break;
				}
				default: {
					//System.out.println("'" + frame.getDisplayText() + "'");
					//System.out.println(frame.getType() + ": " + Frame.byteArrayToHex(frame.getContentBytes()));
				}
			}
			controllerState.setPendingRequests(getPendingRequests());
		}
	}

	public void contextInitialized(ServletContextEvent event) {
    }

    public void contextDestroyed(ServletContextEvent event) {
        stopRunning();
    }
    /*
     * 10 02 00 83 01 00 00 04 00 00 00 04 00 00 00 9e 10 03 
     * 10 02 00 83 01 00 00 04 00 00 00 04 00 00 00 9e 10 03
     */
}