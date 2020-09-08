import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import netP5.*; 
import oscP5.*; 
import java.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ShuttR extends PApplet {

//--------------------------------------------------------------
// A_ofApp.h || A_ofApp.mm
//--------------------------------------------------------------





boolean settingsMenu;

//--------------------------------------------------------------
// MARK: ----------GUI----------
//--------------------------------------------------------------
// BUTTON shutterPage, formPage, dSelectPage, focusPage, imagePage, minusButton, plusButton, fineButton, highButton, flashButton, channelButton, intensityButton;
public void setup() {
	//fullScreen(); //PIXEL DIMENSIONS = 1440 x 2960
	 //2
	// oscP5tcpServer = new OscP5(this, 3032, OscP5.TCP);
	// oscP5tcpClient = new OscP5(this, "192.168.0.35", 3032, OscP5.TCP);

	// IPAddress = getIPAddress();  //TODO

	styleInit();
	javaClassInit();
	// getXML(); //TODO

}

public void update() {
	// oscEvent();
	stateUpdate();


	topBarUpdate();
}


public void draw() {
	update(); //KEEP UPDATE FIRST
	//---------------------------
	background(EOSBackground);

	topBarDraw();
}

// KEYBOARD keyboard;
// OVERLAY intensityOverlay;

//--------------------------------------------------------------
// MARK: ----------TOP BAR----------
//--------------------------------------------------------------



String oldChannel = "";
float settingsX, settingsY, settingsWidth, settingsHeight;

BUTTON shutterPage, formPage, dSelectPage, focusPage, imagePage, minusButton, plusButton, fineButton, highButton, flashButton, channelButton, intensityButton;


//--------------------------------------------------------------
// MARK: ----------TOUCH EVENTS----------
//--------------------------------------------------------------
public void mousePressed() {
	ofApp_touchDown();
}
public void mouseDragged() {
	ofApp_touchMoved();
}
public void mouseReleased() {
	ofApp_touchUp();
}

// void lostFocus() {} // HOW TO DO IN JAVA?
// void gotFocus() {} // HOW TO DO IN JAVA?

//--------------------------------------------------------------
// MARK: ----------OSC EVENTS----------
//--------------------------------------------------------------

OscP5 oscP5tcpServer, oscP5tcpClient;

boolean oscSendLight = false;
boolean oscReceiveLight = false;

public void oscSent() {}

public void oscEvent(OscMessage theOscMessage) {
	ofApp_oscEvent(theOscMessage);
}
//--------------------------------------------------------------
// A_ofApp.mm
//--------------------------------------------------------------

public void ofApp_touchDown() {

}

public void ofApp_touchMoved() {

}

public void ofApp_touchUp() {

}

public void ofApp_oscSent() {

}

public void ofApp_oscEvent(OscMessage theOscMessage) {

}
//--------------------------------------------------------------
// A0_GLOBALS.h || A_style.mm
//--------------------------------------------------------------

// ----------------------- PAID VS FREE VERSION -----------------------
boolean isPaidVersion = true;

//--------------------------------------------------------------
// MARK: ---------- EOS SETTINGS ----------
//--------------------------------------------------------------

// ----------------------- NAME / IP / ID / RX / TX / SELECTED CHANNEL -----------------------
String appName = "ShuttR Cut OSC";
// string appName = "ShuttR Cut LITE";
String version = "v0.1.1";
String defaultName = appName + version;
String headerName = defaultName;

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
float largeTextSize, mediumTextSize, smallTextSize, tinyTextSize;
PFont fontLarge; PFont fontMedium; PFont fontSmall; PFont fontTiny; PFont fontDS;


//--------------------------------------------------------------
// MARK: ---------- SIZE CONSTANTS ----------
//--------------------------------------------------------------

// ----------------------- PARENT CONSTANTS -----------------------
float centerX, centerY;
float notchHeight;

// ----------------------- GUI HEIGHT -----------------------
float settingsBarHeight;
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
String[] console_log = new String[4];

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
    headerName = defaultName;
    selectedChannel = "";
    // clearParams(); //TODO
    EOSState = EOSLightGrey;
    EOSBarState = EOSDarkGrey;
  }
}
//--------------------------------------------------------------
public void javaClassInit() {
  shutterPage = new BUTTON();
  formPage = new BUTTON();
  dSelectPage = new BUTTON();
  focusPage = new BUTTON();
  imagePage = new BUTTON();
  minusButton = new BUTTON();
  plusButton = new BUTTON();
  fineButton = new BUTTON();
  highButton = new BUTTON();
  flashButton = new BUTTON();
  channelButton = new BUTTON();
  intensityButton = new BUTTON();
}
//--------------------------------------------------------------
public void styleInit() {

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
  assemblyDiameter = width - (clickDiameter + (clickRadius / 2)) / screenAdjust;
  assemblyRadius = assemblyDiameter / 2;
  thrustDiameter = assemblyRadius / 2;
  centerX = width / 2;
  centerY = (height - assemblyDiameter + assemblyRadius / 3) + notchHeight;

  ///---------- FRAME ASSEMBLY STYLES ----------

  shutterStrokeWeight = width / 50; //72
  outsideWeight = width / 96; //15
  thrustWeight = width / 288; //5
  angleWeight = width / 288; //5
  crosshairWeight = width / 144;
  assemblyButtonWeight = width / 288; //5
  assemblyLineWeight = width / 144; //10

  //---------- BUTTON STYLES ----------

  buttonStrokeWeight = (width / 144) * 1.5f;
  settingsBarStrokeWeight = 5;
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
  tinyTextSize = width / 57.6f; //25

  fontLarge = createFont("LondonBetween", largeTextSize);
  fontMedium = createFont("LondonBetween", mediumTextSize);
  fontSmall = createFont("LondonBetween", smallTextSize);
  fontDS = createFont("LondonBetween", smallTextSize / 1.1f);
  fontTiny = createFont("LondonBetween", tinyTextSize);

  console_log[0] = appName + " " + version;

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

  EOSBackground = color(15, 25, 35);
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
	// statusBarDraw();
	settingsBar(0, notchHeight, width, settingsBarHeight, settingsBarStrokeWeight);
	settingsButton(width - settingsBarHeight, notchHeight, settingsBarHeight, settingsBarHeight, buttonStrokeWeight);
	oscLight("TX", lightWidth / 2, notchHeight, lightWidth, settingsBarHeight / 2, buttonStrokeWeight);
	oscLight("RX", lightWidth / 2, settingsBarHeight / 2 + notchHeight, lightWidth, settingsBarHeight / 2, buttonStrokeWeight);
}

//--------------------------------------------------------------
// MARK: ---------- SETTINGS - BAR / BUTTON / LIGHT ----------
//--------------------------------------------------------------

public void settingsBar(float _x, float _y, float _w, float _h, float _weight) {
	push();
	fill(EOSBarState);
	noStroke();
	rect(_x, _y, _w, _h); //Settings Bar Background
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
	circle(_x + _w / 2, _y + _h / 2, _w / 5); //circle

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
		if (oscSendLight) {
			fill(EOSLightRed); //fill
		} else {
			fill(EOSRed); //fill
		}
		rect(_x, _y, _w, _h, buttonCorner / 2); //outer
	}
	pop();
}
//--------------------------------------------------------------
// D_button.h
//--------------------------------------------------------------

class BUTTON {

    //----------------------------------------------------

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

        textAlign(CENTER,CENTER);
        textFont(fontSmall);

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
        pop();
    }
}
  public void settings() { 	size(480, 986); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ShuttR" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
