OscP5 oscP5tcpServer, oscP5tcpClient;
OscMessage sendOSC = new OscMessage("");
OscMessage sendOSCPing = new OscMessage("/eos/ping");
OSCMessageHandle handleOSC = new OSCMessageHandle();

String OSCHome = "eos/param/shutter/home";

String[] listenTargets = {"Intens", "Thrust A", "Angle A", "Thrust B", "Angle B", "Thrust C", "Angle C", "Thrust D", "Angle D", "Frame Assembly", "Iris", "Edge", "Zoom", "Diffusn"};
String incomingOSC;

String OSCPrefix;
float OSCMessageValue;
String OSCMessageString;

//String userString = "1";
String channelString = "";
String channelInfo = "";
int channelInt;

int startTimeSend = 0;
int startTimeReceive = 0;
int currentTimeSend, endTimeSend, currentTimeReceive, endTimeReceive;
boolean runningSend = false;
boolean runningReceive = false;
boolean noneSelected = false;

//------------------------------------------------CLASS START----------------------------------------------

class OSCMessageHandle {
	boolean ignoreIncomingOSC = false;
	String userString = "1";
	OSCMessageHandle() {
	}


//----------------------------------------------SEND PING----------------------------------------------

	void sendPing() {
		oscP5tcpClient.send(sendOSCPing);
	}


//----------------------------------------------SEND WHEEL DATA----------------------------------------------

	void send(String ID, boolean thrust, float message) {
		oscPackageSend();
		sendOSC.clear();
		if (thrust) {
			switch (ID) {
			case "A":
				OSCPrefix = "/eos/user/" + userString + "/param/frame thrust a";
				break;
			case "B":
				OSCPrefix = "/eos/user/" + userString + "/param/frame thrust b";
				break;
			case "C":
				OSCPrefix = "/eos/user/" + userString + "/param/frame thrust c";
				break;
			case "D":
				OSCPrefix = "/eos/user/" + userString + "/param/frame thrust d";
				break;
			default:
				break;
			}
		} else {
			switch (ID) {
			case "A":
				OSCPrefix = "/eos/user/" + userString + "/param/frame angle a";
				break;
			case "B":
				OSCPrefix = "/eos/user/" + userString + "/param/frame angle b";
				break;
			case "C":
				OSCPrefix = "/eos/user/" + userString + "/param/frame angle c";
				break;
			case "D":
				OSCPrefix = "/eos/user/" + userString + "/param/frame angle d";
				break;
			case "FRAME":
				OSCPrefix = "/eos/user/" + userString + "/param/frame assembly";
				break;
			}
		}
		OSCMessageValue = message;

		sendOSC.setAddrPattern(OSCPrefix);
		sendOSC.add(OSCMessageValue);
		oscP5tcpClient.send(sendOSC);
	}

//----------------------------------------------SEND ENCODER DATA----------------------------------------------

	void sendEncoder(String ID, float message) {
		oscPackageSend();
		sendOSC.clear();
		if (ID != "") {
			OSCPrefix = "/eos/user/" + userString + "/wheel/" + ID;
		} else {
			return;
		}
		OSCMessageValue = message;
		sendOSC.setAddrPattern(OSCPrefix);
		sendOSC.add(OSCMessageValue);
		oscP5tcpClient.send(sendOSC);
	}

//----------------------------------------NEXT AND LAST THROUGH CHANNELS----------------------------------------------

	void sendChannel(String ID) {
		oscPackageSend();
		if (noneSelected) {
			sendOSC.clear();
			if (ID == "NEXT") {
				sendOSC.setAddrPattern("/eos/chan/" + str(channelInt + 1));
			} else if (ID == "LAST") {
				sendOSC.setAddrPattern("/eos/chan/" + str(channelInt - 1));
			}
			oscP5tcpClient.send(sendOSC);
			for (int i = 1; i >= 0; i--) {
				sendOSC.clear();
				sendOSC.setAddrPattern("eos/user/" + userString + "/key/enter");
				sendOSC.add(str(i));
				oscP5tcpClient.send(sendOSC);
			}
		} else if (!noneSelected) {
			if (ID == "NEXT") {
				OSCPrefix = "/eos/user" + userString + "/key/next";
			} else if (ID == "LAST") {
				OSCPrefix = "eos/user/" + userString + "/key/last";
			}
			for (int i = 1; i >= 0; i--) {
				sendOSC.clear();
				sendOSC.setAddrPattern(OSCPrefix);
				sendOSC.add(str(i));
				oscP5tcpClient.send(sendOSC);
			}
		}
	}

	void sendChannelNumber(String ID) {
		oscPackageSend();
		OSCPrefix = "/eos/user" + userString + "/cmd/" + ID + "#";
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern(OSCPrefix);
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
	}

	void sendEnter() {
		oscPackageSend();
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("eos/user/" + userString + "/key/enter");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
	}

//------------------------------------------------HIGHLIGHT MODE----------------------------------------------

	void sendHigh() {
		oscPackageSend();
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("eos/user/" + userString + "/key/enter");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("eos/user/" + userString + "/key/highlight");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("eos/user/" + userString + "/key/enter");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("/eos/user/" + userString + "/key/select_last");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("eos/user/" + userString + "/key/enter");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
	}

//--------------------------------------------------SEND FLASH----------------------------------------------

	void sendFlash(String ID) {
		boolean released = false;
		oscPackageSend();
		if (ID == "FLASH_OFF") {
			OSCPrefix = "eos/user/" + userString + "/key/flash_off";
		} else if (ID == "FLASH_ON") {
			OSCPrefix = "eos/user/" + userString + "/key/flash_on";
		} else if (ID == "OFF") {
			released = true;
		}
		sendOSC.clear();
		sendOSC.setAddrPattern(OSCPrefix);
		if (released) {
			sendOSC.add("0");
		} else {
			sendOSC.add("1");
		}
		oscP5tcpClient.send(sendOSC);
	}

//--------------------------------------------------SEND -% ----------------------------------------------

	void sendEncoderPercent(String ID, int message) {
		oscPackageSend();
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("eos/user/" + userString + "/key/enter");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
		for (int i = 1; i >= 0; i--) {
			sendOSC.clear();
			sendOSC.setAddrPattern("/eos/user/" + userString + "/key/select_last");
			sendOSC.add(str(i));
			oscP5tcpClient.send(sendOSC);
		}
		if (ID != "") {
			if (message < 0) {
				OSCPrefix = "eos/user/" + userString + "/param/" + ID + "/-%";
			} else if (message == 0) {
				OSCPrefix = "eos/user/" + userString + "/param/" + ID + "/home";
			} else if (message > 0) {
				OSCPrefix = "eos/user/" + userString + "/param/" + ID + "/+%";
			}
		} else {
			return;
		}
		sendOSC.clear();
		sendOSC.setAddrPattern(OSCPrefix);
		sendOSC.add("1");
		oscP5tcpClient.send(sendOSC);
	}

	void directSelectPage(String bank, String direction) { // DIRECT SELECT PAGE UP AND DOWN
		oscPackageSend();
		sendOSC.clear();
		sendOSC.setAddrPattern("eos/user/" + userString + "/ds/" + bank + "/page/" + direction);
		oscP5tcpClient.send(sendOSC);
	}

	void directSelectRequest(String bank, String ID, String select) { //REQUEST DIRECT SELECT
		oscPackageSend();
		sendOSC.clear();
		sendOSC.setAddrPattern("eos/user/" + userString + "/ds/" + bank + "/" + ID + "/1/" + select);
		oscP5tcpClient.send(sendOSC);
	}

	void sendDirectSelect(String bank, String ID) { // ACTIVATE DIRECT SELECT BANK AND NUMBER
		oscPackageSend();
		sendOSC.clear();
		sendOSC.setAddrPattern("eos/user/" + userString + "/ds/" + bank + "/" + ID);
		oscP5tcpClient.send(sendOSC);
	}

//------------------------------------------------ON OSC RECEIVE----------------------------------------------

	void oscEvent(OscMessage theOscMessage) {
		if (!ignoreIncomingOSC) {
			if (theOscMessage.checkAddrPattern("/eos/out/ping")) {
				settings.consoleLog = append(settings.consoleLog, "SUCCESFULLY CONNECTED!");
				settings.ipConnected = true;
			}
			for (int i = 0; i < 200; i++) { //Iterate through 200 possible wheels
				if (theOscMessage.checkAddrPattern("/eos/out/active/wheel/" + str(i)) == true) { //WHEEL
					if (theOscMessage.checkTypetag("si")) { //string + integer
						String value = theOscMessage.get(0).stringValue();
						parseWheel(value);
						return;
					}
				}
			}
			if (theOscMessage.checkAddrPattern("/eos/out/active/chan") == true) { //WORKS FOR CHANNEL
				if (theOscMessage.checkTypetag("s")) {
					String value = theOscMessage.get(0).stringValue();
					parseChannel(value);
					return;
				}
			}
			if (theOscMessage.checkAddrPattern("/eos/out/event/state") == true) { //LIVE (1) OR BLIND (0)
				int value = theOscMessage.get(0).intValue();
				if (value == 0) {
					liveBlindState = EOSBlind;
				} else if (value == 1) {
					liveBlindState = EOSLive;
				}
				return;
			}
			for (int i = 1; i <= 20; i++) {
				if (theOscMessage.checkAddrPattern("/eos/out/ds/1/" + str(i)) == true) { //DIRECT SELECT PAGE 1
					if (theOscMessage.checkTypetag("ss")) {
						String value = theOscMessage.get(0).stringValue();
						parseDirectSelect("1", i, value);
					}
				}
				if (theOscMessage.checkAddrPattern("/eos/out/ds/" + str(i) + "/" + str(i)) == true) { //DIRECT SELECT PAGE 1
					if (theOscMessage.checkTypetag("ss")) {
						String value = theOscMessage.get(0).stringValue();
						parseDirectSelect("1", i, value);
					}
				}
				if (theOscMessage.checkAddrPattern("/eos/out/ds/21/" + str(i)) == true) { //DIRECT SELECT PAGE 2
					if (theOscMessage.checkTypetag("ss")) {
						String value = theOscMessage.get(0).stringValue();
						parseDirectSelect("21", i, value);
					}
				}
				if (theOscMessage.checkAddrPattern("/eos/out/ds/" + str(i + 20) + "/" + str(i)) == true) { //DIRECT SELECT PAGE 2
					if (theOscMessage.checkTypetag("ss")) {
						String value = theOscMessage.get(0).stringValue();
						parseDirectSelect("21", i, value);
					}
				}
			}
		}
	}
//------------------------------------------------PARSE RECEIVED OSC----------------------------------------------
//------------------------------------------------MOVING LIGHT WHEELS----------------------------------------------

	void parseDirectSelect(String bank, int index, String incomingOSC) {
		oscPackageRecieve();
		String outputString = "";
		String outputNumber = "";
		int indexValueStart = incomingOSC.indexOf("[") - 1;
		int indexValueEnd = incomingOSC.indexOf("]");
		if (incomingOSC.length() > 2) {
			try {
				outputString = incomingOSC.substring(0, indexValueStart);
				outputNumber = incomingOSC.substring(indexValueStart + 2, indexValueEnd);
			} catch (StringIndexOutOfBoundsException ex) {
			}
		} else {
			outputString = incomingOSC;
			outputNumber = incomingOSC;
		}
		outputString = outputString.replace(" ", "\n");
		if (bank.equals("1")) {
			page3.bankOne.bankText[index - 1] = outputString ;
			page3.bankOne.bankNumber[index - 1] = outputNumber;
		} else if (bank.equals("21")) {
			page3.bankTwo.bankText[index - 1] = outputString ;
			page3.bankTwo.bankNumber[index - 1] = outputNumber;
		}
	}

	void parseWheel(String incomingOSC) {
		oscPackageRecieve();
		for (int i = 0; i < listenTargets.length; i++) { //iterate and listen for listenTargets
			String[] checkString = match(incomingOSC, listenTargets[i]);
			if (checkString != null) {
				int indexValueStart = incomingOSC.indexOf("[");
				int indexValueEnd = incomingOSC.indexOf("]");
				String outputString = incomingOSC.substring(indexValueStart + 1, indexValueEnd);
				//parseWheel(i, float(outputPercent));
				float outputFloat = float(outputString);
				switch (i) {
				case 0: //Intensity
					channelFlashIntensity = outputFloat;
					break;
				case 1: //Thrust A
					thrustA.thrustSliderA.incomingOSC(outputFloat);
					break;
				case 2: //Angle A
					angleA.incomingOSC(outputFloat);
					break;
				case 3: //Thrust B
					thrustB.thrustSliderB.incomingOSC(outputFloat);
					break;
				case 4: //Angle B
					angleB.incomingOSC(outputFloat);
					break;
				case 5: //Thrust C
					thrustC.thrustSliderC.incomingOSC(outputFloat);
					break;
				case 6: //Angle C
					angleC.incomingOSC(outputFloat);
					break;
				case 7: //Thrust D
					thrustD.thrustSliderD.incomingOSC(outputFloat);
					break;
				case 8: // Angle D
					angleD.incomingOSC(outputFloat);
					break;
				case 9: //Frame Assembly
					frameAssembly.incomingOSC(outputFloat);
					break;
				case 10: //Iris
					page2.irisPercent = outputString + " %";
					break;
				case 11: //Edge
					page2.edgePercent = outputString + " %";
					break;
				case 12: //Zoom
					page2.zoomPercent = outputString + " %";
					break;
				case 13: //Frost
					page2.frostPercent = outputString + " %";
					break;
				}
			}
		}
	}

//------------------------------------------------PARSE RECEIVED OSC----------------------------------------------
//-----------------------------------------------CHANNEL INFORMATION----------------------------------------------

	void parseChannel(String incomingOSC) {
		int indexValueStart = incomingOSC.indexOf(" ");
		int indexValueEnd = incomingOSC.indexOf("] ");
		if (indexValueStart == -1) {
			noneSelected = true;
			//println("----------NO CHANNEL SELECTED----------");
			//return;
		} else {
			noneSelected = false;
		}
		if (match(incomingOSC, "@") != null) {
			channelInfo = incomingOSC.substring(indexValueEnd + 2);
		} else {
			channelInfo = "[Not Patched]";
			channelString = "---";
			return;
		}
		channelString = trim(incomingOSC.substring(0, indexValueStart + 1));
		channelInt = int(channelString);
		//println("Ch", channelInt, channelInfo);
	}

//-----------------------------------------------OSC INDICATOR LIGHT----------------------------------------------

	void oscLightTimer() {
		currentTimeSend = round(millis() - startTimeSend);
		if (currentTimeSend >= endTimeSend) {
			runningSend = false;
			oscPackageSendLight = false;
		}
		currentTimeReceive = round(millis() - startTimeReceive);
		if (currentTimeReceive >= endTimeReceive) {
			runningReceive = false;
			oscPackageReceiveLight = false;
		}
	}

	void oscPackageSend() {
		currentTimeSend = 0;
		startTimeSend = round(millis());
		endTimeSend = currentTimeSend + 100;
		runningSend = true;
		oscPackageSendLight = true;
	}

	void oscPackageRecieve() {
		currentTimeReceive = 0;
		startTimeReceive = round(millis());
		endTimeReceive = currentTimeReceive + 100;
		runningReceive = true;
		oscPackageReceiveLight = true;
	}

//----------------------------------------------------RETURNS----------------------------------------------

	String channelNumberString() {
		return channelString;
	}

	int channelNumberInt() {
		return channelInt;
	}

	String channelInfoString() {
		return channelInfo;
	}
}