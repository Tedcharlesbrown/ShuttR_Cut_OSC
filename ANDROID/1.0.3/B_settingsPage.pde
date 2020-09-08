//--------------------------------------------------------------
// B_settingsPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- SETTINGS - SETUP / UPDATE / DRAW -------
//--------------------------------------------------------------

void settingsSetup() {
	userInputIP = inputIP;
	userInputID = inputID;
	ipFieldButton.clicked = false; idFieldButton.clicked = false; //BUTTON INIT
}

//--------------------------------------------------------------

void settingsUpdate() {
	if (settingsMenu) {
		if (keyboard.clickedOff) {
			ipFieldButton.clicked = false; idFieldButton.clicked = false;
			keyboard.close(); keySwitch = 0;
		} else if (ipFieldButton.action && ipFieldButton.clicked) {
			ipFieldButton.clicked = true; idFieldButton.clicked = false;
			ipFieldButton.action = false;
			keyboard.open(); keySwitch = 1;
			keyboard.input = userInputIP;
		} else if (idFieldButton.action && idFieldButton.clicked) {
			ipFieldButton.clicked = false; idFieldButton.clicked = true;
			idFieldButton.action = false;
			keyboard.open(); keySwitch = 2;
			keyboard.input = userInputID;
		} else if (ipFieldButton.clicked || idFieldButton.clicked) {
			keyboard.open();
		} else {
			keyboard.close();
		}

		switch (keySwitch) {
		case 1:
			userInputIP = keyboard.input;
			if (keyboard.enter) {
				ipFieldButton.clicked = false; keyboard.close();
				inputIP = userInputIP;
				ipChanged = true;
				connect(false, false, true);
				keySwitch = 0;
			}
			break;
		case 2:
			userInputID = keyboard.input;
			if (keyboard.enter) {
				idFieldButton.clicked = false; keyboard.close();
				inputID = userInputID;
				consoleLog(log_UserSwitch + inputID);
				keySwitch = 0;
			}
			break;
		}

		if (ipChanged && keyboard.isOffScreen) {
			connect(true, true, false);
			ipChanged = false;
		}
	}
}

//--------------------------------------------------------------

void settingsDraw() {
	String IP = "IP ADDRESS";
	String ID = "USER";

	textAlign(CENTER, CENTER);	//PROCESSING
	fill(white);				//PROCESSING
	textFont(fontMedium); 		//PROCESSING

	ipFieldButton.show(userInputIP, centerX, row1Padding * 1.25, channelButtonWidth * 2, buttonHeight, "LARGE");
	text(IP, centerX, row1Padding * 1.25 - buttonHeight / 1.25); //INPUT

	idFieldButton.show(userInputID, guiCenterAlign, row2Padding * 1.25, genericButtonWidth, buttonHeight, "LARGE");
	text(ID, centerX, row2Padding * 1.25 - buttonHeight / 1.25); //INPUT

	console();

	about();
}

//--------------------------------------------------------------
// MARK: ---------- CONSOLE LOG ----------
//--------------------------------------------------------------

void consoleLog(String text) {
	console_log.set(3, console_log.get(2));
	console_log.set(2, console_log.get(1));
	console_log.set(1, console_log.get(0));
	console_log.set(0, text);

	if (console_log.size() > 4) {
		console_log.remove(4);
	}
}

void console() {
	push();
	rectMode(CENTER);

	stroke(white);
	fill(black);

	rect(guiCenterAlign, consolePadding, consoleWidth, consoleHeight, buttonCorner);

	pop();
	push();

	textAlign(LEFT, CENTER);	//PROCESSING
	fill(white);				//PROCESSING
	textFont(fontSmall); 		//PROCESSING

	translate(- consoleWidth / 2.1, consolePadding);

	text(console_log.get(console_log.size() - 1), guiCenterAlign, - consoleHeight / 3);
	text(console_log.get(console_log.size() - 2), guiCenterAlign, - consoleHeight / 9);
	text(console_log.get(console_log.size() - 3), guiCenterAlign, consoleHeight / 9);
	text(console_log.get(console_log.size() - 4), guiCenterAlign, consoleHeight / 3);
	pop();
}

//--------------------------------------------------------------
// MARK: ---------- ABOUT ----------
//--------------------------------------------------------------

void about() {
	String aboutOne = appName + " " + version;
	String thisIP = "Local IP Address: " + IPAddress;
	String aboutTwo =  "Made by Ted Charles Brown | TedCharlesBrown.com";
	String aboutThree = "Have suggestions? See a bug? Want to connect / buy me a coffee?";
	String aboutFour = "Email me at TedCharlesBrown+ShuttR@Gmail.com!";

	push();
	textAlign(CENTER, CENTER);	//PROCESSING
	fill(white);				//PROCESSING
	textFont(fontMedium); 		//PROCESSING

	text(aboutOne, centerX, height - smallTextSize * 6.75);
	text(thisIP, centerX, height - smallTextSize * 5.25);

	textFont(fontSmall); 		//PROCESSING
	text(aboutTwo, centerX, height - smallTextSize * 3.75);
	text(aboutThree, centerX, height - smallTextSize * 2.5);
	text(aboutFour, centerX, height - smallTextSize * 1.15);

	pop();
}
