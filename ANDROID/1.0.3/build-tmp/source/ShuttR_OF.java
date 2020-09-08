import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import netP5.*; 
import oscP5.*; 
import java.net.*; 
import ketai.net.*; 
import java.net.InetAddress; 
import java.net.UnknownHostException; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ShuttR_OF extends PApplet {

//--------------------------------------------------------------
// A_ofApp.h || A_ofApp.mm
//--------------------------------------------------------------

							//OSC
							//OSC




 			//IP ADDRESS
 	//IP ADDRESS

boolean settingsMenu;

//--------------------------------------------------------------
// MARK: ----------GUI----------
//--------------------------------------------------------------

public void setup() {
	orientation(PORTRAIT);
	 //PIXEL DIMENSIONS = 1440 x 2960
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
	// imagePageSetup();
	DSPageSetup();
	settingsSetup();
	intensityOverlay.setup();
}

public void update() {
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

public void pageButtonAction() {
	if (shutterPage.clicked && !settingsMenu) {
		shutterPageUpdate();
	} else if (focusPage.clicked && !settingsMenu) {
		focusPageUpdate();
	} else if (formPage.clicked && !settingsMenu) {
		formPageUpdate();
	} else if (imagePage.clicked && !settingsMenu) {
		// imagePageUpdate();
	} else if (dSelectPage.clicked && !settingsMenu) {
		DSPageUpdate();
	}
}

//--------------------------------------------------------------
// MARK: ---------- GUI BUTTON ACTIONS ----------
//--------------------------------------------------------------

public void buttonAction() {
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

public void channelButtonAction() {
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

public void intensityButtonAction() {
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

public void oscLightUpdate() {
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

public void draw() {
	update(); //KEEP UPDATE FIRST
	//---------------------------
	background(EOSBackground);
	if (millis() < splashScreen) { //SPLASH SCREEN
		push();
		imageMode(CENTER);
		image(splashImg, width / 2, height / 4, width / 1.5f, width / 1.5f);
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
			// imagePageDraw();
		}
		if (dSelectPage.clicked && !settingsMenu && !intensityOverlay.show) {
			DSPageDraw();
		}
		if (settingsMenu) {
			settingsDraw();
		}

		if ((shutterPage.clicked || formPage.clicked || focusPage.clicked || imagePage.clicked) && !settingsMenu) {
			String channel = "SELECTED CHANNEL";
			minusButton.show("-", guiLeftAlign, row1Padding + buttonHeight / 2, smallButtonWidth, buttonHeight, "LARGE");
			plusButton.show("+", guiRightAlign, row1Padding + buttonHeight / 2, smallButtonWidth, buttonHeight, "LARGE");
			fineButton.show("FINE", guiLeftAlign, row2Padding, genericButtonWidth, buttonHeight, "LARGE");
			highButton.show("HIGH", guiCenterAlign, row2Padding, genericButtonWidth, buttonHeight, "LARGE");
			flashButton.show("FLASH", guiRightAlign, row2Padding, genericButtonWidth, buttonHeight, "LARGE");

			intensityButton.showInt(channelIntString, centerX, row1Padding + buttonHeight / 2, channelButtonWidth, buttonHeight * 1.5f);

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
			text(channel, centerX, row1Padding - buttonHeight / 1.75f); //INPUT
		}
		topBarDraw();
		keyboard.draw();
		intensityOverlay.draw();
		pop();
	}
}

KEYBOARD keyboard;
OVERLAY intensityOverlay;

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
public void mousePressed() {
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
		} else if (focusPage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			focusPageTouchDown();
		} else if (formPage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			formPageTouchDown();
		} else if (imagePage.clicked && !settingsMenu && !keyboard.show && !intensityButton.clicked) {
			// imagePageTouchDown();
		} else if (dSelectPage.clicked && !settingsMenu) {
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

public void mouseDragged() {
	if (millis() > splashScreen) { //SPLASHSCREEN
		touch.x = mouseX; touch.y = mouseY; //PROCESSING ONLY

		if (shutterPage.clicked && !settingsMenu) {
			shutterPageTouchMoved();
		} else if (focusPage.clicked && !settingsMenu) {
			focusPageTouchMoved();
		} else if (formPage.clicked && !settingsMenu) {
			formPageTouchMoved();
		} else if (imagePage.clicked && !settingsMenu) {
			// imagePageTouchMoved(touch);
		}

		if (intensityButton.clicked && !settingsMenu) {
			intensityOverlay.touchMoved(fineButton.clicked);
		}
	}
}

//--------------------------------------------------------------

public void mouseReleased() {
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
			// imagePageTouchUp();
		} else if (dSelectPage.clicked && !settingsMenu) {
			DSPageTouchUp();
		}

		keyboard.touchUp();
		intensityOverlay.touchUp();
	}
}

//--------------------------------------------------------------

public void touchDoubleTap() {
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
//--------------------------------------------------------------
// A0_GLOBALS.h || A_style.mm
//--------------------------------------------------------------

// ----------------------- PAID VS FREE VERSION -----------------------
boolean isPaidVersion = false;

//--------------------------------------------------------------
// MARK: ---------- EOS SETTINGS ----------
//--------------------------------------------------------------

// ----------------------- NAME / IP / ID / RX / TX / SELECTED CHANNEL -----------------------
// String appName = "ShuttR Cut OSC";
String appName = "ShuttR Cut LITE";

String version = "v1.0.3";
String headerName = appName;

String IPAddress, inputIP, inputID, selectedChannel = "";

// ----------------------- EOS BOOLEANS -----------------------
boolean noneSelected = true;
boolean ignoreOSC = false;
boolean isLive = true;
boolean syntaxError = false;

// ----------------------- NETWORK BOOLEANS -----------------------
boolean connectRequest = false;
boolean isConnected = false;
boolean hasWifi = false;
boolean hasOSC = false;

// ----------------------- RX / TX LIGHT TIME -----------------------
float oscSentTime, oscReceivedTime = 0;

// ----------------------- CHANNEL / INTENSITY -----------------------
String channelIntString;
int channelInt, channelInt255;
float channelHue, channelSat;


//--------------------------------------------------------------
// MARK: ---------- TEXT STYLES ----------
//--------------------------------------------------------------
float largeTextSize, mediumTextSize, smallTextSize, dsTextSize, tinyTextSize;
PFont fontLarge; PFont fontMedium; PFont fontSmall; PFont fontTiny; PFont fontDS;


//--------------------------------------------------------------
// MARK: ---------- SIZE CONSTANTS ----------
//--------------------------------------------------------------

// ----------------------- PROCESSING ONLY -----------------------
PVector touch;
int newTouch, oldTouch = 0;
Table table;
SocketAddress sockaddr;
PImage splashImg;
int splashScreen = 5000;

// ----------------------- PARENT CONSTANTS -----------------------
float centerX, centerY = 0;
float notchHeight = 0;

// ----------------------- GUI HEIGHT -----------------------
float settingsBarHeight = 0;
float row1Padding, row2Padding, row3Padding, row4Padding, row5Padding, row6Padding, row7Padding, row8Padding, row9Padding, row10Padding, rowBottomPadding;

// ----------------------- GUI ALIGN -----------------------
float guiLeftAlign, guiCenterAlign, guiRightAlign;

// ----------------------- BUTTON WIDTH / HEIGHT -----------------------
float lightWidth, channelButtonWidth, genericButtonWidth, smallButtonWidth, parameterButtonWidth;
float buttonHeight;
float buttonCorner;

// ----------------------- STROKE WEIGHT -----------------------
float settingsBarStrokeWeight, buttonStrokeWeight, shutterStrokeWeight, outsideWeight, thrustWeight, angleWeight, crosshairWeight, assemblyButtonWeight, assemblyLineWeight;

// ----------------------- CONSOLE LOG -----------------------
float consoleWidth, consoleHeight, consolePadding;
StringList console_log = new StringList();

String log_NoConnect = "ERROR: COULD NOT CONNECT";
String log_YesConnect = "SUCCESSFULLY CONNECTED";
String log_CheckOSC = "ERROR: CHECK IF OSC RX AND TX ARE ENABLED";
String log_Connecting = "CONNECTING TO: ";
String log_UserSwitch = "SWITCHING TO USER: ";
String log_lostConnect = "LOST CONNECTION...";
String log_reConnect = "RE-CONNECTED TO: ";

// ----------------------- SHUTTER PAGE CONSTANTS -----------------------
float assemblyDiameter, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
float rotation = 0;

//--------------------------------------------------------------
// MARK: ---------- COLOR ----------
//--------------------------------------------------------------

//---------- GENERIC COLOR ----------
int white, black;

//---------- EOS GENERIC COLORS ----------
int EOSBlue, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLightGrey, EOSDarkGrey;

//---------- EOS SPECIFIC COLORS ----------
int EOSBackground, EOSLive, EOSBlind, EOSState, EOSBarState;

//---------- EOS SHUTTER COLORS ----------
int shutterBackground, shutterOutsideStroke, shutterFrameFill, shutterFrameStroke;

//---------- EOS DIRECT SELECT COLORS ----------
int EOSChannel, EOSGroup, EOSIntensity, EOSColor, EOSFocus, EOSBeam, EOSPreset, EOSfx, EOSMacro, EOSSnap, EOSMagic, EOSScene;

//---------- ASSIGNMENT COLORS ----------

int buttonActive, BGFill;
int shutterColor = color(0);

//--------------------------------------------------------------
// MARK: ---------- INITIALIZERS ----------
//--------------------------------------------------------------

public void stateUpdate() {
  if (isConnected) {
    if (isLive) {
      EOSState = EOSLive;
      EOSBarState = EOSDarkGrey;
    } else {
      EOSState = EOSBlind;
      EOSBarState = EOSBlue;
    }
  } else {
    headerName = appName;
    selectedChannel = "";
    clearParams(); //TODO
    EOSState = EOSLightGrey;
    EOSBarState = EOSDarkGrey;
  }
}

//--------------------------------------------------------------
public float ofGetPreviousMouseX() { return pmouseX; }
public float ofGetPreviousMouseY() { return pmouseY; }
//--------------------------------------------------------------
public void javaClassInit() {
  //---------- mouse to touch vector ----------
  touch = new PVector(0, 0);

  //---------- KEYBOARD ----------
  keyboard = new KEYBOARD(); keyboard.enterButton = new BUTTON(); keyboard.clearButton = new BUTTON(); keyboard.zeroButton = new BUTTON(); keyboard.dotButton = new BUTTON(); keyboard.oneButton = new BUTTON(); keyboard.twoButton = new BUTTON(); keyboard.threeButton = new BUTTON(); keyboard.fourButton = new BUTTON(); keyboard.fiveButton = new BUTTON(); keyboard.sixButton = new BUTTON(); keyboard.sevenButton = new BUTTON(); keyboard.eightButton = new BUTTON(); keyboard.nineButton = new BUTTON();

  //---------- INTENSITY OVERLAY ----------
  intensityOverlay = new OVERLAY(); intensityOverlay.fullButton = new BUTTON(); intensityOverlay.levelButton = new BUTTON(); intensityOverlay.outButton = new BUTTON(); intensityOverlay.minusPercentButton = new BUTTON(); intensityOverlay.homeButton = new BUTTON(); intensityOverlay.plusPercentButton = new BUTTON();

  //---------- TOP BAR ----------
  shutterPage = new BUTTON(); formPage = new BUTTON(); dSelectPage = new BUTTON(); focusPage = new BUTTON(); imagePage = new BUTTON(); minusButton = new BUTTON(); plusButton = new BUTTON(); fineButton = new BUTTON(); highButton = new BUTTON(); flashButton = new BUTTON(); channelButton = new BUTTON(); intensityButton = new BUTTON();

  //---------- SHUTTER PAGE ----------
  thrustButton = new BUTTON(); angleButton = new BUTTON(); shutterButton = new BUTTON();
  thrustA = new THRUST_HANDLE(); thrustB = new THRUST_HANDLE(); thrustC = new THRUST_HANDLE(); thrustD = new THRUST_HANDLE();
  angleA = new ANGLE_HANDLE(); angleB = new ANGLE_HANDLE(); angleC = new ANGLE_HANDLE(); angleD = new ANGLE_HANDLE();
  assembly = new ASSEMBLY_HANDLE();

  //---------- PAN TILT PAGE ----------
  focusEncoder = new ENCODER(); panButton = new BUTTON(); tiltButton = new BUTTON();

  //---------- FORM PAGE ----------
  formEncoder = new ENCODER(); irisButton = new BUTTON(); edgeButton = new BUTTON(); zoomButton = new BUTTON(); frostButton = new BUTTON(); minusPercentButton = new BUTTON(); homeButton = new BUTTON(); plusPercentButton = new BUTTON();

  //---------- FORM PAGE ----------
  bankOne = new BANK(); bankTwo = new BANK();

  //---------- SETTINGS ----------
  ipFieldButton = new BUTTON(); idFieldButton = new BUTTON();

}
//--------------------------------------------------------------
public void styleInit() {
  if (appName.indexOf("LITE") != -1) {
    splashImg = loadImage("icon-lite.png");
  } else {
    splashImg = loadImage("icon-pro.png");
  }

  push();
  colorMode(HSB, 255, 255, 255, 255);
  shutterColor = color(163.056f, 103.167f, 255);
  pop();

  //---------- PARENT WIDTH AND HEIGHT ----------

  // width = ofGetWidth();
  // height = ofGetHeight() - notchHeight;

  //---------- FRAME ASSEMBLY VARIABLES ----------
  clickDiameter = width / 9.6f;
  clickRadius = clickDiameter / 2;
  encoderDiameter = width / 6;
  float screenAdjust = (height / width) - 1;
  if (screenAdjust == 0) {
    screenAdjust = 1;
  }
  assemblyDiameter = width - (clickDiameter + (clickRadius / 2)) / screenAdjust;
  assemblyRadius = assemblyDiameter / 2;
  thrustDiameter = assemblyRadius / 2;
  centerX = width / 2;
  centerY = (height - assemblyDiameter + assemblyRadius / 3) + notchHeight;

  ///---------- FRAME ASSEMBLY STYLES ----------

  shutterStrokeWeight = (width / 50) / 1.5f; //width / 50
  outsideWeight = width / 96; //15
  thrustWeight = width / 288; //5
  angleWeight = width / 288; //5
  crosshairWeight = width / 144;
  assemblyButtonWeight = width / 288; //5
  assemblyLineWeight = (width / 144) / 2; //10

  //---------- BUTTON STYLES ----------

  buttonStrokeWeight = (width / 144);
  settingsBarStrokeWeight = buttonStrokeWeight;
  buttonCorner = width / 57.6f;

  //---------- GUI ALIGNMENT ----------

  guiLeftAlign = centerX - centerX / 1.5f;
  guiCenterAlign = centerX;
  guiRightAlign = centerX + centerX / 1.5f;

  //---------- GUI HEIGHT ----------

  buttonHeight = height / 19.7f;
  settingsBarHeight = height / 20;
  consoleHeight = height / 10;

  //---------- GUI WIDTH ----------

  lightWidth = width / 10;
  channelButtonWidth = (width / 4.5f) * 1.5f;
  smallButtonWidth = width / 6;
  genericButtonWidth = width / 4.5f;
  parameterButtonWidth = genericButtonWidth / 1.25f;
  consoleWidth = width / 1.25f;

  //---------- GUI PADDDING ----------

  row1Padding = (settingsBarHeight + buttonHeight) + notchHeight;
  row2Padding = row1Padding + height / 9; //13
  row3Padding = row2Padding + height / 14; //13
  row4Padding = row3Padding + height / 14;
  row5Padding = row4Padding + height / 14;
  row6Padding = row5Padding + height / 14;
  row7Padding = row6Padding + height / 14;
  row8Padding = row7Padding + height / 14;
  row9Padding = row8Padding + height / 14;
  row10Padding = row9Padding + height / 14;
  rowBottomPadding = (height - height / 15) + notchHeight;
  consolePadding = (height / 2) + notchHeight;

  //---------- TEXT STYLES ----------

  largeTextSize = width / 19.2f; //75
  mediumTextSize = width / 22.15f; //65
  smallTextSize = width / 32; //45
  dsTextSize = (width / 32) / 1.1f; //45
  tinyTextSize = width / 57.6f; //25

  fontLarge = createFont("LondonBetween.ttf", largeTextSize);
  fontMedium = createFont("LondonBetween.ttf", mediumTextSize);
  fontSmall = createFont("LondonBetween.ttf", smallTextSize);
  fontDS = createFont("LondonBetween.ttf", dsTextSize);
  fontTiny = createFont("LondonBetween.ttf", tinyTextSize);

  console_log.append("");
  console_log.append("");
  console_log.append("");
  console_log.append(appName + " " + version);

  //---------- COLOR ----------
  //---------- GENERIC COLOR ----------

  white = color(255);
  black = color(0);

  //---------- EOS GENERIC COLORS ----------

  EOSBlue = color(22, 40, 58); //Channels In Use
  EOSLightGreen = color(6, 155, 37); //Light Green
  EOSGreen = color(6, 55, 37); //PSD
  EOSLightRed = color(165, 21, 23); //Light Red
  EOSRed = color(65, 21, 23); //Snapshots
  EOSLightGrey = color(85, 90, 101);
  EOSDarkGrey = color(30, 30, 30);

  //---------- EOS SPECIFIC COLORS ----------

  EOSBackground = color(15, 25, 35); //OLD
  // EOSBackground = color(0, 0, 0); //NEW
  EOSLive = color(183, 128, 6);
  EOSBlind = color(10, 115, 222);

  //---------- EOS SHUTTER COLORS ----------

  shutterBackground = color(150, 150, 255); //180,181,255
  shutterOutsideStroke = color(125, 115, 130);
  shutterFrameFill = color(62, 56, 71);
  shutterFrameStroke = color(204, 195, 209);
  shutterOutsideStroke = color(125, 115, 130);

  //---------- EOS DIRECT SELECT COLORS ----------

  EOSChannel = 0xff275787;
  EOSGroup = 0xff517ba0;
  EOSIntensity = 0xffb14932;
  EOSColor = 0xff495476;
  EOSFocus = 0xff00624c;
  EOSBeam = 0xff0e3089;
  EOSPreset = 0xff085f7e;
  EOSfx = 0xff512789;
  EOSMacro = 0xff62626a;
  EOSSnap = 0xff9d1f2a;
  EOSMagic = 0xff891951;
  EOSScene = 0xff007e4e;

  //---------------------------------------
  //---------- ASSIGNMENT COLORS ----------

  BGFill = shutterBackground;
  buttonActive = EOSLightGrey;
}




//--------------------------------------------------------------
// A_utility.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- XML----------
//--------------------------------------------------------------

public void saveXML() {
	try {
		TableRow row = table.getRow(0);
		row.setString("IP", inputIP);
		row.setString("ID", inputID);
		saveTable(table, "ShuttRData.csv");
	} catch (NullPointerException e) {

	}
}

//--------------------------------------------------------------

public void getXML() {
	try {
		table = loadTable("ShuttRData.csv", "header");
		TableRow row = table.getRow(0);
		userInputIP = row.getString("IP");
		userInputID = row.getString("ID");
		inputIP = userInputIP;
		inputID = userInputID;
	} catch (NullPointerException e) {
		table = new Table();
		table.addColumn("IP");
		table.addColumn("ID");
		TableRow newRow = table.addRow();
		newRow.setString("IP", "");
		newRow.setString("ID", "1");
		saveTable(table, "ShuttRData.csv");
		inputIP = "";
		inputID = "1";
	}
}

//--------------------------------------------------------------
// MARK: ---------- IP ADDRESS ----------
//--------------------------------------------------------------

public String getIPAddress() {
	String ip = "";

	try {
		ip = InetAddress.getLocalHost().toString();
		ip = KetaiNet.getIP();
		hasWifi = true;
		return ip;
	} catch (UnknownHostException e) {
		e.printStackTrace();
		hasWifi = false;
		return "CHECK WIFI";
	}
}

//--------------------------------------------------------------
// MARK: ---------- ANDROID NOTCH HEIGHT ----------
//--------------------------------------------------------------

public void getNotchHeight() {

	notchHeight = height / 40;

}
//--------------------------------------------------------------
// B_directSelectPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- DIRECT SELECT - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

public void DSPageSetup() {
	bankOne.setup(1); bankTwo.setup(2);
}

//--------------------------------------------------------------
public void DSPageUpdate() {
	bankOne.update(); bankTwo.update();
}

//--------------------------------------------------------------
public void DSPageDraw() {
	bankOne.draw(row1Padding);
	bankTwo.draw(row1Padding + notchHeight / 2 + bankTwo.bankHeight); // notchHeight / 2

	if (bankOne.quickButton.clicked) {
		bankOne.quickSelectsShow();
	}
	if (bankTwo.quickButton.clicked) {
		bankTwo.quickSelectsShow();
	}
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

public void DSPageTouchDown() {
	bankOne.touchDown(); bankTwo.touchDown();
}

//--------------------------------------------------------------
public void DSPageTouchMoved() {

}

//--------------------------------------------------------------
public void DSPageTouchUp() {
	bankOne.touchUp(); bankTwo.touchUp();
}

//--------------------------------------------------------------
public void DSPageDoubleTap() {

}

//--------------------------------------------------------------

public void parseDirectSelectSend() {
	PVector dSelect = new PVector(0, 0, 0);
	boolean dFlexi = false;
	//X = BANK
	//Y = PARAMETER
	//Z = BUTTON
	//dSelectFlexi = FLEXI
	if (bankOne.vectorEventTrigger || bankTwo.vectorEventTrigger) {
		if (bankOne.vectorEventTrigger) {
			dSelect = bankOne.dSelectVector;
			dFlexi = bankOne.dSelectFlexi;
		} else {
			dSelect = bankTwo.dSelectVector;
			dFlexi = bankTwo.dSelectFlexi;
		}

		String directParameter = "";

		if (dSelect.y != 0 && dSelect.z == 0) { //QUICK SELECT
			int switchCase = PApplet.parseInt(dSelect.y);
			switch (switchCase) {
			case 1:
				directParameter = "chan"; break;
			case 2:
				directParameter = "group"; break;
			case 3:
				directParameter = "ip"; break;
			case 4:
				directParameter = "fp"; break;
			case 5:
				directParameter = "cp"; break;
			case 6:
				directParameter = "bp"; break;
			case 7:
				directParameter = "preset"; break;
			case 8:
				directParameter = "macro"; break;
			case 9:
				directParameter = "fx"; break;
			case 10:
				directParameter = "snap"; break;
			case 11:
				directParameter = "ms"; break;
			case 12:
				directParameter = "scene"; break;
			case 13:
				break;
			}

			if (dFlexi) {
				directParameter += "/flexi";
			}

			sendDSRequest(str(dSelect.x), directParameter);

		} else if (dSelect.y == 0 && dSelect.z != 0) {//DIRECT SELECT BUTTON

			sendDS(str(dSelect.x), str(dSelect.z));

		}
		bankOne.vectorEventTrigger = false;
		bankTwo.vectorEventTrigger = false;
	}
}
//--------------------------------------------------------------

public void parseDirectSelectPage() {

	PVector dSelect = new PVector(0, 0);
	if (bankOne.pageEventTrigger || bankTwo.pageEventTrigger) {
		if (bankOne.pageEventTrigger) {
			dSelect = bankOne.dSelectPage;
		} else {
			dSelect = bankTwo.dSelectPage;
		}
		sendDSPage(str(dSelect.x), str(dSelect.y));
		bankOne.pageEventTrigger = false;
		bankTwo.pageEventTrigger = false;
	}
}
//--------------------------------------------------------------
// B_formPage.h && B_formPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- ENCODER - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

public void formPageSetup() {
	formEncoder.setup(assemblyDiameter / 1.25f);
}

//--------------------------------------------------------------

public void formPageUpdate() {
	if (irisButton.action && irisButton.clicked) {
		irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
		irisButton.action = false;
		parameterShow = "IRIS"; formParameter = "iris";
	} else if (edgeButton.action && edgeButton.clicked) {
		irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
		edgeButton.action = false;
		parameterShow = "EDGE"; formParameter = "edge";
	} else if (zoomButton.action && zoomButton.clicked) {
		irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
		zoomButton.action = false;
		parameterShow = "ZOOM"; formParameter = "zoom";
	} else if (frostButton.action && frostButton.clicked) {
		irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
		frostButton.action = false;
		parameterShow = "FROST"; formParameter = "diffusion";
	} else if (!irisButton.clicked && !edgeButton.clicked && !zoomButton.clicked && !frostButton.clicked) {
		parameterShow = "FORM"; formParameter = "form";
	}

	if (minusPercentButton.action && formParameter != "form") { //if param is form, don't send.
		sendEncoderPercent(formParameter, -1);
		minusPercentButton.action = false;
	} else if (homeButton.action) {
		if (formParameter == "form" && homeButton.doubleClicked) { //If double tapped, sneak
			sendSneak("form");
		} else {
			sendEncoderPercent(formParameter, 0);
		}
		homeButton.action = false;
	} else if (plusPercentButton.action && formParameter != "form") { //if param is form, don't send.
		sendEncoderPercent(formParameter, 1);
		plusPercentButton.action = false;
	}
}

//--------------------------------------------------------------

public void formPageDraw() {

	irisButton.showBig("IRIS", irisPercent, guiLeftAlign, row3Padding, smallButtonWidth, buttonHeight);
	edgeButton.showBig("EDGE", edgePercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
	zoomButton.showBig("ZOOM", zoomPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
	frostButton.showBig("FROST", frostPercent, guiRightAlign, row3Padding, smallButtonWidth, buttonHeight);

	minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
	homeButton.show(parameterShow, "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
	plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");

	formEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

public void formPageTouchDown() {
	irisButton.touchDown(true);
	edgeButton.touchDown(true);
	zoomButton.touchDown(true);
	frostButton.touchDown(true);
	minusPercentButton.touchDown();
	homeButton.touchDown();
	plusPercentButton.touchDown();

	formEncoder.touchDown();
}

public void formPageTouchMoved() {
	formEncoder.touchMoved();
}


public void formPageTouchUp() {
	minusPercentButton.touchUp();
	homeButton.touchUp();
	plusPercentButton.touchUp();

	formEncoder.touchUp();
}

public void formPageDoubleTap() {
	homeButton.touchDoubleTap();
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

public void sendFormEncoder() {
	if (formEncoder.eventTrigger && formParameter != "form") {
		if (fineButton.clicked) {
			sendEncoder(formParameter, formEncoder.encoderOutput / 1000);
		} else {
			sendEncoder(formParameter, formEncoder.encoderOutput * 2);
		}
		formEncoder.eventTrigger = false;
	}
}
//--------------------------------------------------------------
// B_panTiltPage.h && B_panTiltPage.mm
//--------------------------------------------------------------

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

public void focusPageSetup() {
	focusEncoder.setup(assemblyDiameter / 1.25f);
}

//--------------------------------------------------------------
public void focusPageUpdate() {
	if (panButton.action && panButton.clicked) {
		panButton.clicked = true; tiltButton.clicked = false;
		panButton.action = false;
		panTiltShow = "PAN"; focusParameter = "pan";
	} else if (tiltButton.action && tiltButton.clicked) {
		panButton.clicked = false; tiltButton.clicked = true;
		tiltButton.action = false;
		panTiltShow = "TILT"; focusParameter = "tilt";
	} else if (!panButton.clicked && !tiltButton.clicked) {
		panTiltShow = "FOCUS"; focusParameter = "focus";
	}

	if (minusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
		sendEncoderPercent(focusParameter, -1);
		minusPercentButton.action = false;
	} else if (homeButton.action) {
		if (focusParameter == "focus" && homeButton.doubleClicked) {  //If double tapped, sneak
			sendSneak("focus");
		} else {
			sendEncoderPercent(focusParameter, 0);
		}
		homeButton.action = false;
	} else if (plusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
		sendEncoderPercent(focusParameter, 1);
		plusPercentButton.action = false;
	}
}

//--------------------------------------------------------------
public void focusPageDraw() {

	panButton.showBig("PAN", panPercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
	tiltButton.showBig("TILT", tiltPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);

	minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
	homeButton.show(panTiltShow, "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
	plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");

	focusEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

public void focusPageTouchDown() {
	panButton.touchDown(true);
	tiltButton.touchDown(true);

	minusPercentButton.touchDown();
	homeButton.touchDown();
	plusPercentButton.touchDown();

	focusEncoder.touchDown();
}

//--------------------------------------------------------------
public void focusPageTouchMoved() {
	focusEncoder.touchMoved();
}

//--------------------------------------------------------------
public void focusPageTouchUp() {
	minusPercentButton.touchUp();
	homeButton.touchUp();
	plusPercentButton.touchUp();

	focusEncoder.touchUp();
}

//--------------------------------------------------------------
public void focusPageDoubleTap() {
	homeButton.touchDoubleTap();
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

public void sendFocusEncoder(){
    if (focusEncoder.eventTrigger && focusParameter != "focus") {
        if (fineButton.clicked) {
            sendEncoder(focusParameter, focusEncoder.encoderOutput / 1000);
        } else {
            sendEncoder(focusParameter, focusEncoder.encoderOutput * 2);
        }
        focusEncoder.eventTrigger = false;
    }
}
//--------------------------------------------------------------
// B_settingsPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- SETTINGS - SETUP / UPDATE / DRAW -------
//--------------------------------------------------------------

public void settingsSetup() {
	userInputIP = inputIP;
	userInputID = inputID;
	ipFieldButton.clicked = false; idFieldButton.clicked = false; //BUTTON INIT
}

//--------------------------------------------------------------

public void settingsUpdate() {
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

public void settingsDraw() {
	String IP = "IP ADDRESS";
	String ID = "USER";

	textAlign(CENTER, CENTER);	//PROCESSING
	fill(white);				//PROCESSING
	textFont(fontMedium); 		//PROCESSING

	ipFieldButton.show(userInputIP, centerX, row1Padding * 1.25f, channelButtonWidth * 2, buttonHeight, "LARGE");
	text(IP, centerX, row1Padding * 1.25f - buttonHeight / 1.25f); //INPUT

	idFieldButton.show(userInputID, guiCenterAlign, row2Padding * 1.25f, genericButtonWidth, buttonHeight, "LARGE");
	text(ID, centerX, row2Padding * 1.25f - buttonHeight / 1.25f); //INPUT

	console();

	about();
}

//--------------------------------------------------------------
// MARK: ---------- CONSOLE LOG ----------
//--------------------------------------------------------------

public void consoleLog(String text) {
	console_log.set(3, console_log.get(2));
	console_log.set(2, console_log.get(1));
	console_log.set(1, console_log.get(0));
	console_log.set(0, text);

	if (console_log.size() > 4) {
		console_log.remove(4);
	}
}

public void console() {
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

	translate(- consoleWidth / 2.1f, consolePadding);

	text(console_log.get(console_log.size() - 1), guiCenterAlign, - consoleHeight / 3);
	text(console_log.get(console_log.size() - 2), guiCenterAlign, - consoleHeight / 9);
	text(console_log.get(console_log.size() - 3), guiCenterAlign, consoleHeight / 9);
	text(console_log.get(console_log.size() - 4), guiCenterAlign, consoleHeight / 3);
	pop();
}

//--------------------------------------------------------------
// MARK: ---------- ABOUT ----------
//--------------------------------------------------------------

public void about() {
	String aboutOne = appName + " " + version;
	String thisIP = "Local IP Address: " + IPAddress;
	String aboutTwo =  "Made by Ted Charles Brown | TedCharlesBrown.com";
	String aboutThree = "Have suggestions? See a bug? Want to connect / buy me a coffee?";
	String aboutFour = "Email me at TedCharlesBrown+ShuttR@Gmail.com!";

	push();
	textAlign(CENTER, CENTER);	//PROCESSING
	fill(white);				//PROCESSING
	textFont(fontMedium); 		//PROCESSING

	text(aboutOne, centerX, height - smallTextSize * 6.75f);
	text(thisIP, centerX, height - smallTextSize * 5.25f);

	textFont(fontSmall); 		//PROCESSING
	text(aboutTwo, centerX, height - smallTextSize * 3.75f);
	text(aboutThree, centerX, height - smallTextSize * 2.5f);
	text(aboutFour, centerX, height - smallTextSize * 1.15f);

	pop();
}
//--------------------------------------------------------------
// B_shutterPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- SHUTTER PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

public void shutterPageSetup() {
	bgAssembly = loadImage("IMG_bgAssembly.png");
	bgAssembly.resize(PApplet.parseInt(assemblyDiameter * 2), PApplet.parseInt(assemblyDiameter * 2));

	thrustA.setup("a"); thrustB.setup("b"); thrustC.setup("c"); thrustD.setup("d");
	angleA.setup("a"); angleB.setup("b"); angleC.setup("c"); angleD.setup("d");
	assembly.setup();
}

//--------------------------------------------------------------

public void shutterPageUpdate() {
	if (thrustButton.action) {
		if (noneSelected) {
			thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
		} else {
			sendShutterHome("THRUST");
		}
		thrustButton.action = false;
	}
	if (angleButton.action) {
		if (noneSelected) {
			angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
		} else {
			sendShutterHome("ANGLE");
		}
		angleButton.action = false;
	}
	if (shutterButton.action) {
		if (noneSelected) {
			angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
			thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
			assembly.frameX = assembly.defaultX;
		} else if (shutterButton.doubleClicked) {
			sendSneak("Shutter");
		} else {
			sendShutterHome("SHUTTER");
		}
		shutterButton.action = false;
	}
}

//--------------------------------------------------------------

public void shutterPageDraw() {
	assemblyBackground();

	angleA.frameDisplay(thrustA.buttonA.position); angleC.frameDisplay(thrustC.buttonC.position); angleB.frameDisplay(thrustB.buttonB.position); angleD.frameDisplay(thrustD.buttonD.position);

	assemblyFront();

	thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight);
	angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
	shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight);

	push();
	translate(centerX, centerY);
	rotate(rotation);

	angleA.update(); angleB.update(); angleC.update(); angleD.update();
	thrustA.update(); thrustB.update(); thrustC.update(); thrustD.update();
	thrustA.buttonA.angleLimit(angleA.anglePercent); thrustB.buttonB.angleLimit(angleB.anglePercent); thrustC.buttonC.angleLimit(angleC.anglePercent); thrustD.buttonD.angleLimit(angleD.anglePercent);

	pop();

	assembly.update();
}

//--------------------------------------------------------------
// MARK: ---------- ASSEMBLY FOREGROUND / BACKGROUND ----------
//--------------------------------------------------------------

public void assemblyBackground() {
	push();

	translate(centerX, centerY);

	fill(shutterColor);
	noStroke();
	circle(0, 0, assemblyDiameter); //INSIDE FILL

	pop();
}

public void assemblyFront() {
	push();

	fill(EOSBackground);
	noStroke();
	rect(0, settingsBarHeight + settingsBarStrokeWeight, width, centerY - settingsBarHeight - assemblyRadius); //UPPER FILL

	translate(centerX, centerY);

	rect(-centerX, assemblyRadius, width, height - centerY); //LOWER FILL

	stroke(EOSBackground);
	strokeWeight(shutterStrokeWeight);
	noFill();
	for (int i = PApplet.parseInt(assemblyDiameter + shutterStrokeWeight); i < assemblyDiameter + assemblyRadius + shutterStrokeWeight; i += shutterStrokeWeight) {
		circle(0, 0, i);
	}

	stroke(shutterOutsideStroke);
	strokeWeight(shutterStrokeWeight);
	noFill();
	circle(0, 0, assemblyDiameter); //OUTSIDE FILL

	rotate(rotation);

	fill(255, 25);
	noStroke();
	rect(- assemblyRadius + outsideWeight, crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
	rect(- crosshairWeight / 2, - assemblyRadius + outsideWeight, crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR

	pop();
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

public void shutterPageTouchDown() {
	thrustButton.touchDown();
	angleButton.touchDown();
	shutterButton.touchDown();

	thrustA.touchDown(); thrustB.touchDown(); thrustC.touchDown(); thrustD.touchDown();
	angleA.touchDown(); angleB.touchDown(); angleC.touchDown(); angleD.touchDown();
	assembly.touchDown();
}

//--------------------------------------------------------------

public void shutterPageTouchMoved() {
	thrustA.touchMoved(fineButton.clicked); thrustB.touchMoved(fineButton.clicked); thrustC.touchMoved(fineButton.clicked); thrustD.touchMoved(fineButton.clicked);
	angleA.touchMoved(fineButton.clicked); angleB.touchMoved(fineButton.clicked); angleC.touchMoved(fineButton.clicked); angleD.touchMoved(fineButton.clicked);
	assembly.touchMoved(fineButton.clicked);
}

//--------------------------------------------------------------

public void shutterPageTouchUp() {
	thrustButton.touchUp();
	angleButton.touchUp();
	shutterButton.touchUp();

	thrustA.touchUp(); thrustB.touchUp(); thrustC.touchUp(); thrustD.touchUp();
	angleA.touchUp(); angleB.touchUp(); angleC.touchUp(); angleD.touchUp();
	assembly.touchUp();
}

//--------------------------------------------------------------

public void shutterPageDoubleTap() {
	shutterButton.touchDoubleTap();

	thrustA.touchDoubleTap(); thrustB.touchDoubleTap(); thrustC.touchDoubleTap(); thrustD.touchDoubleTap();
	angleA.touchDoubleTap(); angleB.touchDoubleTap(); angleC.touchDoubleTap(); angleD.touchDoubleTap();
	assembly.touchDoubleTap();
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

public void sendThrustA() {
	if (thrustA.buttonA.eventTrigger) {
		sendShutter("THRUST", "a", (thrustA.buttonA.thrustPercent));
		thrustA.buttonA.eventTrigger = false;
	}
}
public void sendThrustB() {
	if (thrustB.buttonB.eventTrigger) {
		sendShutter("THRUST", "b", (thrustB.buttonB.thrustPercent));
		thrustB.buttonB.eventTrigger = false;
	}
}
public void sendThrustC() {
	if (thrustC.buttonC.eventTrigger) {
		sendShutter("THRUST", "c", (thrustC.buttonC.thrustPercent));
		thrustC.buttonC.eventTrigger = false;
	}
}
public void sendThrustD() {
	if (thrustD.buttonD.eventTrigger) {
		sendShutter("THRUST", "d", (thrustD.buttonD.thrustPercent));
		thrustD.buttonD.eventTrigger = false;
	}
}

public void sendAngleA(){
    if (angleA.eventTrigger) {
		sendShutter("ANGLE", "a", angleA.anglePercent);
		angleA.eventTrigger = false;
	}
}
public void sendAngleB(){
    if (angleB.eventTrigger) {
		sendShutter("ANGLE", "b", angleB.anglePercent);
		angleB.eventTrigger = false;
	}
}
public void sendAngleC(){
    if (angleC.eventTrigger) {
		sendShutter("ANGLE", "c", angleC.anglePercent);
		angleC.eventTrigger = false;
	}
}
public void sendAngleD(){
    if (angleD.eventTrigger) {
		sendShutter("ANGLE", "d", angleD.anglePercent);
		angleD.eventTrigger = false;
	}
}

public void sendAssembly() {
	if (assembly.eventTrigger) {
		sendShutter("ASSEMBLY", "", PApplet.parseInt(assembly.assemblyAngle));
		assembly.eventTrigger = false;
	}
}
//--------------------------------------------------------------
// B_topbar.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- TOP BAR - UPDATE / DRAW ----------
//--------------------------------------------------------------

public void topBarUpdate() {
	if (shutterPage.action && shutterPage.clicked) {
		shutterPage.clicked = true; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = false; dSelectPage.clicked = false;
		shutterPage.action = false;
		settingsMenu = false;
	} else if (focusPage.action && focusPage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = true; formPage.clicked = false; imagePage.clicked = false;  dSelectPage.clicked = false;
		focusPage.action = false;
		settingsMenu = false;
	} else if (formPage.action && formPage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = true; imagePage.clicked = false;  dSelectPage.clicked = false;
		formPage.action = false;
		settingsMenu = false;
	} else if (imagePage.action && imagePage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = true;  dSelectPage.clicked = false;
		imagePage.action = false;
		settingsMenu = false;
	} else if (dSelectPage.action && dSelectPage.clicked) {
		shutterPage.clicked = false; focusPage.clicked = false; formPage.clicked = false; imagePage.clicked = false;  dSelectPage.clicked = true;
		dSelectPage.action = false;
		settingsMenu = false;
	}
}

public void topBarDraw() {
	statusBarDraw();
	settingsBar(0, notchHeight, width, settingsBarHeight, settingsBarStrokeWeight);
	settingsButton(width - settingsBarHeight - buttonStrokeWeight / 2, notchHeight, settingsBarHeight, settingsBarHeight, buttonStrokeWeight); //X adjust
	oscLight("TX", lightWidth / 2, notchHeight + settingsBarStrokeWeight, lightWidth, settingsBarHeight / 2 - settingsBarStrokeWeight, buttonStrokeWeight);
	oscLight("RX", lightWidth / 2, notchHeight + settingsBarStrokeWeight + settingsBarHeight / 2 - settingsBarStrokeWeight, lightWidth, settingsBarHeight / 2 - settingsBarStrokeWeight, buttonStrokeWeight);
}

//--------------------------------------------------------------
// MARK: ---------- SETTINGS - BAR / BUTTON / LIGHT ----------
//--------------------------------------------------------------

public void settingsBar(float _x, float _y, float _w, float _h, float _weight) {
	push();
	fill(EOSBarState);
	noStroke();
	rect(_x, _y - buttonStrokeWeight / 2, _w, _h + buttonStrokeWeight); //Settings Bar Background - Adjusts for Processing

	stroke(shutterOutsideStroke);
	strokeWeight(_weight);
    line(_x, notchHeight, _w, notchHeight); //TOP BAR
    line(_x, _h + notchHeight, _w, _h + notchHeight); //BOTTOM BAR

	pop();

	boolean imagePageTest = false;

	if (!imagePageTest) {
		shutterPage.showPage("SHUTTER", centerX - smallButtonWidth * 1.5f, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
		focusPage.showPage("FOCUS", centerX - smallButtonWidth / 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
		formPage.showPage("FORM", centerX + smallButtonWidth / 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
		dSelectPage.showPage("DS", centerX + smallButtonWidth * 1.5f, (settingsBarHeight / 2) + notchHeight, smallButtonWidth, settingsBarHeight);
	} else {
		shutterPage.showPage("SHUTTER", centerX - (smallButtonWidth / 1.1f) * 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1f, settingsBarHeight);
		focusPage.showPage("FOCUS", centerX - smallButtonWidth / 1.1f, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1f, settingsBarHeight);
		formPage.showPage("FORM", centerX, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1f, settingsBarHeight);
		imagePage.showPage("IMAGE", centerX + smallButtonWidth / 1.1f, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1f, settingsBarHeight);
		dSelectPage.showPage("DS", centerX + (smallButtonWidth / 1.1f) * 2, (settingsBarHeight / 2) + notchHeight, smallButtonWidth / 1.1f, settingsBarHeight);
	}
}

//--------------------------------------------------------------

public void settingsButton(float _x, float _y, float _w, float _h, float _weight) {
	this.settingsX = _x;
	this.settingsY = _y;
	this.settingsWidth = _w;
	this.settingsHeight = _h + notchHeight;
	push();
	rectMode(CENTER);

	stroke(shutterOutsideStroke); //stroke
	if (settingsMenu) {
		fill(white); //fill
	} else {
		fill(black); //fill
	}
	strokeWeight(_weight);
	rect(_x + _w / 2, _y + _h / 2, _w, _h, buttonCorner); //outer

	fill(shutterOutsideStroke);
	circle(_x + _w / 2, _y + _h / 2, (_w / 5) * 2); //circle

	pop();
}

//--------------------------------------------------------------

public void oscLight(String _ID, float _x, float _y, float _w, float _h, float _weight) {
	push();
	rectMode(CENTER);
	_y = _y + _h / 2;
	if (_ID == "TX") {
		stroke(black); //stroke
		strokeWeight(_weight);
		if (oscSendLight) {
			fill(EOSLightGreen); //fill
		} else {
			fill(EOSGreen); //fill
		}
		rect(_x, _y, _w, _h, buttonCorner / 2); //outer
	} else if (_ID == "RX") {
		stroke(black); //stroke
		strokeWeight(_weight);
		if (oscReceiveLight) {
			fill(EOSLightRed); //fill
		} else {
			fill(EOSRed); //fill
		}
		rect(_x, _y, _w, _h, buttonCorner / 2); //outer
	}
	pop();
}

//--------------------------------------------------------------
// MARK: ---------- STATUS BAR DRAW ----------
//--------------------------------------------------------------

public void statusBarDraw() {
	push();
	String amPM = "AM";
	if (hour() > 11) {
		amPM = "PM";
	}
	String hour = str(hour() % 12);
	if (hour.equals("0")) {
		hour = "12";
	}
	String minutes = str(minute());
	if (minute() < 10) {
		minutes = "0" + minutes;
	}
	String time = hour + ":" + minutes + " " + amPM;
	String time24 = str(hour()) + ":" + minutes;

	textAlign(CENTER, CENTER);
	textFont(fontSmall);
	fill(white);

	text(time, width - textWidth(time) / 1.5f, notchHeight / 2); //TIME

	text(headerName, width / 2, notchHeight / 2);

//    string WIFI = "ShuttR" + version;
//    fontSmall.drawString(WIFI,10, notchHeight - fontSmall.stringHeight("WIFI") / 2); //APP NAME

	pop();
}
//--------------------------------------------------------------
// C_keyboard.h && C_keyboard.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

class KEYBOARD {
	String input = "";
	float slide = 1;
	boolean show = false;
	boolean isOffScreen = false;
	boolean enter = false;
	boolean clickedOff = false;

//----------------------------------------------------

	BUTTON enterButton, clearButton, zeroButton, dotButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton;

//--------------------------------------------------------------
// MARK: ---------- OPEN / CLOSE ----------
//--------------------------------------------------------------

	public void open() {
		show = true;
	}

	public void close() {
		show = false;
		clickedOff = false;
		enter = false;
	}

//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

	public void update() {
		if (zeroButton.action) {
			input += "0";
			zeroButton.action = false;
		} else if (oneButton.action) {
			input += "1";
			oneButton.action = false;
		} else if (twoButton.action) {
			input += "2";
			twoButton.action = false;
		} else if (threeButton.action) {
			input += "3";
			threeButton.action = false;
		} else if (fourButton.action) {
			input += "4";
			fourButton.action = false;
		} else if (fiveButton.action) {
			input += "5";
			fiveButton.action = false;
		} else if (sixButton.action) {
			input += "6";
			sixButton.action = false;
		} else if (sevenButton.action) {
			input += "7";
			sevenButton.action = false;
		} else if (eightButton.action) {
			input += "8";
			eightButton.action = false;
		} else if (nineButton.action) {
			input += "9";
			nineButton.action = false;
		} else if (dotButton.action) {
			input += ".";
			dotButton.action = false;
		} else if (clearButton.action) {
			clearButton.action = false;
			if (input.length() > 0) {
				input = input.substring(0, input.length() - 1);
			} else {
				return;
			}
		} else if (enterButton.action) {
			enter = true;
			enterButton.action = false;
		}
	}

//--------------------------------------------------------------

	public void draw() {
		float buttonWidth = smallButtonWidth;
		float buttonPadding = buttonWidth * 1.25f;

		push();

		if (!show) {
			if (slide < 1) {
				slide += 0.05f;
			} else {
				isOffScreen = true;
			}
		} else if (show) {
			if (slide > 0) {
				slide -= 0.05f;
			} else {
				isOffScreen = false;
			}

		}

		constrain(slide, 0, 1);
		translate(0, height * slide);

		push();
		rectMode(CENTER);
		fill(0, 150);
		noStroke();
		rect(guiCenterAlign, rowBottomPadding - buttonHeight * 2.5f, buttonPadding * 3.5f, buttonHeight * 7, buttonCorner * 5);
		pop();

		enterButton.show("ENTER", guiCenterAlign, rowBottomPadding, buttonWidth * 2, buttonHeight, "LARGE");

		clearButton.show("CLEAR", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 1.25f, buttonWidth, buttonHeight, "MEDIUM");
		zeroButton.show("0", guiCenterAlign, rowBottomPadding - buttonHeight * 1.25f, buttonWidth, buttonHeight, "MEDIUM");
		dotButton.show(".", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 1.25f, buttonWidth, buttonHeight, "MEDIUM");

		oneButton.show("1", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 2.5f, buttonWidth, buttonHeight, "MEDIUM");
		twoButton.show("2", guiCenterAlign, rowBottomPadding - buttonHeight * 2.5f, buttonWidth, buttonHeight, "MEDIUM");
		threeButton.show("3", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 2.5f, buttonWidth, buttonHeight, "MEDIUM");

		fourButton.show("4", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 3.75f, buttonWidth, buttonHeight, "MEDIUM");
		fiveButton.show("5", guiCenterAlign, rowBottomPadding - buttonHeight * 3.75f, buttonWidth, buttonHeight, "MEDIUM");
		sixButton.show("6", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 3.75f, buttonWidth, buttonHeight, "MEDIUM");

		sevenButton.show("7", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
		eightButton.show("8", guiCenterAlign, rowBottomPadding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
		nineButton.show("9", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");

		pop();
	}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

	public void touchDown() {
		enterButton.touchDown();

		clearButton.touchDown();
		zeroButton.touchDown();
		dotButton.touchDown();

		oneButton.touchDown();
		twoButton.touchDown();
		threeButton.touchDown();

		fourButton.touchDown();
		fiveButton.touchDown();
		sixButton.touchDown();

		sevenButton.touchDown();
		eightButton.touchDown();
		nineButton.touchDown();

		if (touch.y < (rowBottomPadding - buttonHeight * 2.5f) - (buttonHeight * 4)) {
			clickedOff = true;
		}
	}

//--------------------------------------------------------------
	public void touchUp() {
		enterButton.touchUp();

		clearButton.touchUp();
		zeroButton.touchUp();
		dotButton.touchUp();

		oneButton.touchUp();
		twoButton.touchUp();
		threeButton.touchUp();

		fourButton.touchUp();
		fiveButton.touchUp();
		sixButton.touchUp();

		sevenButton.touchUp();
		eightButton.touchUp();
		nineButton.touchUp();
	}

//--------------------------------------------------------------


}
//--------------------------------------------------------------
// C_keyboard.h && C_overlay.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

class OVERLAY {
	String input = "";
	float slide = 1;
	boolean show = false;
	boolean isOffScreen = false;
	boolean enter = false;
	boolean clickedOff = false;

	boolean clicked;
	float sliderX, sliderY;
	float botLimit, topLimit, defaultY;

	PVector sliderVector;
	boolean eventTrigger = false;

	public void sendOSC() {
		eventTrigger = true;
	}

//----------------------------------------------------

	BUTTON fullButton, levelButton, outButton, minusPercentButton, homeButton, plusPercentButton;
	PImage fader;

//----------------------------------------------------

	public void open() {
		show = true;
		isOffScreen = false;
	}

	public void close() {
		show = false;
		clickedOff = false;
		isOffScreen = true;
		enter = false;
	}

	//--------------------------------------------------------------

	public void setup() {
		botLimit = centerY - assemblyRadius + clickRadius / 2;
		topLimit = centerY + assemblyRadius - clickRadius;
		defaultY = centerY - clickRadius;

		sliderX = guiCenterAlign;

		sliderVector = new PVector(0,0);

		fader = loadImage("Fader.png");
		fader.resize(PApplet.parseInt(clickDiameter), PApplet.parseInt(clickDiameter * 2));
	}

	public void update() {
		sliderY = constrain(sliderY, botLimit, topLimit);
		sliderVector.y = map(sliderY, botLimit, topLimit, 100, 0);

		if (fullButton.action) {
			sliderVector.x = 1;
			sendOSC();
			fullButton.action = false;
		}
		if (levelButton.action) {
			sliderVector.x = 2;
			sendOSC();
			levelButton.action = false;
		}
		if (outButton.action) {
			sliderVector.x = 3;
			sendOSC();
			outButton.action = false;
		}
		if (minusPercentButton.action) {
			sliderVector.x = 4;
			sendOSC();
			minusPercentButton.action = false;
		}
		if (plusPercentButton.action) {
			sliderVector.x = 5;
			sendOSC();
			plusPercentButton.action = false;
		}
		if (homeButton.doubleClicked) {
			sliderVector.x = 6;
			sendOSC();
			homeButton.action = false;
		} else if (homeButton.action) {
			sliderVector.x = 7;
			sendOSC();
			homeButton.action = false;
		}

	}

//--------------------------------------------------------------

	public void draw() {
		if (show) {
			push();

			fullButton.show("FULL", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight, "LARGE");
			levelButton.show("LEVEL", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight, "LARGE");
			outButton.show("OUT", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight, "LARGE");

			minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
			homeButton.show("INTENS.", "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
			plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");

			fill(shutterOutsideStroke);
			noStroke();
			rect(sliderX - assemblyLineWeight / 2, botLimit, assemblyLineWeight, assemblyDiameter - clickRadius, buttonCorner);

			// ----------FADER----------
			translate(sliderX, sliderY);
			image(fader, -fader.width / 2, -fader.height / 2);
			pop();
		}
	}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

	public void touchDown() {
		if (touch.y < row2Padding - buttonHeight / 2) {
			clickedOff = true;
		}

		if (touch.x > sliderX - fader.width / 2 && touch.x < sliderX + fader.width / 2 && touch.y > sliderY - fader.height / 2 && touch.y < sliderY + fader.height / 2) {
			clicked = true;
			sliderVector.x = 0;
		}

		fullButton.touchDown();
		levelButton.touchDown();
		outButton.touchDown();

		minusPercentButton.touchDown();
		homeButton.touchDown();
		plusPercentButton.touchDown();
	}

//--------------------------------------------------------------

	public void touchMoved(boolean fine) {
		if (clicked) {
			if (fine) {
				sliderY += (touch.y - ofGetPreviousMouseY()) / 3;
			} else {
				sliderY += (touch.y - ofGetPreviousMouseY());
			}
			sendOSC();
		}
	}


//--------------------------------------------------------------
	public void touchUp() {
		clicked = false;
		fullButton.touchUp();
		levelButton.touchUp();
		outButton.touchUp();

		minusPercentButton.touchUp();
		homeButton.touchUp();
		plusPercentButton.touchUp();
	}

	public void touchDoubleTap() {
		homeButton.touchDoubleTap();
	}

//--------------------------------------------------------------

	public void incomingOSC(float value) {
		if (!clicked) {
			sliderY = map(value, 100, 0, botLimit, topLimit);
		}
	}

}
//--------------------------------------------------------------
// D_bank.h && D_bank.mm
//--------------------------------------------------------------
class BANK {
	int ID;
	int totalSelects;
	float buttonSize, padding, align, oneAlign, twoAlign, middleAlign, threeAlign, fourAlign, fiveAlign;
	float directSelectSize;
	int colorSelect;
	String selected;
	float bankHeight;

	StringList bankText = new StringList();
	StringList bankNumber = new StringList();

	PVector dSelectVector = new PVector(0, 0, 0);
	boolean dSelectFlexi = false;
	boolean vectorEventTrigger = false;

	PVector dSelectPage = new PVector(0, 0);
	boolean pageEventTrigger = false;

	public void sendOSC() {
		vectorEventTrigger = true;
	}

	public void sendPage() {
		pageEventTrigger = true;
	}

	float totalPalettes;
	ArrayList<BUTTON> palette = new ArrayList<BUTTON>();
	ArrayList<BUTTON> directSelect = new ArrayList<BUTTON>();

	BUTTON button = new BUTTON();
	BUTTON quickButton = new BUTTON();
	BUTTON customButton = new BUTTON();
	BUTTON leftButton = new BUTTON();
	BUTTON rightButton = new BUTTON();

//--------------------------------------------------------------
	public void setup(int _ID) {
		this.ID = _ID;
		buttonSize = smallButtonWidth / 1.1f;
		directSelectSize = (((height - notchHeight) / 2) / 4) - ((buttonSize * 2) / 5);
		if (directSelectSize > buttonSize) {
			directSelectSize = buttonSize;
		}
		bankHeight = buttonSize * 1.1f + directSelectSize * 4;


		oneAlign = guiCenterAlign - buttonSize * 2.2f;
		twoAlign = guiCenterAlign - buttonSize * 1.1f;
		middleAlign = guiCenterAlign;
		fourAlign = guiCenterAlign + buttonSize * 1.1f;
		fiveAlign = guiCenterAlign + buttonSize * 2.2f;

		selected = "DIRECT";
		colorSelect = black;

		totalSelects = 20;
		for (int i = 0; i <= totalSelects; i++) {
			directSelect.add(new BUTTON());
			bankText.append("");
			bankNumber.append("");
		}
		totalPalettes = 12;
		for (int i = 0; i <= totalPalettes; i++) {
			palette.add(new BUTTON());
		}

		dSelectVector.x = ID; //SET BANK ID FOR EVENT LISTENER
	}

	//--------------------------------------------------------------
	public void update() {
		if (leftButton.action) {
			dSelectPage.set(ID, -1);
			clearBank();
			sendPage();
			leftButton.action = false; quickButton.clicked = false;
		} else if (rightButton.action) {
			dSelectPage.set(ID, 1);
			clearBank();
			sendPage();
			rightButton.action = false; quickButton.clicked = false;
		}

		if (palette.get(12).action) { //FLEXI
			if (palette.get(12).clicked) {
				dSelectFlexi = true;
			} else {
				dSelectFlexi = false;
			}
			clearBank();
			sendOSC();
			palette.get(12).action = false;
		}

		for (int i = 0; i <= totalSelects; i++) {
			if (directSelect.get(i).action) {
				dSelectVector.y = 0; //RESET PARAMETER
				dSelectVector.z = i + 1;
				sendOSC();
				directSelect.get(i).action = false;
			}
		}

		quickSelectAction();
	}

	//--------------------------------------------------------------
	public void draw(float _padding) {
		this.padding = _padding;
		leftButton.show("<", oneAlign, padding, buttonSize, buttonHeight, "MEDIUM");

		quickButton.show(selected, "SELECTS", middleAlign, padding, genericButtonWidth * 2, buttonHeight, "MEDIUM", colorSelect);

		rightButton.show(">", fiveAlign, padding, buttonSize, buttonHeight, "MEDIUM");

		int x = 0;
		float y = 0.9f;
		for (int i = 0; i < totalSelects; i++) {
			x = i % 5;
			switch (x) {
			case 0: align = oneAlign; break;
			case 1: align = twoAlign; break;
			case 2: align = middleAlign; break;
			case 3: align = fourAlign; break;
			case 4: align = fiveAlign; break;
			}
			directSelect.get(i).showDS(bankText.get(i), bankNumber.get(i), align, padding + directSelectSize * (y + y * 0.1f), buttonSize, directSelectSize, colorSelect);
			if (x == 4) {
				y++;
			}
		}

		if (quickButton.clicked) {
			push();
			fill(EOSBackground, 150);
			noStroke();
			rect(0, padding + buttonSize / 2 - buttonStrokeWeight, width, padding + (buttonSize * 3.3f) + buttonSize / 2 + buttonStrokeWeight);
			pop();
		}
	}

//--------------------------------------------------------------

	public void quickSelectsShow() {
		float DSRowOne = padding + buttonSize * 1.5f;

		palette.get(0).show("CHAN", oneAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSChannel);
		palette.get(1).show("GROUP", twoAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSGroup);
		palette.get(2).show("INTENS.", "PALETTE", middleAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSIntensity);
		palette.get(3).show("FOCUS", "PALETTE", fourAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSFocus);
		palette.get(4).show("COLOR", "PALETTE", fiveAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSColor);

		palette.get(5).show("BEAM", "PALETTE", oneAlign, DSRowOne + buttonSize * 1.1f, buttonSize, buttonSize, "SMALL", EOSBeam);
		palette.get(6).show("PRESET", twoAlign, DSRowOne + buttonSize * 1.1f, buttonSize, buttonSize, "SMALL", EOSPreset);
		palette.get(7).show("MACRO", middleAlign, DSRowOne + buttonSize * 1.1f, buttonSize, buttonSize, "SMALL", EOSMacro);
		palette.get(8).show("EFFECTS", fourAlign, DSRowOne + buttonSize * 1.1f, buttonSize, buttonSize, "SMALL", EOSfx);
		palette.get(9).show("SNAP", fiveAlign, DSRowOne + buttonSize * 1.1f, buttonSize, buttonSize, "SMALL", EOSSnap);

		palette.get(10).show("MAGIC", "SHEET", oneAlign, DSRowOne + buttonSize * 2.2f, buttonSize, buttonSize, "SMALL", EOSMagic);
		palette.get(11).show("SCENE", twoAlign, DSRowOne + buttonSize * 2.2f, buttonSize, buttonSize, "SMALL", EOSScene);

		palette.get(12).show("FLEXI", fourAlign, DSRowOne + buttonSize * 2.2f, buttonSize * 2, buttonSize, "MEDIUM");
	}

//--------------------------------------------------------------

	public void quickSelectAction() {

		for (int i = 0; i <= totalPalettes - 1; i++) {
			if (palette.get(i).action) {
				clearBank();
				quickButton.clicked = false;
				palette.get(i).action = false;
				for (int j = i + 1; j <= totalPalettes - 1; j++) { //ITERATE FORWARDS AND CLICK OFF
					palette.get(j).clicked = false;
				}
				for (int j = i - 1; j >= 0; j--) { //ITERATE BACKWARDS AND CLICK OFF
					palette.get(j).clicked = false;
				}
				dSelectVector.z = 0; //RESET BUTTON ID
				switch (i) {
				case 0:
					dSelectVector.y = 1;
					selected = "CHANNEL"; colorSelect = EOSChannel; break;
				case 1:
					dSelectVector.y = 2;
					selected = "GROUP"; colorSelect = EOSGroup; break;
				case 2:
					dSelectVector.y = 3;
					selected = "INTENSITY"; colorSelect = EOSIntensity; break;
				case 3:
					dSelectVector.y = 4;
					selected = "FOCUS"; colorSelect = EOSFocus; break;
				case 4:
					dSelectVector.y = 5;
					selected = "COLOR"; colorSelect = EOSColor; break;
				case 5:
					dSelectVector.y = 6;
					selected = "BEAM"; colorSelect = EOSBeam; break;
				case 6:
					dSelectVector.y = 7;
					selected = "PRESET"; colorSelect = EOSPreset; break;
				case 7:
					dSelectVector.y = 8;
					selected = "MACRO"; colorSelect = EOSMacro;  break;
				case 8:
					dSelectVector.y = 9;
					selected = "EFFECT"; colorSelect = EOSfx;  break;
				case 9:
					dSelectVector.y = 10;
					selected = "SNAP"; colorSelect = EOSSnap; break;
				case 10:
					dSelectVector.y = 11;
					selected = "MAGIC SHEET"; colorSelect = EOSMagic; break;
				case 11:
					dSelectVector.y = 12;
					selected = "SCENE"; colorSelect = EOSScene; break;
				}
				sendOSC();
			}
		}

	}

	//--------------------------------------------------------------
	public void touchDown() {
		leftButton.touchDown(); quickButton.touchDown(true); rightButton.touchDown();
		if (quickButton.clicked) {
			for (int i = 0; i <= totalPalettes - 1; i++) {
				palette.get(i).touchDown(false);
			}
			palette.get(12).touchDown(true); //FLEXI
		} else {
			for (int i = 0; i <= totalSelects; i++) {
				directSelect.get(i).touchDown();
			}
		}
	}

//--------------------------------------------------------------
	public void touchMoved() {

	}

//--------------------------------------------------------------
	public void touchUp() {
		leftButton.touchUp(); rightButton.touchUp();
		if (!quickButton.clicked) {
			for (int i = 0; i <= totalSelects; i++) {
				directSelect.get(i).touchUp();
			}
		}
	}

//--------------------------------------------------------------
	public void touchDoubleTap() {

	}

//------------------------PROCESSING ONLY-----------------------------

	public void clearBank() {
		for (int i = 0; i <= 20; i++) {
			bankText.set(i,"");
			bankNumber.set(i,"");
		}
	}


}
//--------------------------------------------------------------
// D_button.h && D_button.mm
//--------------------------------------------------------------

class BUTTON {
    float x, y, w, h;
    boolean clicked = false;
    boolean doubleClicked = false;
    boolean action = false;
    boolean released = false;

//--------------------------------------------------------------
// MARK: ----------PAGE BUTTONS----------
//--------------------------------------------------------------

    public void showPage(String _ID, float _x, float _y, float _w, float _h) {
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        int clickColor = white;

        if (this.clicked && !settingsMenu) {
            fill(buttonActive);
        } else {
            fill(black);
            clickColor = color(175, 175, 175);
        }
        stroke(shutterOutsideStroke);
        strokeWeight(buttonStrokeWeight);
        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, CENTER);
            textFont(fontSmall);
            fill(white);

            if (_ID != "DS") {
                fill(EOSBackground);
                text(_ID, _x + textWidth(_ID) / 50, _y + smallTextSize / 25); //SHADOW
                fill(clickColor);
                text(_ID, _x, _y); //INPUT
            } else {
                fill(EOSBackground);
                text("DIRECT", _x + textWidth("DIRECT") / 50, _y - smallTextSize / 2.25f); //SHADOW
                text("SELECTS", _x + textWidth("SELECTS") / 50, _y + smallTextSize / 1.75f); //SHADOW
                fill(clickColor);
                text("DIRECT", _x, _y - smallTextSize / 2); //INPUT
                text("SELECTS", _x, _y + smallTextSize / 2); //INPUT
            }

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------ONE LINE----------
//--------------------------------------------------------------

    public void show(String _ID, float _x, float _y, float _w, float _h, String _size) { //ONE TEXT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);

        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, CENTER);
            fill(white);

            if (_size == "LARGE") {
                textFont(fontLarge);
            } else if (_size == "MEDIUM") {
                textFont(fontMedium);
            } else if (_size == "SMALL") {
                textFont(fontSmall);
            }
            text(_ID, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------ONE LINE - WITH COLOR----------
//--------------------------------------------------------------

    public void show(String _ID, float _x, float _y, float _w, float _h, String _size, int _color) { //ONE TEXT WITH COLOR
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(_color);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, CENTER);
            fill(white);

            if (_size == "LARGE") {
                textFont(fontLarge);
            } else if (_size == "MEDIUM") {
                textFont(fontMedium);
            } else if (_size == "SMALL") {
                textFont(fontSmall);
            }
            text(_ID, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------TWO LINE----------
//--------------------------------------------------------------

    public void show(String _ID, String _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);

        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            fill(white);

            translate(0, smallTextSize / 4);

            textAlign(CENTER, BOTTOM);
            textFont(fontMedium);
            text(_ID, _x, _y); //INPUT

            textAlign(CENTER, TOP);
            textFont(fontSmall);
            text(_ID2, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------TWO LINE - WITH COLOR----------
//--------------------------------------------------------------

    public void show(String _ID, String _ID2, float _x, float _y, float _w, float _h, String _size, int _color) { //DOUBLE TEXT WITH COLOR
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(_color);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(CENTER, BOTTOM);
            fill(white);

            if (_size == "LARGE") {
                textFont(fontLarge);
            } else if (_size == "MEDIUM") {
                translate(0, smallTextSize / 4);
                textFont(fontMedium);
            } else if (_size == "SMALL") {
                textFont(fontSmall);
            }
            text(_ID, _x, _y); //INPUT

            textAlign(CENTER, TOP);
            textFont(fontSmall);
            text(_ID2, _x, _y); //INPUT

        } catch (Exception e) {

        }

        pop();
    }

//--------------------------------------------------------------
// MARK: ----------TWO LINE (WITH BOTTOM)----------
//--------------------------------------------------------------

    public void showBig(String _ID, String _ID2, float _x, float _y, float _w, float _h) { //DOUBLE TEXT WITH BOTTOM
        this.x = _x;
        this.y = _y + _h / 2;
        this.w = _w;
        this.h = _h * 1.5f;

        push();
        rectMode(CENTER);
        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y + _h / 1.5f, _w, _h, buttonCorner); //BOTTOM BUTTON

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner); //TOP BUTTON

        try {

            textAlign(CENTER, CENTER);
            fill(white);
            textFont(fontMedium);

            text(_ID, _x, _y); //INPUT

            text(_ID2, _x, _y + _h / 1.15f); //INPUT / - mediumTextSize / 2.5

        } catch (Exception e) {

        }


        pop();
    }

//--------------------------------------------------------------
// MARK: ----------IMAGE BUTTON----------
//--------------------------------------------------------------

//--------------------------------------------------------------
// MARK: ----------INTENSITY----------
//--------------------------------------------------------------

    public void showInt(String _ID, float _x, float _y, float _w, float _h) { //ONE TEXT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(EOSState);
        strokeWeight(buttonStrokeWeight);

        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {
            pushStyle();
            textAlign(CENTER, CENTER);
            textFont(fontMedium);
            colorMode(HSB, 255, 255, 255, 255);

            int intensityColor = color(channelHue, channelSat, 100);
            fill(intensityColor);

            text(_ID, _x + textWidth(_ID) / 100, _y + (_h / 4) + smallTextSize / 25); //SHADOW

            intensityColor = color(channelHue, channelSat, 255);
            fill(intensityColor);

            text(_ID, _x, _y + _h / 4); //INPUT

            popStyle();

        } catch (Exception e) {

        }
        pop();
    }

//--------------------------------------------------------------
// MARK: ----------DIRECT SELECT----------
//--------------------------------------------------------------

    public void showDS(String _ID, String _ID2, float _x, float _y, float _w, float _h, int _color) { //DIRECT SELECT
        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;

        push();
        rectMode(CENTER);

        stroke(_color);
        strokeWeight(buttonStrokeWeight);
        if (this.clicked) {
            fill(buttonActive);
        } else {
            fill(black);
        }

        rect(_x, _y, _w, _h, buttonCorner);

        try {

            textAlign(RIGHT, BOTTOM);
            fill(white);
            textFont(fontTiny);

            text(_ID2, _x + (_w / 2.25f), _y + (_h / 2.25f)); //NUMBER

            textAlign(CENTER, CENTER);
            textFont(fontDS);

            int maxLineLength = 6;
            String dName = _ID;
            StringList dNames = new StringList();

            if (textWidth(dName) < w - buttonStrokeWeight / 2) {
                dNames.append(dName);
            } else {
                if (dName.indexOf(' ') != -1) { //IF NAME HAS A SPACE
                    int numSpaces = count(dName, ' ');
                    int letterCount = 0;
                    int indexValueEnd = dName.indexOf(" ");

                    while (numSpaces > 0) {
                        indexValueEnd = dName.indexOf(" ");
                        letterCount += dName.length();
                        dNames.append(dName.substring(0, indexValueEnd));
                        dName = dName.substring(indexValueEnd + 1);
                        if (textWidth(dName) < w - buttonStrokeWeight / 2) {
                            dNames.append(dName);
                            numSpaces -= count(dName, ' ');
                        }
                        numSpaces--;
                    }
                } else { //IF NAME DOES NOT HAVE SPACE IN IT
                    dNames.append(dName.substring(0,maxLineLength));
                }
            }

            if (dNames.size() == 1) {
                text(dNames.get(0), _x, _y); //NAME
            } else if (dNames.size() == 2) {
                text(dNames.get(0), _x, _y - dsTextSize / 2); //NAME
                text(dNames.get(1), _x, _y + dsTextSize / 2); //NAME
            } else if (dNames.size() == 3) {
                text(dNames.get(0), _x, _y - dsTextSize); //NAME
                text(dNames.get(1), _x, _y); //NAME
                text(dNames.get(2), _x, _y + dsTextSize); //NAME
            } else if (dNames.size() > 3) {
                push();
                translate(0, - dsTextSize / 2);
                text(dNames.get(0), _x, _y - dsTextSize * 1.5f); //NAME
                text(dNames.get(1), _x, _y - dsTextSize / 2); //NAME
                text(dNames.get(2), _x, _y + dsTextSize / 2); //NAME
                text(dNames.get(3), _x, _y + dsTextSize * 1.5f); //NAME
                pop();
            }

        } catch (Exception e) {

        }

        pop();
    }
//------------------------PROCESSING ONLY-----------------------------
    public int count(String string, char search) {
        int count = 0;
        int startIndex = 0;
        while (string.indexOf(search, startIndex) != -1) { //COUNT NUMBER OF SPACES
            startIndex = string.indexOf(search, startIndex) + 1;
            count += 1;
        }
        return count;
    }


//--------------------------------------------------------------
// MARK: ----------EVENTS----------
//--------------------------------------------------------------

    public void touchDown() {
        if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
            this.clicked = true;
            this.action = true;
        }
    }

    //--------------------------------------------------------------
    public void touchDown(boolean toggle) { //TOGGLE
        if (touch.x > x - w / 2 && touch.x < x + w / 2 && touch.y > y - h / 2 && touch.y < y + h / 2) {
            if (toggle) {
                this.clicked = !clicked;
            } else {
                this.clicked = true;
            }
            this.action = true;
        }
    }

//--------------------------------------------------------------
    public void touchUp() {
        if (clicked) {
            this.released = true;
        }
        this.clicked = false;
        this.doubleClicked = false;
    }

//--------------------------------------------------------------
    public void touchDoubleTap() {
        this.doubleClicked = true;
    }
//--------------------------------------------------------------




}
//--------------------------------------------------------------
// D_encoder.h && D_encoder.mm
//--------------------------------------------------------------

class ENCODER {
	PImage encoder;
	String parameter;
	float currentPos, lastPos = 0;
	float posX, posY;
	float newTick, oldTick;
	boolean clicked = false;
	PVector currentTouch, prevTouch, center;

	//--------------------------------------------------------------

	float encoderOutput = 0;
	boolean eventTrigger = false;

	public void sendOSC() {
		eventTrigger = true;
	}

	//--------------------------------------------------------------

	public void setup(float _size) {
		encoder = loadImage("Encoder.png");
		encoder.resize(PApplet.parseInt(_size), PApplet.parseInt(_size));
		currentTouch = new PVector(0, 0);
		prevTouch = new PVector(0, 0);
		center = new PVector(centerX, centerY);
	}

	//--------------------------------------------------------------
	public void draw(float _x, float _y) {
		this.posX = _x;
		this.posY = _y;
		push();
		translate(posX, posY);
		rotate(currentPos + radians(90));
		image(encoder, - encoder.width / 2, - encoder.height / 2);
		pop();
	}

//--------------------------------------------------------------
// MARK: ----------ACTIONS----------
//--------------------------------------------------------------

	public void touchDown() {
		if (dist(touch.x, touch.y, posX, posY) < encoder.width / 2) {
			this.clicked = true;
		}
	}

//--------------------------------------------------------------
	public void touchMoved() {
		if (this.clicked) {
			currentTouch.x = touch.x; currentTouch.y = touch.y;
			prevTouch.x = ofGetPreviousMouseX(); prevTouch.y = ofGetPreviousMouseY();

			float angleOld = PVector.sub(prevTouch, center).heading();
			float angleNew = PVector.sub(currentTouch, center).heading();

			currentPos = angleNew; //ROTATE ENCODER

			float diff = angleNew - angleOld;

			if (diff > 1) {
				diff = 0;
			} else if (diff > PI) {
				diff = TWO_PI - diff;
			} else if (diff < -PI) {
				diff = TWO_PI + diff;
			}

			if (diff > 0) { //CLOCKWISE
				encoderOutput = 1;
			} else if (diff < 0) { //COUNTER-CLOCKWISE
				encoderOutput = -1;
			} else {
				encoderOutput = 0;
			}

			newTick += degrees(diff);

			int tickGate = 3;
			if (newTick > oldTick + tickGate || newTick < oldTick - tickGate) {
				oldTick = newTick;
				sendOSC();
			}
		}
	}

//--------------------------------------------------------------
	public void touchUp() {
		this.clicked = false;
	}

//--------------------------------------------------------------
	public void touchDoubleTap() {

	}


}
//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------ANGLE_HANDLE----------
//--------------------------------------------------------------

class ANGLE_HANDLE {

	ANGLE_BUTTON buttonA, buttonB, buttonC, buttonD;

	float offset, rotateOffset, rotateAngle, x, y, diff;
	float magicNumber; //THIS MAGIC NUMBER MUST BE FOUND
	String ID;
	boolean clicked = false;
	boolean doubleClicked = false;

	// ofVec3f angleVec;

	float anglePercent = 0;
	boolean eventTrigger = false;

	public void sendOSC() {
		eventTrigger = true;
	}

//--------------------------------------------------------------

	public void setup(String _ID) {
		this.ID = _ID;
		if (ID == "a") {
			rotateOffset = radians(-90);
		} else if (ID == "b") {
			rotateOffset = radians(0);
		} else if (ID == "c") {
			rotateOffset = radians(90);
		} else if (ID == "d") {
			rotateOffset = radians(180);
		}
		magicNumber = radians(clickRadius / 3.5f); //THIS MAGIC NUMBER MUST BE FOUND // clickRadius / 5.5

		buttonA = new ANGLE_BUTTON(); buttonB = new ANGLE_BUTTON(); buttonC = new ANGLE_BUTTON(); buttonD = new ANGLE_BUTTON();
	}

//--------------------------------------------------------------

	public void update() {
		push();
		rotate(rotateAngle);

		float rotateX = cos((rotation) + rotateOffset + (rotateAngle));
		float rotateY = sin((rotation) + rotateOffset + (rotateAngle));

		this.x = centerX + rotateX * assemblyRadius;
		this.y = centerY + rotateY * assemblyRadius;

		if (this.ID == "a") {
			translate(0, -assemblyRadius);
			buttonA.draw("a", rotateAngle);
		} else if (this.ID == "b") {
			translate(assemblyRadius, 0);
			buttonB.draw("b", rotateAngle);
		} else if (this.ID == "c") {
			translate(0, assemblyRadius);
			buttonC.draw("c", rotateAngle);
		} else if (this.ID == "d") {
			translate(-assemblyRadius, 0);
			buttonD.draw("d", rotateAngle);
		}
		pop();

		calculateAngle();
	}

	//--------------------------------------------------------------

	public void frameDisplay(float _thrust) {
		push();
		translate(centerX, centerY);

		float rotateAngleBot = radians(-45) + magicNumber;
		float rotateAngleTop = radians(45) - magicNumber;

		float rotateAngleReal = map(rotateAngle, rotateAngleBot, rotateAngleTop, -45, 45);

		rotate(radians(rotateAngleReal) + rotation);

		if (this.ID == "a") {
			buttonA.frameShow(_thrust);
		} else if (this.ID == "b") {
			buttonB.frameShow(_thrust);
		} else if (this.ID == "c") {
			buttonC.frameShow(_thrust);
		} else if (this.ID == "d") {
			buttonD.frameShow(_thrust);
		}
		pop();
	}

	//--------------------------------------------------------------

	public void calculateAngle() {
		float rotateAngleBot = radians(-45) + magicNumber;
		float rotateAngleTop = radians(45) - magicNumber;
		rotateAngle = constrain(rotateAngle, rotateAngleBot, rotateAngleTop);

		anglePercent = map(rotateAngle, rotateAngleBot, rotateAngleTop, (45), (-45));
	}

//--------------------------------------------------------------

	public void touchDown() {
		if (dist(touch.x, touch.y, x, y) < clickRadius) {
			this.clicked = true;
		}
	}

//--------------------------------------------------------------

	public void touchMoved(boolean fine) {
		if (clicked) {
			ignoreOSC = true;

			int fineAdjust = 500; //5
			if (fine) {
				fineAdjust = 2000; //20
			}

			if (ID == "a") {
				rotateAngle += (cos((rotation)) * (touch.x - ofGetPreviousMouseX()) + sin((rotation)) * (touch.y - ofGetPreviousMouseY())) / fineAdjust;
			} else if (ID == "b") {
				rotateAngle += (cos((rotation)) * (touch.y - ofGetPreviousMouseY()) + sin((rotation)) * (touch.x - ofGetPreviousMouseX())) / fineAdjust;
			} else if (ID == "c") {
				rotateAngle -= (cos((rotation)) * (touch.x - ofGetPreviousMouseX()) + sin((rotation)) * (touch.y - ofGetPreviousMouseY())) / fineAdjust;
			} else if (ID == "d") {
				rotateAngle -= (cos((rotation)) * (touch.y - ofGetPreviousMouseY()) + sin((rotation)) * (touch.x - ofGetPreviousMouseX())) / fineAdjust;

			}
			sendOSC();
		}
		calculateAngle();
	}

//--------------------------------------------------------------
	public void touchUp() {
		this.clicked = false;
		this.doubleClicked = false;
	}

//--------------------------------------------------------------

	public void touchDoubleTap() {
		if (dist(touch.x, touch.y, x, y) < clickRadius) {
			this.doubleClicked = true;
			rotateAngle = 0;
			sendOSC();
		}
	}

//--------------------------------------------------------------
// MARK: ----------ANGLE_BUTTON----------
//--------------------------------------------------------------

	class ANGLE_BUTTON {
		float position = 1; // The position of the slider between 0 and 1
		String ID;
		float rotateAngle;

//--------------------------------------------------------------

		public void draw(String _ID, float _rotateAngle) {
			this.ID = _ID;
			this.rotateAngle = _rotateAngle;

			String showID = "";
			if (_ID == "a") {
				showID = "A";
			} else if (_ID == "b") {
				showID = "B";
			} else if (_ID == "c") {
				showID = "C";
			} else if (_ID == "d") {
				showID = "D";
			}

			stroke(shutterFrameStroke);
			strokeWeight(angleWeight);
			fill(EOSBlue);
			circle(0, 0, clickDiameter);

			rotate((-rotateAngle) - rotation);

			textAlign(CENTER, CENTER);
			textFont(fontMedium);
			fill(white);

			text(showID, - mediumTextSize / 15, - mediumTextSize / 15);
		}

		public void frameShow(float _thrust) {
			push();
			rectMode(CENTER);
			float thrustOffset = map(_thrust, clickDiameter / assemblyRadius, 1, 1, 0);

			float shutterWidth = assemblyDiameter + outsideWeight * 2;
			float shutterHeight = assemblyRadius + outsideWeight;

			stroke(shutterFrameStroke);
			strokeWeight(shutterStrokeWeight);
			fill(shutterFrameFill);

			if (ID == "a") {
				translate(0, - assemblyDiameter + assemblyRadius / 2);
				rect(0, assemblyRadius * thrustOffset, shutterWidth, shutterHeight);
			} else if (ID == "b") {
				translate(assemblyDiameter - assemblyRadius / 2, 0);
				rect(-assemblyRadius * thrustOffset, 0, shutterHeight, shutterWidth);
			} else if (ID == "c") {
				translate(0, assemblyDiameter - assemblyRadius / 2);
				rect(0, -assemblyRadius * thrustOffset, shutterWidth, shutterHeight);
			} else if (ID == "d") {
				translate(- assemblyDiameter + assemblyRadius / 2, 0);
				rect(assemblyRadius * thrustOffset, 0, shutterHeight, shutterWidth);
			}

			pop();
		}

	}
}
//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------ASSEMBLY----------
//--------------------------------------------------------------

class ASSEMBLY_HANDLE {

	float frameX, frameY, defaultX, botLimit, topLimit;
	boolean clicked = false;
	boolean doubleClicked = false;

	float assemblyAngle = 0;
	boolean eventTrigger = false;

	public void sendOSC() {
		eventTrigger = true;
	}

//--------------------------------------------------------------

	public void setup() {
		frameX = centerX;
		frameY = centerY + assemblyRadius + clickDiameter * 1.5f;
		defaultX = frameX;
		botLimit = centerX - assemblyRadius;
		topLimit = centerX + assemblyRadius;
	}

//--------------------------------------------------------------

	public void update() {
		frameX = constrain(frameX, botLimit, topLimit);
		rotation = map(frameX, botLimit, topLimit, radians(45), radians(-45));

		push();

		// ----------HORIZONTAL LINE----------
		noFill();
		stroke(shutterOutsideStroke);
		strokeWeight(assemblyLineWeight);
		rect(botLimit, frameY - assemblyLineWeight / 2, assemblyDiameter, assemblyLineWeight, buttonCorner);

		// ----------VERTICAL LINE----------
		stroke(shutterOutsideStroke);
		rect(centerX - assemblyLineWeight / 2, frameY - clickRadius / 2, assemblyLineWeight, clickRadius, buttonCorner);

		// ----------BUTTON----------
		fill(shutterOutsideStroke);
		stroke(shutterFrameStroke);
		strokeWeight(assemblyButtonWeight);
		circle(frameX, frameY, clickDiameter);

		pop();
	}

//--------------------------------------------------------------

	public void incomingOSC(float value) {
		frameX = map(value, -50, 50, botLimit, topLimit);
	}

//--------------------------------------------------------------

	public void touchDown() {
		if (dist(touch.x, touch.y, frameX, frameY) < clickRadius) {
			this.clicked = true;
			ignoreOSC = true;
		}
	}

//--------------------------------------------------------------

	public void touchMoved(boolean fine) {
		if (clicked) {
			if (fine) {
				frameX += (touch.x - ofGetPreviousMouseX()) / 3;
			} else {
				frameX += (touch.x - ofGetPreviousMouseX());
			}
			assemblyAngle = map(frameX, botLimit, topLimit, -50, 50);

			sendOSC();
		}
	}

//--------------------------------------------------------------

	public void touchUp() {
		this.clicked = false;
		this.doubleClicked = false;
	}

//--------------------------------------------------------------

	public void touchDoubleTap() {
		if (dist(touch.x, touch.y, frameX, frameY) < clickRadius) {
			this.doubleClicked = true;
			rotation = 0;
			frameX = defaultX;
			assemblyAngle = 0;

			sendOSC();
		}
	}

}
//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------THRUST_HANDLE----------
//--------------------------------------------------------------

class THRUST_HANDLE {
	THRUST_BUTTON buttonA, buttonB, buttonC, buttonD;

	float rotateOffset, sliderX, sliderY, diff, _thrustDiameter;
	String ID;
	boolean clicked = false;
	boolean doubleClicked = false;

//--------------------------------------------------------------

	public void setup(String _ID) {
		this.ID = _ID;
		if (ID == "a") {
			rotateOffset = radians(-90);
		} else if (ID == "b") {
			rotateOffset = radians(0);
		} else if (ID == "c") {
			rotateOffset = radians(90);
		} else if (ID == "d") {
			rotateOffset = radians(180);
		}

		buttonA = new THRUST_BUTTON(); buttonB = new THRUST_BUTTON(); buttonC = new THRUST_BUTTON(); buttonD = new THRUST_BUTTON();

	}

//--------------------------------------------------------------


	public void update() {
		_thrustDiameter = thrustDiameter * 1.5f;
		push();
		if (this.ID == "a") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset))  * buttonA.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset))  * buttonA.position * _thrustDiameter;
			translate(0, - buttonA.position * _thrustDiameter);
			buttonA.draw(this.ID, (rotateOffset));
		} else if (this.ID == "b") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset)) * buttonB.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset)) * buttonB.position * _thrustDiameter;
			translate(buttonB.position * _thrustDiameter, 0);
			buttonB.draw(this.ID, (rotateOffset));
		} else if (this.ID == "c") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset)) * buttonC.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset)) * buttonC.position * _thrustDiameter;
			translate(0, buttonC.position * _thrustDiameter);
			buttonC.draw(this.ID, (rotateOffset));
		} else if (this.ID == "d") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset)) * buttonD.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset)) * buttonD.position * _thrustDiameter;
			translate(- buttonD.position * _thrustDiameter, 0);
			buttonD.draw(this.ID, (rotateOffset));
		}
		pop();
	}

//--------------------------------------------------------------

	public void touchDown() {
		if (dist(touch.x, touch.y, this.sliderX, this.sliderY) < clickRadius) {
			this.clicked = true;
			ignoreOSC = true;
		}
	}

//--------------------------------------------------------------

	public void touchMoved(boolean fine) {
		if (fine) {
			this.diff = (cos((rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin((rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY())) / 6;
		} else {
			this.diff = cos((rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin((rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY());
		}
		if (this.clicked) {
			if (this.ID == "a") {
				buttonA.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			} else if (this.ID == "b") {
				buttonB.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			} else if (this.ID == "c") {
				buttonC.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			} else if (this.ID == "d") {
				buttonD.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			}
		}
	}

//--------------------------------------------------------------

	public void touchUp() {
		this.clicked = false;
		this.doubleClicked = false;
	}

//--------------------------------------------------------------

	public void touchDoubleTap() {
		if (dist(touch.x, touch.y, this.sliderX, this.sliderY) < clickRadius) {
			this.doubleClicked = true;
			if (ID == "a") {
				buttonA.position = 1;
				buttonA.thrustPercent = 0;
				buttonA.sendOSC();
			} else if (ID == "b") {
				buttonB.thrustPercent = 0;
				buttonB.position = 1;
				buttonB.sendOSC();
			} else if (ID == "c") {
				buttonC.position = 1;
				buttonC.thrustPercent = 0;
				buttonC.sendOSC();
			} else if (ID == "d") {
				buttonD.position = 1;
				buttonD.thrustPercent = 0;
				buttonD.sendOSC();
			}
		}
	}
}

//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------THRUST_BUTTON----------
//--------------------------------------------------------------

class THRUST_BUTTON {

	float position = 1; // The position of the slider between 0 and 1
	String ID;
	float rotateAngle;

	float thrustPercent = 0;
	boolean eventTrigger = false;

	public void sendOSC() {
		this.eventTrigger = true;
	}

//--------------------------------------------------------------

	public void draw(String _ID, float _rotateAngle) {
		this.ID = _ID;
		this.rotateAngle = _rotateAngle;

		String showID = "";
		if (_ID == "a") {
			showID = "A";
		} else if (_ID == "b") {
			showID = "B";
		} else if (_ID == "c") {
			showID = "C";
		} else if (_ID == "d") {
			showID = "D";
			rotateAngle -= 5;
		}

		stroke(shutterFrameStroke);
		strokeWeight(angleWeight);
		fill(EOSBlue);
		circle(0, 0, clickDiameter);

		rotate(radians(-rotateAngle) - rotation);

		textAlign(CENTER, CENTER);
		textFont(fontMedium);
		fill(white);

		text(showID,- mediumTextSize / 15, - mediumTextSize / 15);
	}

	public void addOffset(float _diff) {
		float topLimit = clickDiameter / assemblyRadius;
		position = constrain(position + _diff, topLimit, 1);
		thrustPercent = map(position, topLimit, 1, 100, 0);

		sendOSC();
	}

	public void angleLimit(float _angleRotateLimit) {
		float topLimit = clickDiameter / assemblyRadius;
		int angle = PApplet.parseInt(abs(_angleRotateLimit));
		float angleLimit = 0;

		//TODO: FIX THIS IMPLEMENTATION, WHAT IS SPECIAL ABOUT 0.375? (PERCENTAGE OF THRUST)
		switch (angle) {
		case 0:
			angleLimit = angle;
			break;
		case 1:
			angleLimit = angle - 0.1f;
			break;
		case 2:
			angleLimit = angle - 0.3f;
			break;
		case 3:
			angleLimit = angle - 0.4f;
			break;
		case 4:
			angleLimit = angle - 0.5f;
			break;
		case 5:
			angleLimit = angle - 0.6f;
			break;
		case 6:
			angleLimit = angle - 0.7f;
			break;
		case 7:
			angleLimit = angle - 0.9f;
			break;
		case 8:
			angleLimit = angle - 1;
			break;
		case 9:
			angleLimit = angle - 1.1f;
			break;
		case 10:
			angleLimit = angle - 1.2f;
			break;
		case 11:
			angleLimit = angle - 1.3f;
			break;
		case 12:
			angleLimit = angle - 1.4f;
			break;
		case 13:
		case 14:
			angleLimit = angle - 1.5f;
			break;
		case 15:
			angleLimit = angle - 1.6f;
			break;
		case 16:
		case 17:
			angleLimit = angle - 1.7f;
			break;
		case 18:
		case 19:
		case 20:
		case 21:
		case 22:
		case 23:
			angleLimit = angle - 1.8f;
			break;
		case 24:
		case 25:
			angleLimit = angle - 1.7f;
			break;
		case 26:
			angleLimit = angle - 1.6f;
			break;
		case 27:
			angleLimit = angle - 1.5f;
			break;
		case 28:
			angleLimit = angle - 1.4f;
			break;
		case 29:
			angleLimit = angle - 1.3f;
			break;
		case 30:
			angleLimit = angle - 1.1f;
			break;
		case 31:
			angleLimit = angle - 1;
			break;
		case 32:
			angleLimit = angle - 0.8f;
			break;
		case 33:
			angleLimit = angle - 0.5f;
			break;
		case 34:
			angleLimit = angle - 0.3f;
			break;
		case 35:
			angleLimit = angle;
			break;
		case 36:
			angleLimit = angle + 0.3f;
			break;
		case 37:
			angleLimit = angle + 0.7f;
			break;
		case 38:
			angleLimit = angle + 1.1f;
			break;
		case 39:
			angleLimit = angle + 1.5f;
			break;
		case 40:
			angleLimit = angle + 2;
			break;
		case 41:
			angleLimit = angle + 2.5f;
			break;
		case 42:
			angleLimit = angle + 3;
			break;
		case 43:
			angleLimit = angle + 3.6f;
			break;
		case 44:
			angleLimit = angle + 4.3f;
			break;
		case 45:
			angleLimit = angle + 5;
			break;
		}

		float angleBotLimit = map(angleLimit, 0, 50, 1, (topLimit + 1) / 2); //0.375
		float angleTopLimit = 1 - angleBotLimit;
		position = constrain(position, topLimit + angleTopLimit, angleBotLimit);
	}

}
//--------------------------------------------------------------
// O_osc_connection.mm
//--------------------------------------------------------------

public void connect(boolean connectTCP, boolean connectEOS, boolean log) {
	if (log) {
		consoleLog(log_Connecting + inputIP);
		saveXML();
	}

	if (connectTCP) {
		Socket socket = new Socket();
		try {
			sockaddr = new InetSocketAddress(inputIP, 3032);
			socket.connect(sockaddr, 2000); //Time out = 2000
		} catch (SocketTimeoutException e) {
			println("socket connect fail", e);
		} catch (IOException e) {
			println("socket connect fail", e);
		} finally {
			try {
				socket.close();
			} catch (Exception e) {
				println("socket close fail", e);
			}
		}

		try {
			eosIn.tcpServer().dispose();
			eos.tcpClient().dispose();
		} catch (Exception e) {

		}


		if (socket.isConnected()) {
			connectRequest = true;
			pingSent = false;
		} else {
			isConnected = false;
			connectEOS = false;
			if (!console_log.get(0).equals(log_NoConnect) && !console_log.get(0).equals(log_lostConnect)) {
				consoleLog(log_NoConnect);
			}
		}
	}

	if (connectEOS) {
		try {
			eosIn.tcpServer().dispose();
			eos.tcpClient().dispose();
			eosIn = new OscP5(this, 3032, OscP5.TCP);
			eos = new OscP5(this, inputIP, 3032, OscP5.TCP);
		} catch (Exception e) {
			eosIn = new OscP5(this, 3032, OscP5.TCP);
			eos = new OscP5(this, inputIP, 3032, OscP5.TCP);
		}
	}
}

//--------------------------------------------------------------

public void checkConnection() {

	if (receivedPingTime > sentPingTime || millis() > sentPingTime + 3000) { //IF GOT NEW PING OR TIME OUT

		if (sentPingTime > receivedPingTime && !hasOSC) { //IF CURRENT TIME IS > NEW PING TIME + BUFFER
			isConnected = false;
			if (console_log.get(0).indexOf(log_Connecting) != -1) { //IF LAST IS CONNECTING
				consoleLog(log_CheckOSC);
			} else if (console_log.get(0) == log_YesConnect) {  //IF LAST IS SUCCESFULL CONNECT
				consoleLog(log_lostConnect);
			}
			if (!isConnected) {
				connect(true, true, false);
			}
		}

		connectRequest = false; //RESET
		pingSent = false;       //RESET
	}
}

//--------------------------------------------------------------

public void heartBeat() {
	checkTime = 30 * 1000; //30*1000

	if (!hasWifi || !isConnected) {
		checkTime = 3000;
	}

	deltaTime = millis() - sentPingTime;

	try {
		if ((deltaTime > checkTime || connectRequest) && !eos.ip().equals(null)) { //IF TIMED PING OR CONNECT REQUEST
			if (!pingSent) {
				hasOSC = false; //RESET OSC CONNECTION
				// ofSleepMillis(20); //not proud of this //20
				IPAddress = getIPAddress();
				sendPing();
				pingSent = true;
			}

			if (!hasWifi) {
				IPAddress = getIPAddress();
			}

			//        fineEncoder(0);

			checkConnection();

		}
	} catch (Exception e) {

	}
}

//--------------------------------------------------------------

//--------------------------------------------------------------
// O_osc_in.mm
//--------------------------------------------------------------

public void oscEvent(OscMessage m) {
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
		int maxLength = PApplet.parseInt(smallButtonWidth * 3.5f);
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

public void getState(OscMessage m) {
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

public void getColor(OscMessage m) {

	channelHue = m.get(0).floatValue();
	channelSat = m.get(1).floatValue();
	channelHue = map(channelHue, 0, 360, 0, 255);
	channelSat = map(channelSat, 0, 100, 0, 255);

	if (channelHue == 175.60394f && channelSat == 9.344364f) {
		channelHue = 163.056f;
		channelSat = 103.167f;
	}

	push();
	colorMode(HSB, 255, 255, 255, 255);
	shutterColor = color(channelHue, channelSat, 255);
	pop();
}

//--------------------------------------------------------------

public void getCommandLine(OscMessage m) {
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

public void getChannel(OscMessage m) {
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

public void getPanTilt(OscMessage m) {
	if (m.checkTypetag("ffffff")) {
		int panPercentInt = PApplet.parseInt(m.get(4).floatValue());
		int tiltPercentInt = PApplet.parseInt(m.get(5).floatValue());
		panPercent = str(panPercentInt) + " %";
		tiltPercent = str(tiltPercentInt) + " %";
	}
}

//--------------------------------------------------------------

public void getIntensity(OscMessage m) {
	channelInt = PApplet.parseInt(getArgPercent(m, 0));
	intensityOverlay.incomingOSC(channelInt);

	channelInt255 = PApplet.parseInt(map(channelInt, 0, 100, 50, 255));

	push();
	colorMode(HSB, 255, 255, 255, 255);
	shutterColor = color(channelHue, channelSat, channelInt255);
	pop();

	channelIntString = getArgPercent(m, 0) + " %";
}

//--------------------------------------------------------------

public void getWheel(OscMessage m) {
	try {
		for (int i = 0; i < 200; i++) {
			if (m.checkAddrPattern("/eos/out/active/wheel/" + str(i)) && argHasPercent(m, 0) && !ignoreOSC) {
				String incomingOSC = m.get(0).stringValue();

				float outputInt = PApplet.parseFloat(getArgPercent(m, 0));
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

public void getDirectSelect(int bank, int buttonID, OscMessage m) {
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

public void clearParams() {
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

public boolean argHasPercent(OscMessage m, int index) {
	String incomingOSC = m.get(index).stringValue();
	if (incomingOSC.indexOf("[") != -1) {
		return true;
	} else {
		return false;
	}
}

public String getArgPercent(OscMessage m, int index) {
	String incomingOSC = m.get(index).stringValue();
	int indexValueStart = incomingOSC.indexOf("[") + 1;
	int indexValueEnd = incomingOSC.indexOf("]");
	return incomingOSC.substring(indexValueStart, indexValueEnd);
}
//--------------------------------------------------------------
// O_osc_out.mm
//--------------------------------------------------------------

public void oscEvent() {
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

public void sendIntensity(PVector oscOutput) {
	oscSentTime = millis();

	OscMessage m = new OscMessage("");
	if (oscOutput.x == 0) {
		m.setAddrPattern("/eos/user/" + inputID + "/param/intensity");
		m.add(oscOutput.y);
		eosSend(m);
	} else if (oscOutput.x < 4) {
		int switchCase = PApplet.parseInt(oscOutput.x);
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

public void sendSneak(String parameter) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");

	sendKey("clear_cmdline");
	sendKey("select_last");
	sendKey(parameter);
	sendKey("sneak");
	sendKey("enter");
}

//--------------------------------------------------------------

public void sendChannel(String parameter) {
	oscSentTime = millis();

	if (!noneSelected) { //IF A CHANNEL IS SELECTED
		sendKey(parameter);
	}
}

//--------------------------------------------------------------

public void sendChannelNumber(String parameter) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");
	m.setAddrPattern("/eos/user/" + inputID + "/cmd/" + parameter + "#");
	eosSend(m);
}

//--------------------------------------------------------------

public void sendHigh() {
	oscSentTime = millis();

	sendKey("clear_cmdline");
	sendKey("highlight");
	sendKey("enter");
	sendKey("select_last");
	sendKey("enter");
}

//--------------------------------------------------------------

public void sendFlash(String parameter) {
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

public void sendShutter(String parameter, String ID, float message) {
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

public void sendShutterHome(String parameter) {
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

public void fineEncoder(int message) { //ONLY USED TO RESET OSC TICKS, ONLY CALLED IN CONNECT();
	oscSentTime = millis();

	OscMessage m = new OscMessage("");
	m.setAddrPattern("/eos/user/" + inputID + "/wheel");
	m.add(message);
	eosSend(m);
}

//--------------------------------------------------------------

public void sendEncoder(String parameter, float message) {
	if (isPaidVersion) {
		oscSentTime = millis();

		OscMessage m = new OscMessage("");
		m.setAddrPattern("/eos/user/" + inputID + "/wheel/" + parameter);
		m.add(message);
		eosSend(m);
	}
}

//--------------------------------------------------------------

public void sendEncoderPercent(String parameter, int message) {
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

public void sendDSPage(String bank, String direction) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");
	m.setAddrPattern("eos/user/" + inputID + "/ds/" + str(PApplet.parseInt(bank)) + "/page/" + str(PApplet.parseInt(direction)));
	eosSend(m);
}
public void sendDSRequest(String bank, String parameter) {
	oscSentTime = millis();
	OscMessage m = new OscMessage("");
	m.setAddrPattern("eos/user/" + inputID + "/ds/" + str(PApplet.parseInt(bank)) + "/" + parameter + "/1/20");
	eosSend(m);
}
public void sendDS(String bank, String buttonID) {
	if (isPaidVersion) {
		oscSentTime = millis();
		OscMessage m = new OscMessage("");
		m.setAddrPattern("eos/user/" + inputID + "/ds/" + str(PApplet.parseInt(bank)) + "/" + str(PApplet.parseInt(buttonID)));
		eosSend(m);
	}
}


//--------------------------------------------------------------

public void sendPing() {
//    oscSentTime = ofGetElapsedTimeMillis();
	sentPingTime = millis();

	OscMessage m = new OscMessage("");
	m.setAddrPattern("/eos/ping");
	m.add(appName);

	eosSend(m);
}

//--------------------------------------------------------------

public void sendKey(String key) {
	OscMessage m = new OscMessage("");
	for (int i = 1; i >= 0; i--) {
		m.clear();
		m.setAddrPattern("eos/user/" + inputID + "/key/" + key);
		m.add(str(i));
		eosSend(m);
	}
}

public void sendKey(String key, boolean toggle) {
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

public void eosSend(OscMessage m) {
	try {
		eos.send(m);
	} catch (Exception e) {

	}
}
  public void settings() { 	fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ShuttR_OF" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
