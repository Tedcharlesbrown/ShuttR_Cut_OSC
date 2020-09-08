//--------------------------------------------------------------
// O_osc_in.mm
//--------------------------------------------------------------

void oscEvent(OscMessage m) {
	isConnected = true;
	hasOSC = true;
	if (console_log.get(0).indexOf(log_Connecting) != -1 || console_log.get(0).equals(log_CheckOSC)) { //ON GAINED CONNECTION
		consoleLog(log_YesConnect);
	} else if (console_log.get(0).equals(log_lostConnect)) {  //IF LOST CONNECTION
		consoleLog(log_reConnect + inputIP);
	}

	// ----------------------- GET CONNECTION STATUS -----------------------
	if (m.checkAddrPattern( "/eos/out/ping") && m.get(0).stringValue() == appName) {
		receivedPingTime = millis();
	} else {
		oscReceivedTime = millis();
	}
	// ----------------------- GET SHOW NAME -----------------------
	if (m.checkAddrPattern("/eos/out/show/name")) {

		headerName = m.get(0).stringValue();
		String headerAppend = "";
		int length = headerName.length();
		int maxLength = int(smallButtonWidth * 3.5);
		textFont(fontSmall);
		while (textWidth(headerName) > maxLength) {
			headerAppend = "...";
			headerName = headerName.substring(0, length);
			length--;
		}
		headerName = headerName + headerAppend;
	}


// ----------------------- GET ALL LIVE / BLIND STATUS -----------------------
	else if (m.checkAddrPattern("/eos/out/event/state")) {
		getState(m);
	}
// ----------------------- GET LIGHT COLOR ----------------------------
	else if (m.checkAddrPattern("/eos/out/color/hs") && m.checkTypetag("ff")) {
		getColor(m);
	}
// ----------------------- GET COMMAND LINE -----------------------
	else if (m.checkAddrPattern("/eos/out/user/" + inputID + "/cmd")) {
		getCommandLine(m);
	}
// ----------------------- GET ALL CHANNEL DATA -----------------------
	else if (m.checkAddrPattern("/eos/out/active/chan")) {
		getChannel(m);
	}
// ----------------------- GET PAN TILT DATA -----------------------
	else if (m.checkAddrPattern("/eos/out/pantilt")) {
		getPanTilt(m);
	}
// ----------------------- GET ALL WHEEL PARAMS -----------------------
	else if (m.toString().indexOf("/eos/out/active/wheel/") != -1) {
		getWheel(m);
	}
// ----------------------- GET DIRECT SELECTS -----------------------
	else if (m.toString().indexOf("/eos/out/ds/") != -1 && m.checkTypetag("ss")) {
		for (int i = 1; i <= 2; i++) {
			for (int j = 1; j <= 20; j++) {
				if (m.checkAddrPattern("/eos/out/ds/" + str(i) + "/" + str(j))) {
					getDirectSelect(i, j, m);
				}
			}
		}
	}

}

//--------------------------------------------------------------

void getState(OscMessage m) {
	switch (m.get(0).intValue()) {
	case 0: //BLIND
		isLive = false;
		break;
	case 1: //LIVE
	default:
		isLive = true;
		break;
	}
}

//--------------------------------------------------------------

void getColor(OscMessage m) {

	channelHue = m.get(0).floatValue();
	channelSat = m.get(1).floatValue();
	channelHue = map(channelHue, 0, 360, 0, 255);
	channelSat = map(channelSat, 0, 100, 0, 255);

	if (channelHue == 175.60394 && channelSat == 9.344364) {
		channelHue = 163.056;
		channelSat = 103.167;
	}

	push();
	colorMode(HSB, 255, 255, 255, 255);
	shutterColor = color(channelHue, channelSat, 255);
	pop();
}

//--------------------------------------------------------------

void getCommandLine(OscMessage m) {
	String incomingOSC = m.get(0).stringValue();

	if (incomingOSC.indexOf("Error:") != -1) {
		syntaxError = true;
	} else {
		syntaxError = false;
	}

	if (incomingOSC.indexOf("Highlight :") != -1) {
		highButton.clicked = true;
	} else {
		highButton.clicked = false;
	}

	if (incomingOSC.indexOf("Group") != -1 && incomingOSC.indexOf("#") != -1) {
		int indexValueStart = incomingOSC.indexOf("Group") + 6;
		incomingOSC = incomingOSC.substring(indexValueStart);

		int indexValueEnd = incomingOSC.indexOf(" ");

		incomingOSC = incomingOSC.substring(0, indexValueEnd);
		multiChannelPrefix = "Gr " + incomingOSC;

	} else if (incomingOSC.indexOf("Thru") != -1 && incomingOSC.indexOf("#") != -1) {
		int indexValueStart = incomingOSC.indexOf("Chan") + 5;
		incomingOSC = incomingOSC.substring(indexValueStart);

		int indexValueEnd = incomingOSC.indexOf(" Thru");
		String firstNumber = incomingOSC.substring(0, indexValueEnd);

		indexValueStart = incomingOSC.indexOf("Thru") + 5;

		incomingOSC = incomingOSC.substring(indexValueStart);
		indexValueEnd = incomingOSC.indexOf(" ");
		String secondNumber = incomingOSC.substring(0, indexValueEnd);

		multiChannelPrefix = firstNumber + "-" + secondNumber;

	} else if (incomingOSC.indexOf("#") != -1) {
		multiChannelPrefix = "";
	}
}

//--------------------------------------------------------------

void getChannel(OscMessage m) {
	String incomingOSC = m.get(0).stringValue();

	if (incomingOSC.length() > 0) {
		noneSelected = false;
		int oscLength = incomingOSC.length();
		int indexValueEnd = incomingOSC.indexOf(" ");
		incomingOSC = incomingOSC.substring(0, indexValueEnd);
		if (oscLength == 5 + incomingOSC.length()) { //IF NO CHANNEL IS PATCHED (OFFSET BY LENGTH OF CHANNEL NUMBER)
			selectedChannel = "(" + incomingOSC + ")";
			clearParams();
		} else {
			if (incomingOSC.indexOf("-") != -1 || incomingOSC.indexOf(",") != -1) {
				selectedChannel = multiChannelPrefix;
			} else if (multiChannelPrefix.length() > 0) {
				selectedChannel = multiChannelPrefix + " : " + incomingOSC;
			} else {
				selectedChannel = incomingOSC;
			}
		}
	} else { // IF NO CHANNEL IS SELECTED
		noneSelected = true;
		selectedChannel = "---";
		clearParams();
	}
}

//--------------------------------------------------------------

void getPanTilt(OscMessage m) {
	if (m.checkTypetag("ffffff")) {
		int panPercentInt = int(m.get(4).floatValue());
		int tiltPercentInt = int(m.get(5).floatValue());
		panPercent = str(panPercentInt) + " %";
		tiltPercent = str(tiltPercentInt) + " %";
	}
}

//--------------------------------------------------------------

void getIntensity(OscMessage m) {
	channelInt = int(getArgPercent(m, 0));
	intensityOverlay.incomingOSC(channelInt);

	channelInt255 = int(map(channelInt, 0, 100, 50, 255));

	push();
	colorMode(HSB, 255, 255, 255, 255);
	shutterColor = color(channelHue, channelSat, channelInt255);
	pop();

	channelIntString = getArgPercent(m, 0) + " %";
}

//--------------------------------------------------------------

void getWheel(OscMessage m) {
	try {
		for (int i = 0; i < 200; i++) {
			if (m.checkAddrPattern("/eos/out/active/wheel/" + str(i)) && argHasPercent(m, 0) && !ignoreOSC) {
				String incomingOSC = m.get(0).stringValue();

				float outputInt = float(getArgPercent(m, 0));
				float outputBinary = map(outputInt, 0, 100, 1, clickDiameter / assemblyRadius);

				if (incomingOSC.indexOf("Intens") != -1) { //INTENSITY
					getIntensity(m);
				} else if (incomingOSC.indexOf("Thrust A") != -1) { //Thrust A
					thrustA.buttonA.position = outputBinary;
				} else if (incomingOSC.indexOf("Angle A") != -1) { //Angle A
					angleA.rotateAngle = radians(-outputInt);
				} else if (incomingOSC.indexOf("Thrust B") != -1) { //Thrust B
					thrustB.buttonB.position = outputBinary;
				} else if (incomingOSC.indexOf("Angle B") != -1) { //Angle B
					angleB.rotateAngle = radians(-outputInt);
				} else if (incomingOSC.indexOf("Thrust C") != -1) { //Thrust C
					thrustC.buttonC.position = outputBinary;
				} else if (incomingOSC.indexOf("Angle C") != -1) { //Angle C
					angleC.rotateAngle = radians(-outputInt);
				} else if (incomingOSC.indexOf("Thrust D") != -1) { //Thrust D
					thrustD.buttonD.position = outputBinary;
				} else if (incomingOSC.indexOf("Angle D") != -1) { //Angle D
					angleD.rotateAngle = radians(-outputInt);
				} else if (incomingOSC.indexOf("Frame Assembly") != -1) { //Frame Assembly
					assembly.incomingOSC(outputInt);
				} else if (incomingOSC.indexOf("Iris") != -1) { //IRIS
					irisPercent = getArgPercent(m, 0) + " %";
				} else if (incomingOSC.indexOf("Edge") != -1) { //EDGE
					edgePercent = getArgPercent(m, 0) + " %";
				} else if (incomingOSC.indexOf("Zoom") != -1) { //ZOOM
					zoomPercent = getArgPercent(m, 0) + " %";
				} else if (incomingOSC.indexOf("Diffusn") != -1 || incomingOSC.indexOf("Diffusion") != -1) { //FROST
					frostPercent = getArgPercent(m, 0) + " %";
				}

//            else if (incomingOSC.find("Gobo Select") != string::npos) { //GOBO WHEEL 1
//                wheelSelect.at(0) = "Gobo Select 1";
//                wheelGobo.at(0) = m.getArgPercent(0);
//            } else if (incomingOSC.find("Gobo Ind/Spd") != string::npos) { //GOBO WHEEL 1
//                wheelPercent.at(0) = m.getArgPercent(0) + " %";
//            }
			}
		}
	} catch (Exception e) {

	}
}

//--------------------------------------------------------------

void getDirectSelect(int bank, int buttonID, OscMessage m) {
	try {
		String dNumber = "";

		if (argHasPercent(m, 0)) {
			dNumber = "(" + getArgPercent(m, 0) + ")";
		}

		String dName = m.get(0).stringValue();
		int indexValueEnd = dName.indexOf(" [");

		dName = dName.substring(0, indexValueEnd);

		if (bank == 1) {
			bankOne.bankText.set(buttonID - 1, dName);
			bankOne.bankNumber.set(buttonID - 1, dNumber);
		} else if (bank == 2) {
			bankTwo.bankText.set(buttonID - 1, dName);
			bankTwo.bankNumber.set(buttonID - 1, dNumber);
		}
	} catch (Exception e) {

	}
}

//--------------------------------------------------------------

void clearParams() {
	channelIntString = noParameter;
	push();
	colorMode(HSB, 255, 255, 255, 255);
	shutterColor = color(0, 0, 100);
	pop();

	irisPercent = noParameter;
	edgePercent = noParameter;
	zoomPercent = noParameter;
	frostPercent = noParameter;

	panPercent = noParameter;
	tiltPercent = noParameter;
}





//--------------------------------------------------------------
// INTERNAL TO eosTcpOsc Library
//--------------------------------------------------------------

boolean argHasPercent(OscMessage m, int index) {
	String incomingOSC = m.get(index).stringValue();
	if (incomingOSC.indexOf("[") != -1) {
		return true;
	} else {
		return false;
	}
}

String getArgPercent(OscMessage m, int index) {
	String incomingOSC = m.get(index).stringValue();
	int indexValueStart = incomingOSC.indexOf("[") + 1;
	int indexValueEnd = incomingOSC.indexOf("]");
	return incomingOSC.substring(indexValueStart, indexValueEnd);
}