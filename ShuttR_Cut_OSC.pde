//--------------------------------------------------------------
// A_ofApp.h || A_ofApp.mm
//--------------------------------------------------------------

import netP5.*;							//OSC
import oscP5.*;							//OSC
import java.net.*;

import ketai.net.*;

import java.net.InetAddress; 			//IP ADDRESS
import java.net.UnknownHostException; 	//IP ADDRESS

boolean settingsMenu;

//--------------------------------------------------------------
// MARK: ----------GUI----------
//--------------------------------------------------------------

void setup() {
	orientation(PORTRAIT);
	fullScreen(); //PIXEL DIMENSIONS = 1440 x 2960
	// size(480, 986); //2

	getNotchHeight();
	IPAddress = getIPAddress();
	styleInit();
	javaClassInit();
	getXML();

	try {
		if (inputIP.length() > 0) {
			connect(true, true, true);
		}
	} catch (Exception e) {

	}

	shutterPage.clicked = true;

	shutterPageSetup();
	focusPageSetup();
	formPageSetup();
	imagePageSetup();
	DSPageSetup();
	settingsSetup();
	intensityOverlay.setup();
}

void update() {
	oscEvent(); //Java version = Send events
	stateUpdate();

	keyboard.update();
	intensityOverlay.update();

	intensityButtonAction();
	channelButtonAction();

	topBarUpdate();
	pageButtonAction();
	oscLightUpdate();
	buttonAction();
	settingsUpdate();

	heartBeat();

}

//--------------------------------------------------------------
// MARK: ---------- PAGE BUTTONS ----------
//--------------------------------------------------------------

void pageButtonAction() {
	if (shutterPage.clicked && !settingsMenu) {
		shutterPageUpdate();
	} else if (focusPage.clicked && !settingsMenu) {
		focusPageUpdate();
	} else if (formPage.clicked && !settingsMenu) {
		formPageUpdate();
	} else if (imagePage.clicked && !settingsMenu) {
		imagePageUpdate();
	} else if (dSelectPage.clicked && !settingsMenu) {
		DSPageUpdate();
	}
}

//--------------------------------------------------------------
// MARK: ---------- GUI BUTTON ACTIONS ----------
//--------------------------------------------------------------

void buttonAction() {
	if (minusButton.action) {
		sendChannel("last");
		minusButton.action = false;
	}
	if (plusButton.action) {
		sendChannel("next");
		plusButton.action = false;
	}
	if (highButton.action) {
		sendHigh();
		highButton.action = false;
	}
	if (flashButton.action) {
		if (channelInt >= 50) {
			sendFlash("FLASH_OFF");
		} else {
			sendFlash("FLASH_ON");
		}
		flashButton.action = false;

	}
	if (flashButton.released) {
		sendFlash("OFF");
		flashButton.released = false;
	}
}

//--------------------------------------------------------------
// MARK: ---------- CHANNEL BUTTON ----------
//--------------------------------------------------------------

void channelButtonAction() {
	if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked || dSelectPage.clicked) && !settingsMenu) {
		if (keyboard.clickedOff) {
			selectedChannel = oldChannel;
			channelButton.clicked = false;
			keyboard.close();
		} else if (channelButton.action && channelButton.clicked) {
			if (syntaxError) {
				sendKey("clear_cmdline");
			}
			oldChannel = selectedChannel;
			keyboard.input = "";
			channelButton.action = false;
			keyboard.open();
		}
		if (channelButton.clicked) {
			selectedChannel = keyboard.input;
		}
		if (keyboard.enter) {
			channelButton.clicked = false;
			keyboard.close();
			if (selectedChannel == "") {
				selectedChannel = oldChannel;
			} else {
				noneSelected = false;
				sendChannelNumber(selectedChannel);
			}
		}
	}
}

//--------------------------------------------------------------
// MARK: ---------- INTENSITY BUTTON ----------
//--------------------------------------------------------------

void intensityButtonAction() {
	if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked || dSelectPage.clicked) && !settingsMenu) {
		if (intensityOverlay.clickedOff || plusButton.action || minusButton.action || channelButton.action) {
			intensityButton.clicked = false;
			intensityOverlay.close();
		} else if (intensityButton.action && intensityButton.clicked) {
			intensityButton.action = false;
			intensityOverlay.open();
		}
	}
}

//--------------------------------------------------------------
// MARK: ---------- OSC LIGHT ----------
//--------------------------------------------------------------

void oscLightUpdate() {
	if (millis() > oscSentTime + 200) {
		oscSendLight = false;
		ignoreOSC = false;
	} else {
		oscSendLight = true;
	}
	if (millis() > oscReceivedTime + 200) {
		oscReceiveLight = false;
	} else {
		oscReceiveLight = true;
	}
}


//--------------------------------------------------------------
// MARK: ---------- DRAW ----------
//--------------------------------------------------------------

void draw() {
	update(); //KEEP UPDATE FIRST
	//---------------------------
	background(EOSBackground);
	if (millis() < splashScreen) { //SPLASH SCREEN
		push();
		imageMode(CENTER);
		image(splashImg, width / 2, height / 4, width / 1.5, width / 1.5);
		about();
		pop();
	} else {
		push();
		if (shutterPage.clicked && !settingsMenu && !intensityOverlay.show) {
			shutterPageDraw();
		}
		if (focusPage.clicked && !settingsMenu && !intensityOverlay.show) {
			focusPageDraw();
		}
		if (formPage.clicked && !settingsMenu && !intensityOverlay.show) {
			formPageDraw();
		}
		if (imagePage.clicked && !settingsMenu && !intensityOverlay.show) {
			imagePageDraw();
		}
		if (dSelectPage.clicked && !settingsMenu && !intensityOverlay.show) {
			DSPageDraw();
		}
		if (settingsMenu) {
			settingsDraw();
		}

		if ((shutterPage.clicked || formPage.clicked || focusPage.clicked || imagePage.clicked) && !settingsMenu) {
			String channel = "SELECTED CHANNEL";
			if (!noneSelected && selectedChannel.indexOf("(") == -1) {
				channel = currentFixture;
			} else {
				channel = "(CHANNEL NOT PATCHED)";
			}
			minusButton.show("-", guiLeftAlign, row1Padding + buttonHeight / 2, smallButtonWidth, buttonHeight, "LARGE");
			plusButton.show("+", guiRightAlign, row1Padding + buttonHeight / 2, smallButtonWidth, buttonHeight, "LARGE");
			fineButton.show("FINE", guiLeftAlign, row2Padding, genericButtonWidth, buttonHeight, "LARGE");
			highButton.show("HIGH", guiCenterAlign, row2Padding, genericButtonWidth, buttonHeight, "LARGE");
			flashButton.show("FLASH", guiRightAlign, row2Padding, genericButtonWidth, buttonHeight, "LARGE");

			intensityButton.showInt(channelIntString, centerX, row1Padding + buttonHeight / 2, channelButtonWidth, buttonHeight * 1.5);

			if (syntaxError) {
				channelButton.show("SYNTAX ERROR", centerX, row1Padding, channelButtonWidth, buttonHeight, "SMALL", EOSLightRed);
			} else if (selectedChannel.length() <= 10) {
				channelButton.show(selectedChannel, centerX, row1Padding, channelButtonWidth, buttonHeight, "LARGE");
			} else if (selectedChannel.length() > 10 && selectedChannel.length() < 15) {
				channelButton.show(selectedChannel, centerX, row1Padding, channelButtonWidth, buttonHeight, "MEDIUM");
			} else if (selectedChannel.length() >= 15) {
				channelButton.show(selectedChannel, centerX, row1Padding, channelButtonWidth, buttonHeight, "SMALL");
			}
			textAlign(CENTER, BOTTOM);
			textFont(fontTiny);
			fill(white);
			try {
				text(channel, centerX, row1Padding - buttonHeight / 1.65); //INPUT
			} catch (Exception e) {

			}
		}
		topBarDraw();
		keyboard.draw();
		intensityOverlay.draw();
		liteOverlay();
		pop();
	}
}

PImage liteBanner;
KEYBOARD keyboard;
OVERLAY intensityOverlay;

//--------------------------------------------------------------
// MARK: ----------LITE BANNER OVERLAY----------
//--------------------------------------------------------------
void liteOverlay() {
	if (!isPaidVersion && (focusPage.clicked || formPage.clicked || imagePage.clicked || dSelectPage.clicked) && !settingsMenu) {
		push();
		translate(-liteBanner.width / 2, -liteBanner.height / 2);
		image(liteBanner, centerX, centerY);
		pop();
	}
}

//--------------------------------------------------------------
// MARK: ----------TOP BAR----------
//--------------------------------------------------------------


String oldChannel = "";
float settingsX, settingsY, settingsWidth, settingsHeight;

BUTTON shutterPage, formPage, dSelectPage, focusPage, imagePage, minusButton, plusButton, fineButton, highButton, flashButton, channelButton, intensityButton;

//--------------------------------------------------------------
// MARK: ----------SHUTTER PAGE----------
//--------------------------------------------------------------

PImage bgAssembly;
THRUST_HANDLE thrustA, thrustB, thrustC, thrustD;
ANGLE_HANDLE angleA, angleB, angleC, angleD;
ASSEMBLY_HANDLE assembly;

BUTTON thrustButton, angleButton, shutterButton;

//--------------------------------------------------------------
// MARK: ----------PAN TILT PAGE----------
//--------------------------------------------------------------

ENCODER focusEncoder;
String panPercent, tiltPercent, focusParameter, panTiltShow = "";

BUTTON panButton, tiltButton;

//--------------------------------------------------------------
// MARK: ----------FORM PAGE----------
//--------------------------------------------------------------

ENCODER formEncoder;
String irisPercent, edgePercent, zoomPercent, frostPercent, formParameter, parameterShow = "";

BUTTON irisButton, edgeButton, zoomButton, frostButton, minusPercentButton, homeButton, plusPercentButton;

//--------------------------------------------------------------
// MARK: ----------IMAGE PAGE----------
//--------------------------------------------------------------

BUTTON gobo1Button, gobo2Button, gobo3Button, beam1Button, beam2Button, beam3Button, ani1Button, ani2Button, ani3Button, color1Button, color2Button, color3Button;
String gobo1Select, gobo2Select, gobo3Select, beam1Select, beam2Select, beam3Select, ani1Select, ani2Select, ani3Select, color1Select, color2Select, color3Select;
String gobo1Speed, gobo2Speed, gobo3Speed, beam1Speed, beam2Speed, beam3Speed, ani1Speed, ani2Speed, ani3Speed;
boolean hasGobo1, hasGobo2, hasGobo3, hasBeam1, hasBeam2, hasBeam3, hasAni1, hasAni2, hasAni3, hasColor1, hasColor2, hasColor3 = false;

String imageParamShow, imageIndexParameter, imageSpeedParameter = "";

BUTTON minusSpeedButton, homeSpeedButton, plusSpeedButton;

//--------------------------------------------------------------
// MARK: ----------DIRECT SELECT PAGE----------
//--------------------------------------------------------------

BANK bankOne, bankTwo;

//--------------------------------------------------------------
// MARK: ----------SETTINGS----------
//--------------------------------------------------------------

String userInputIP = "";
String userInputID = "1";
int keySwitch = 0;
boolean ipChanged = false;

BUTTON ipFieldButton, idFieldButton;

//--------------------------------------------------------------
// MARK: ----------TOUCH EVENTS----------
//--------------------------------------------------------------
void mousePressed() {
	if (millis() > splashScreen) { //SPLASHSCREEN
		touch.x = mouseX; touch.y = mouseY; //PROCESSING ONLY
		oldTouch = newTouch; newTouch = millis();
		if (newTouch < oldTouch + 250) { touchDoubleTap(); }

		// ---------- SETTINGS + INTOVERLAY RESET ----------
		if (touch.x > settingsX && touch.y < settingsHeight && touch.y > notchHeight) {
			settingsMenu = !settingsMenu;
			channelButton.clicked = false;
			intensityOverlay.close();
			intensityButton.clicked = false;
		}

		// ---------- TOP BAR BUTTONS ----------
		shutterPage.touchDown();
		focusPage.touchDown();
		formPage.touchDown();
		imagePage.touchDown();
		dSelectPage.touchDown();

		// ---------- TOP GUI BUTTONS ----------
		if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked) && !keyboard.show) {
			minusButton.touchDown();
			plusButton.touchDown();
			fineButton.touchDown(true);
			highButton.touchDown(true);
			flashButton.touchDown();
			channelButton.touchDown(true);
			intensityButton.touchDown(true);
		}

		// ---------- PAGE ROUTING ----------
		if (shutterPage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			shutterPageTouchDown();
		} else if (focusPage.clicked && isPaidVersion && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			focusPageTouchDown();
		} else if (formPage.clicked && isPaidVersion && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			formPageTouchDown();
		} else if (imagePage.clicked && isPaidVersion && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			imagePageTouchDown();
		} else if (dSelectPage.clicked && isPaidVersion && !settingsMenu) {
			DSPageTouchDown();
		} else if (settingsMenu) {
			ipFieldButton.touchDown(true);
			idFieldButton.touchDown(true);
		}
		// ---------- OVERLAYS ----------
		if (keyboard.show) {
			keyboard.touchDown();
		}
		if (intensityOverlay.show) {
			intensityOverlay.touchDown();
		}
	}
}

//--------------------------------------------------------------

void mouseDragged() {
	if (millis() > splashScreen) { //SPLASHSCREEN
		touch.x = mouseX; touch.y = mouseY; //PROCESSING ONLY

		if (shutterPage.clicked && !settingsMenu) {
			shutterPageTouchMoved();
		} else if (focusPage.clicked && !settingsMenu) {
			focusPageTouchMoved();
		} else if (formPage.clicked && !settingsMenu) {
			formPageTouchMoved();
		} else if (imagePage.clicked && !settingsMenu) {
			imagePageTouchMoved();
		}

		if (intensityButton.clicked && !settingsMenu) {
			intensityOverlay.touchMoved(fineButton.clicked);
		}
	}
}

//--------------------------------------------------------------

void mouseReleased() {
	if (millis() > splashScreen) { //SPLASHSCREEN
		touch.x = mouseX; touch.y = mouseY; //PROCESSING ONLY

		if ((shutterPage.clicked || focusPage.clicked || formPage.clicked || imagePage.clicked) && !keyboard.show) {
			minusButton.touchUp();
			plusButton.touchUp();
			flashButton.touchUp();
		}

		if (shutterPage.clicked && !settingsMenu) {
			shutterPageTouchUp();
		} else if (focusPage.clicked && !settingsMenu && !keyboard.show) {
			focusPageTouchUp();
		} else if (formPage.clicked && !settingsMenu) {
			formPageTouchUp();
		} else if (imagePage.clicked && !settingsMenu) {
			imagePageTouchUp();
		} else if (dSelectPage.clicked && !settingsMenu) {
			DSPageTouchUp();
		}

		keyboard.touchUp();
		intensityOverlay.touchUp();
	}
}

//--------------------------------------------------------------

void touchDoubleTap() {
	if (millis() > splashScreen) { //SPLASHSCREEN
		if (shutterPage.clicked && !settingsMenu) {
			shutterPageDoubleTap();
		} else if (focusPage.clicked && !settingsMenu && !keyboard.show) {
			focusPageDoubleTap();
		} else if (formPage.clicked && !settingsMenu) {
			formPageDoubleTap();
		} else if (dSelectPage.clicked && !settingsMenu) {
			DSPageDoubleTap();
		}

		if (intensityButton.clicked && !settingsMenu) {
			intensityOverlay.touchDoubleTap();
		}
	}
}

//--------------------------------------------------------------
// MARK: ----------OSC EVENTS----------
//--------------------------------------------------------------

OscP5 eosIn, eos;

boolean oscSendLight = false;
boolean oscReceiveLight = false;

boolean pingSent = false;
boolean connectDelay = false;
boolean connectRun = false;
int checkTime;
int sentPingTime = 0;
int deltaTime = 0;
int receivedPingTime = 0;

// ----------------------- INCOMING OSC -----------------------

String multiChannelPrefix = "";
String noParameter = "";

// ----------------------- OUTGOING OSC -----------------------
// ----------------------- OUTGOING KEY PRESSES -----------------------

//--------------------------------------------------------------

// void onPause() {
// 	// saveXML();
// }

// void onResume() {
// 	// styleInit();
// 	// getXML();
// 	// IPAddress = getIPAddress();
// }