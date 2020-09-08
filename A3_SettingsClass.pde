class Settings { //5 KEYBOARD
	PApplet papplet;
	SocketAddress sockaddr;
	Table table; //FOR SOME REASON THE FILE IS ACTUALLY A TXT, BUT CSV FORMAT WORKS.

	String userInputIP = "";
	String inputIP = "";
	String inputID = "";
	String userInputID = "1";

	boolean ipFieldClicked, idFieldClicked = false;

	boolean ipConnected = false;
	boolean clickedOff = false;

	String[] consoleLog = {"----- " + name + " " + version + " -----", "",};

	boolean isReachable = true;
	boolean connectDelay, connectRun, connecting = false;

	int pingReturnTime;

	Settings(PApplet thePApplet) {
		settingsGet();
		papplet = thePApplet;
	}

	void draw() {
		backgroundDraw();
		console();
		ipFieldDraw();
		ipFieldText();
		idFieldDraw();
		idFieldText();
		about();
		connectLoopDelay();
		if (connecting) {
			connectTimeout();
		}
	}

	void startup() {
		connectLoopDelay();
		if (connecting) {
			connectTimeout();
		}
	}

	void backgroundDraw() {
		fill(EOSBackground);
		noStroke();
		rect(0, settingsBarHeight + settingsBarStrokeWeight, width, height);
	}


//----------------------------------------------SETTINGS GET / PUT----------------------------------------------

	void settingsGet() {
		try {
			table = loadTable("ShuttRData.csv", "header");
			TableRow row = table.getRow(0);
			userInputIP = row.getString("IP");
			userInputID = row.getString("ID");
			inputID = userInputID;
			if (userInputIP.length() >= 7) {
				consoleLog = append(consoleLog, "RESUMING LAST SESSION");
				inputIP = userInputIP;
				connectDelay = true;
				connectLoopDelay();
			}
		} catch (NullPointerException e) {
			table = new Table();
			table.addColumn("IP");
			table.addColumn("ID");
			TableRow newRow = table.addRow();
			newRow.setString("ID", "1");
			saveTable(table, "ShuttRData.csv");
		}
	}

	void settingsPut(boolean saveAll) {
		try {
			TableRow row = table.getRow(0);
			if (saveAll) {
				row.setString("IP", inputIP);
				row.setString("ID", inputID);
			} else {
				row.setString("IP", inputIP);
			}
			saveTable(table, "ShuttRData.csv");
		} catch (NullPointerException e) {
		}
	}

//----------------------------------------------IP FIELD----------------------------------------------

	void ipFieldDraw() {
		push();
		fill(black);
		if (ipFieldClicked) {
			stroke(EOSBlind);
		} else if (ipConnected) {
			stroke(EOSLive);
		} else if (!ipConnected) {
			stroke(EOSLightRed);
		}
		strokeWeight(buttonStrokeWeight);
		rectMode(CENTER);
		rect(centerX, row1Padding * 1.25, activeChannelWidth * 2, buttonHeight, buttonCorner);
		textSize(mediumTextSize);
		textAlign(CENTER, CENTER);
		fill(white);
		text("IP ADDRESS", centerX, row1Padding * 1.25 - buttonStrokeWeight - buttonHeight / 1.4);
		pop();
	}

	void ipFieldText() {
		push();
		fill(white);
		textAlign(CENTER, CENTER);
		textSize(largeTextSize);
		text(userInputIP, centerX, row1Padding * 1.25);
		pop();
	}

	void ipFieldButtonClicked() {
		if (mouseX > centerX - activeChannelWidth && mouseX < centerX + activeChannelWidth && mouseY > row1Padding * 1.25 - buttonHeight / 2 && mouseY < row1Padding * 1.25 + buttonHeight / 2) {
			ipFieldClicked = true;
			keyboard.open = true;
		}
	}

	void ipFieldKeyPressed() {
		if (keyboard.input == "CLEAR" || key == BACKSPACE || key == DELETE) {
			if (userInputIP.length() == 0) {
				return;
			} else {
				userInputIP = userInputIP.substring(0, userInputIP.length() - 1);
			}
		} else if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '.') {
			if (userInputIP.length() <= 15) {
				userInputIP += key;
			}
		} else if (keyboard.input == "0" || keyboard.input == "1" || keyboard.input == "2" || keyboard.input == "3" || keyboard.input == "4" || keyboard.input == "5" || keyboard.input == "6" || keyboard.input == "7" || keyboard.input == "8" || keyboard.input == "9" || keyboard.input == ".") {
			if (userInputIP.length() <= 15) {
				userInputIP += keyboard.input;
			}
		}
		if (keyboard.input == "ENTER" || key == ENTER || key == RETURN) {
			inputIP = userInputIP;
			if (inputIP.length() >= 7 && inputIP.length() <= 15) {
				consoleLog = append(consoleLog, "CONNECTING TO - " + inputIP);
				settingsPut(false);
				connectDelay = true;
			} else {
				ipConnected = false;
			}
		} else {
			return;
		}
	}

//----------------------------------------------USER FIELD----------------------------------------------

	void idFieldDraw() {
		push();
		fill(black);
		if (idFieldClicked) {
			stroke(EOSBlind);
		} else {
			stroke(EOSLive);
		}
		strokeWeight(buttonStrokeWeight);
		rectMode(CENTER);
		rect(centerX, (row2Padding * 1.25), genericButtonWidth, buttonHeight, buttonCorner);
		textSize(mediumTextSize);
		textAlign(CENTER, CENTER);
		fill(white);
		text("USER", centerX, (row2Padding * 1.25) - buttonStrokeWeight - buttonHeight / 1.4);
		pop();
	}

	void idFieldText() {
		push();
		fill(white);
		textAlign(CENTER, CENTER);
		textSize(largeTextSize);
		text(userInputID, centerX, (row2Padding * 1.25));
		pop();
	}

	void idFieldButtonClicked() {
		if (mouseX > centerX - genericButtonWidth / 2 && mouseX < centerX + genericButtonWidth / 2 && mouseY > (row2Padding * 1.25) - buttonHeight / 2 && mouseY < (row2Padding * 1.25) + buttonHeight / 2) {
			idFieldClicked = true;
			keyboard.open = true;
		}
	}

	void idFieldKeyPressed() {
		if (keyboard.input == "CLEAR" || key == BACKSPACE || key == DELETE) {
			if (userInputID.length() == 0) {
				return;
			} else {
				userInputID = userInputID.substring(0, userInputID.length() - 1);
			}
		} else if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9') {
			if (userInputID.length() <= 3) {
				userInputID += key;
			}
		} else if (keyboard.input == "0" || keyboard.input == "1" || keyboard.input == "2" || keyboard.input == "3" || keyboard.input == "4" || keyboard.input == "5" || keyboard.input == "6" || keyboard.input == "7" || keyboard.input == "8" || keyboard.input == "9") {
			if (userInputID.length() <= 15) {
				userInputID += keyboard.input;
			}
		}
		if ((keyboard.input == "ENTER" || key == ENTER || key == RETURN) && (userInputID.length() > 0)) {
			if (userInputID.equals("0")) {
				consoleLog = append(consoleLog,"USER ID CAN NOT BE 0");
				return;
			}
			if (userInputID.charAt(0) == '0') {
				userInputID = userInputID.substring(1,userInputID.length());
			}
			consoleLog = append(consoleLog,"USER ID SET TO: " + userInputID);
			inputID = userInputID;
			idFieldClicked = false;
			keyboard.open = false;
			settingsPut(true);
			handleOSC.userString = inputID;
		} else {
			return;
		}
	}

//----------------------------------------------CONSOLE----------------------------------------------

	void console() {
		push();
		rectMode(CENTER);
		fill(0);
		stroke(255);
		rect(guiCenterAlign, consolePadding, consoleWidth, consoleHeight);
		textAlign(LEFT, BOTTOM);
		textSize(smallTextSize);
		fill(255);
		text(consoleLog[consoleLog.length - 2], guiCenterAlign - consoleWidth / 2.1, (consolePadding + consoleHeight / 2.25) - mediumTextSize);
		text(consoleLog[consoleLog.length - 1], guiCenterAlign - consoleWidth / 2.1, (consolePadding + consoleHeight / 2.25));
		pop();
	}

//----------------------------------------------IP CONNECT----------------------------------------------

	void connectLoopDelay() { //This shit is dumb and I feel bad. If anyone ever sees this... I am ashamed of so much, but this especially.
		if (connectDelay) {
			if (connectRun) {
				connect();
				connectDelay = false;
				connectRun = false;
				return;
			}
			connectRun = true;
		}
	}

	void connectTimeout() {
		if ((millis() > pingReturnTime + 2000) && !ipConnected && isReachable) {
			consoleLog = append(consoleLog, "CONNECTED, BUT OSC NOT ENABLED");
			connecting = false;
		}
	}

	void connect() {
		println("Attempting To Connect!", inputIP);
		Socket socket = new Socket();
		isReachable = true;
		connecting = true;
		ipConnected = false;
		try {
			sockaddr = new InetSocketAddress(inputIP, 3032);
			socket.connect(sockaddr, 2000);
		} catch (SocketTimeoutException stex) {
			println("Socket Time Out", stex);
			consoleLog = append(consoleLog, "COULD NOT CONNECT - CONNECTION TIMED OUT");
			isReachable = false;
			ipConnected = false;
			return;
		} catch (IOException iOException) {
			println("Socket IO Exception", iOException);
			consoleLog = append(consoleLog, "COULD NOT CONNECT - UKNOWN HOST");
			isReachable = false;
			ipConnected = false;
			return;
		} finally {
			try {
				socket.close();
			} catch (IOException ex) {
				println("Socket Close Error", ex);
				isReachable = false;
				ipConnected = false;
				return;
			}
		}
		if (isReachable) {
			oscP5tcpClient.stop();
			oscP5tcpClient = new OscP5(papplet, inputIP, 3032, OscP5.TCP);
			handleOSC.sendPing();
			pingReturnTime = millis();
		} else if (!isReachable) {
			consoleLog = append(consoleLog, "COULD NOT CONNECT - CONNECTION REFUSED");
			return;
		}
		ipFieldClicked = false;
		keyboard.open = false;
	}


//----------------------------------------------ABOUT----------------------------------------------

	void about() {
		push();
		fill(white);
		textAlign(CENTER, BOTTOM);
		textSize(smallTextSize);
		text(name + " " + version + "\nMade by Ted Charles Brown \nTedCharlesBrown.com \n\nPlease email all questions / bugs / requests \nto TedCharlesBrown@gmail.com", centerX, height);
		pop();
	}
//----------------------------------------------EVENTS----------------------------------------------

	void keyPressed() {
		if (ipFieldClicked) {
			ipFieldKeyPressed();
		} else if (idFieldClicked) {
			idFieldKeyPressed();
		}
	}

	void mousePressed() {
		if ((ipFieldClicked || idFieldClicked) && (mouseX < keyboard.left || mouseX > keyboard.right || mouseY < keyboard.top || mouseY > keyboard.bot)) {
			keyboard.open = false;
			ipFieldClicked = false;
			idFieldClicked = false;
		} else if (gui.settingsMenu) {
			ipFieldButtonClicked();
			idFieldButtonClicked();
		}
	}
	void mouseReleased() {
		if (gui.settingsMenu) {

		}
	}
}
