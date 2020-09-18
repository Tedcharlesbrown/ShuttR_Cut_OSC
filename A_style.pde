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

String version = "v1.0.5";
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
color white, black;

//---------- EOS GENERIC COLORS ----------
color EOSBlue, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLightGrey, EOSDarkGrey;

//---------- EOS SPECIFIC COLORS ----------
color EOSBackground, EOSLive, EOSBlind, EOSState, EOSBarState;

//---------- EOS SHUTTER COLORS ----------
color shutterBackground, shutterOutsideStroke, shutterFrameFill, shutterFrameStroke;

//---------- EOS DIRECT SELECT COLORS ----------
color EOSChannel, EOSGroup, EOSIntensity, EOSColor, EOSFocus, EOSBeam, EOSPreset, EOSfx, EOSMacro, EOSSnap, EOSMagic, EOSScene;

//---------- ASSIGNMENT COLORS ----------

color buttonActive, BGFill;
color shutterColor = color(0);

//--------------------------------------------------------------
// MARK: ---------- INITIALIZERS ----------
//--------------------------------------------------------------

void stateUpdate() {
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
float ofGetPreviousMouseX() { return pmouseX; }
float ofGetPreviousMouseY() { return pmouseY; }
//--------------------------------------------------------------
void javaClassInit() {
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
void styleInit() {
  //---------- SPLASH SCREEN LOAD ----------
  if (appName.indexOf("LITE") != -1) {
    splashImg = loadImage("icon-lite.png");
  } else {
    splashImg = loadImage("icon-pro.png");
  }
  
  //---------- LITE IMAGE LOAD ----------

  liteBanner = loadImage("Lite.png");
  liteBanner.resize(width,0);

  //---------- SHUTTER COLOR INIT ----------

  push();
  colorMode(HSB, 255, 255, 255, 255);
  shutterColor = color(163.056, 103.167, 255);
  pop();

  //---------- PARENT WIDTH AND HEIGHT ----------

  // width = ofGetWidth();
  // height = ofGetHeight() - notchHeight;

  //---------- FRAME ASSEMBLY VARIABLES ----------
  clickDiameter = width / 9.6;
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

  shutterStrokeWeight = (width / 50); //width / 50
  outsideWeight = width / 96; //15
  thrustWeight = width / 288; //5
  angleWeight = width / 288; //5
  crosshairWeight = width / 144;
  assemblyButtonWeight = width / 288; //5
  assemblyLineWeight = (width / 144) / 2; //10

  //---------- BUTTON STYLES ----------

  buttonStrokeWeight = (width / 144);
  settingsBarStrokeWeight = buttonStrokeWeight;
  buttonCorner = width / 57.6;

  //---------- GUI ALIGNMENT ----------

  guiLeftAlign = centerX - centerX / 1.5;
  guiCenterAlign = centerX;
  guiRightAlign = centerX + centerX / 1.5;

  //---------- GUI HEIGHT ----------

  buttonHeight = height / 19.7;
  settingsBarHeight = height / 20;
  consoleHeight = height / 10;

  //---------- GUI WIDTH ----------

  lightWidth = width / 10;
  channelButtonWidth = (width / 4.5) * 1.5;
  smallButtonWidth = width / 6;
  genericButtonWidth = width / 4.5;
  parameterButtonWidth = genericButtonWidth / 1.25;
  consoleWidth = width / 1.25;

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

  largeTextSize = width / 19.2; //75
  mediumTextSize = width / 22.15; //65
  smallTextSize = width / 32; //45
  dsTextSize = (width / 32) / 1.1; //45
  tinyTextSize = width / 57.6; //25

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

  EOSChannel = #275787;
  EOSGroup = #517ba0;
  EOSIntensity = #b14932;
  EOSColor = #495476;
  EOSFocus = #00624c;
  EOSBeam = #0e3089;
  EOSPreset = #085f7e;
  EOSfx = #512789;
  EOSMacro = #62626a;
  EOSSnap = #9d1f2a;
  EOSMagic = #891951;
  EOSScene = #007e4e;

  //---------------------------------------
  //---------- ASSIGNMENT COLORS ----------

  BGFill = shutterBackground;
  buttonActive = EOSLightGrey;
}




