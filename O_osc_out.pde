//--------------------------------------------------------------
// O_osc_out.mm
//--------------------------------------------------------------

void oscEvent() {
	if (intensityOverlay.eventTrigger) {
		sendIntensity(intensityOverlay.sliderVector);
		intensityOverlay.eventTrigger = false;
	}
	sendFormEncoder();
	sendFocusEncoder();

	sendThrustA(); sendThrustB(); sendThrustC(); sendThrustD();
	sendAngleA(); sendAngleB(); sendAngleC(); sendAngleD();

	sendAssembly();

	parseDirectSelectSend();
	parseDirectSelectPage();
}

void sendIntensity(PVector oscOutput) {
	oscSentTime = millis();

	OscMessage m = new OscMessage("");
	if (oscOutput.x == 0) {
		m.setAddrPattern("/eos/user/" + inputID + "/param/intensity");
		m.add(oscOutput.y);
		eosSend(m);
	} else if (oscOutput.x < 4) {
		int switchCase = int(oscOutput.x);
		String address = "/eos/user/" + inputID + "/param/intensity/";
		switch (switchCase) {
		case 1: address += "full"; break;
		case 2: address += "level"; break;
		case 3: address += "out"; break;
		}
		m.setAddrPattern(address);
		eosSend(m);
	} else {
		sendKey("clear_cmdline");
		sendKey("select_last");
		if (oscOutput.x == 4) {
			sendKey("-%");
		} else if (oscOutput.x == 5) {
			sendKey("+%");
		} else {
			sendKey("intensity");
			if (oscOutput.x == 6) {
				sendKey("sneak");
			} else {
				sendKey("home");
			}
			sendKey("enter");
		}
	}
}

//--------------------------------------------------------------

void sendSneak(String parameter) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");

	sendKey("clear_cmdline");
	sendKey("select_last");
	sendKey(parameter);
	sendKey("sneak");
	sendKey("enter");
}

//--------------------------------------------------------------

void sendChannel(String parameter) {
	oscSentTime = millis();

	if (!noneSelected) { //IF A CHANNEL IS SELECTED
		sendKey("clear_cmdline");
		if (newFixture) { delay(250); }
		sendKey("select_last");
		sendKey(parameter);
		sendKey("enter");
	}
}

//--------------------------------------------------------------

void sendChannelNumber(String parameter) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");
	sendKey("clear_cmdline");
	if (newFixture) { delay(250); }
	m.setAddrPattern("/eos/user/" + inputID + "/cmd/" + parameter + "#");
	eosSend(m);
}

//--------------------------------------------------------------

void sendHigh() {
	oscSentTime = millis();

	sendKey("clear_cmdline");
	sendKey("highlight");
	sendKey("enter");
	sendKey("select_last");
	sendKey("enter");
}

//--------------------------------------------------------------

void sendFlash(String parameter) {
	oscSentTime = millis();

	OscMessage m = new OscMessage("");
	boolean released = false;
	String OSCPrefix = "";
	if (parameter == "FLASH_OFF") {
		OSCPrefix = "eos/user/" + inputID + "/key/flash_off";
	} else if (parameter == "FLASH_ON") {
		OSCPrefix = "eos/user/" + inputID + "/key/flash_on";
	} else if (parameter == "OFF") {
		OSCPrefix = "eos/user/" + inputID + "/key/flash_on";
		released = true;
	}
	m.setAddrPattern(OSCPrefix);
	if (released) {
		m.add("0");
	} else {
		m.add("1");
	}
	eosSend(m);
}

//--------------------------------------------------------------

void sendShutter(String parameter, String ID, float message) {
	oscSentTime = millis();
	ignoreOSC = true;

	OscMessage m = new OscMessage("");
	if (parameter == "THRUST") {
		m.setAddrPattern("/eos/user/" + inputID + "/param/frame thrust " + ID);
	} else if (parameter == "ANGLE") {
		m.setAddrPattern("/eos/user/" + inputID + "/param/frame angle " + ID);
	} else if (parameter == "ASSEMBLY") {
		m.setAddrPattern("/eos/user/" + inputID + "/param/frame assembly");
	}
	m.add(message);
	eosSend(m);
}

//--------------------------------------------------------------

void sendShutterHome(String parameter) {
	oscSentTime = millis();

	if (!noneSelected) { //IF A CHANNEL IS SELECTED
		OscMessage a = new OscMessage("");
		OscMessage b = new OscMessage("");
		OscMessage c = new OscMessage("");
		OscMessage d = new OscMessage("");
		if (parameter == "THRUST") {
			a.setAddrPattern("/eos/user/" + inputID + "/param/frame thrust a/home");
			b.setAddrPattern("/eos/user/" + inputID + "/param/frame thrust b/home");
			c.setAddrPattern("/eos/user/" + inputID + "/param/frame thrust c/home");
			d.setAddrPattern("/eos/user/" + inputID + "/param/frame thrust d/home");
			eosSend(a); eosSend(b); eosSend(c); eosSend(d);
		} else if (parameter == "ANGLE") {
			a.setAddrPattern("/eos/user/" + inputID + "/param/frame angle a/home");
			b.setAddrPattern("/eos/user/" + inputID + "/param/frame angle b/home");
			c.setAddrPattern("/eos/user/" + inputID + "/param/frame angle c/home");
			d.setAddrPattern("/eos/user/" + inputID + "/param/frame angle d/home");
			eosSend(a); eosSend(b); eosSend(c); eosSend(d);
		} else if (parameter == "SHUTTER") {
			a.setAddrPattern("/eos/user/" + inputID + "/param/shutter/home");
			eosSend(a);
		}
		sendKey("select_last");
		sendKey("enter");
	}
}

//--------------------------------------------------------------

void fineEncoder(int message) { //ONLY USED TO RESET OSC TICKS, ONLY CALLED IN CONNECT();
	oscSentTime = millis();

	OscMessage m = new OscMessage("");
	m.setAddrPattern("/eos/user/" + inputID + "/wheel");
	m.add(message);
	eosSend(m);
}

//--------------------------------------------------------------

void sendEncoder(String parameter, float message) {
	if (isPaidVersion) {
		oscSentTime = millis();

		OscMessage m = new OscMessage("");
		m.setAddrPattern("/eos/user/" + inputID + "/wheel/" + parameter);
		m.add(message);
		eosSend(m);
	}
}

//--------------------------------------------------------------

void sendEncoderPercent(String parameter, int message) {
	if (isPaidVersion) {
		oscSentTime = millis();

		OscMessage m = new OscMessage("");
		sendKey("enter");
		sendKey("select_last");
		m.clear();
		switch (message) {
		case -1:
			m.setAddrPattern("/eos/user/" + inputID + "/param/" + parameter + "/-%");
			break;
		case 0:
			m.setAddrPattern("/eos/user/" + inputID + "/param/" + parameter + "/home");
			break;
		case 1:
			m.setAddrPattern("/eos/user/" + inputID + "/param/" + parameter + "/+%");
			break;
		}
		eosSend(m);
	}
}

//--------------------------------------------------------------

void sendImage(String _parameter, String message, boolean index) {
    
    if (isPaidVersion) {
        if (!selectedChannel.equals("---") && selectedChannel.indexOf("(") == -1) {
            String parameter = _parameter;
            oscSentTime = millis();
            
            OscMessage m = new OscMessage("");
            m.clear();
            parameter = selectedChannel + "/" + parameter;
            if (index) {
                if (message == "0") {
                    m.setAddrPattern("/eos/user/" + inputID + "/cmd/Chan/" + parameter + "/home/#");
                } else {
                    m.setAddrPattern("/eos/user/" + inputID + "/cmd/Chan/" + parameter + "/" + message + "/#");
                }
            } else {
                if (message == "0") {
                    m.setAddrPattern("/eos/user/" + inputID + "/cmd/Chan/" + parameter + "/home/#");
                } else {
                    m.setAddrPattern("/eos/user/" + inputID + "/cmd/Chan/" + parameter + "/" + message + "/#");
                }
        }
        eosSend(m);
        }
    }
}

//--------------------------------------------------------------

void sendDSPage(String bank, String direction) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");
	m.setAddrPattern("eos/user/" + inputID + "/ds/" + str(int(bank)) + "/page/" + str(int(direction)));
	eosSend(m);
}
void sendDSRequest(String bank, String parameter) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");
	m.setAddrPattern("eos/user/" + inputID + "/ds/" + str(int(bank)) + "/" + parameter + "/1/20");
	eosSend(m);
}
void sendDS(String bank, String buttonID) {
	if (isPaidVersion) {
		oscSentTime = millis();
		OscMessage m = new OscMessage("");
		m.setAddrPattern("eos/user/" + inputID + "/ds/" + str(int(bank)) + "/" + str(int(buttonID)));
		eosSend(m);
	}
}


//--------------------------------------------------------------

void sendPing() {
//    oscSentTime = ofGetElapsedTimeMillis();
	sentPingTime = millis();

	OscMessage m = new OscMessage("");
	m.setAddrPattern("/eos/ping");
	m.add(appName);

	eosSend(m);
}

//--------------------------------------------------------------

void sendKey(String key) {
	OscMessage m = new OscMessage("");
	for (int i = 1; i >= 0; i--) {
		m.clear();
		m.setAddrPattern("eos/user/" + inputID + "/key/" + key);
		m.add(str(i));
		eosSend(m);
	}
}

void sendKey(String key, boolean toggle) {
	OscMessage m = new OscMessage("");
	m.setAddrPattern("eos/user/" + inputID + "/key/" + key);
	if (toggle) {
		m.add("1");
	} else {
		m.add("0");
	}
	eosSend(m);
}

//------------------PROCESSING ONLY-----------------------

void eosSend(OscMessage m) {
	try {
		eos.send(m);
	} catch (Exception e) {

	}
}
