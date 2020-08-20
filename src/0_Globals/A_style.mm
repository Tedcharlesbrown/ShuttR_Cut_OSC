#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- EOS SETTINGS ----------
//--------------------------------------------------------------

// ----------------------- NAME / IP / ID / RX / TX / SELECTED CHANNEL -----------------------
string appName = "ShuttR Cut OSC";
string defaultName = appName + version;
string headerName = defaultName;
string version = "v0.4.1";
string IPAddress, inputIP, inputID, selectedChannel = "";

// ----------------------- EOS BOOLEANS -----------------------
bool noneSelected = true;
bool ignoreOSC = false;
bool isLive = true;

// ----------------------- NETWORK BOOLEANS -----------------------
bool connectRequest = false;
bool isConnected = false;
bool hasWifi = false;
bool hasOSC = false;

// ----------------------- RX / TX LIGHT TIME -----------------------
float oscSentTime, oscReceivedTime = 0;

// ----------------------- CHANNEL / INTENSITY -----------------------
int channelInt, channelInt255;
float channelHue, channelSat;
//--------------------------------------------------------------
// MARK: ---------- TEXT STYLES ----------
//--------------------------------------------------------------
float largeTextSize, mediumTextSize, smallTextSize, tinyTextSize;
ofTrueTypeFont fontLarge, fontMedium, fontSmall, fontTiny, fontDS;

//--------------------------------------------------------------
// MARK: ---------- SIZE CONSTANTS ----------
//--------------------------------------------------------------

// ----------------------- PARENT CONSTANTS -----------------------
float width, height, centerX, centerY;
float notchHeight;

// ----------------------- GUI HEIGHT -----------------------
float settingsBarHeight;
float row1Padding, row2Padding, row3Padding, row4Padding, row5Padding;

// ----------------------- GUI ALIGN -----------------------
float guiLeftAlign, guiCenterAlign, guiRightAlign;

// ----------------------- BUTTON WIDTH / HEIGHT -----------------------
float smallButtonWidth, activeChannelWidth, genericButtonWidth, plusMinusButtonWidth, parameterButtonWidth;
float buttonHeight;
float buttonCorner;

// ----------------------- STROKE WEIGHT -----------------------
float settingsBarStrokeWeight, buttonStrokeWeight, shutterStrokeWeight, outsideWeight, thrustWeight, angleWeight, crosshairWeight, assemblyButtonWeight, assemblyLineWeight;

// ----------------------- CONSOLE LOG -----------------------
float  consoleWidth, consoleHeight, consolePadding;
vector<string> console_log;

string log_NoConnect = "ERROR: COULD NOT CONNECT";
string log_YesConnect = "SUCCESSFULLY CONNECTED";
string log_CheckOSC = "ERROR: CHECK IF OSC RX AND TX ARE ENABLED";
string log_Connecting = "CONNECTING TO: ";
string log_UserSwitch = "SWITCHING TO USER: ";
string log_lostConnect = "LOST CONNECTION...";
string log_reConnect = "RE-CONNECTED TO: ";

// ----------------------- SHUTTER PAGE CONSTANTS -----------------------
float assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
int assemblyDiameter;
float rotation = 0;

//--------------------------------------------------------------
// MARK: ---------- COLOR ----------
//--------------------------------------------------------------

//---------- GENERIC COLOR ----------
ofColor white, black;

//---------- EOS GENERIC COLORS ----------
ofColor EOSBlue, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLightGrey, EOSDarkGrey;

//---------- EOS SPECIFIC COLORS ----------
ofColor EOSBackground, EOSLive, EOSBlind, EOSState, EOSBarState;

//---------- EOS SHUTTER COLORS ----------
ofColor shutterBackground, shutterOutsideStroke, shutterFrameFill, shutterFrameStroke;

//---------- EOS DIRECT SELECT COLORS ----------
ofColor EOSChannel, EOSGroup, EOSIntensity, EOSColor, EOSFocus, EOSBeam, EOSPreset, EOSfx, EOSMacro, EOSSnap, EOSMagic, EOSScene;

//---------- ASSIGNMENT COLORS ----------

ofColor buttonActive, BGFill;
ofColor shutterColor = ofColor(0);

//--------------------------------------------------------------
// MARK: ---------- INITIALIZERS ----------
//--------------------------------------------------------------

void ofApp::stateUpdate(){
    if (isConnected) {
        if (isLive){
            EOSState = EOSLive;
            EOSBarState = EOSDarkGrey;
        } else {
            EOSState = EOSBlind;
            EOSBarState = EOSBlue;
        }
    } else {
        headerName = defaultName;
        EOSState = EOSLightGrey;
        EOSBarState = EOSDarkGrey;
    }
}
//--------------------------------------------------------------
void ofApp::styleInit(){
    
    shutterColor.setHsb(163.056,103.167,255);
    
    //---------- PARENT WIDTH AND HEIGHT ----------
    
    width = ofGetWidth();
    height = ofGetHeight() - notchHeight;
    
    //---------- FRAME ASSEMBLY VARIABLES ----------
    clickDiameter = width / 9.6;
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
    
    buttonStrokeWeight = (width / 144) * 1.5;
    settingsBarStrokeWeight = 5;
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
    
    smallButtonWidth = width / 10;
    activeChannelWidth = (width / 4.5) * 1.5;
    plusMinusButtonWidth = width / 6;
    genericButtonWidth = width / 4.5;
    parameterButtonWidth = genericButtonWidth / 1.25;
    consoleWidth = width / 1.25;
    
    //---------- GUI PADDDING ----------
    
    row1Padding = (settingsBarHeight + buttonHeight) + notchHeight;
    row2Padding = row1Padding + height / 13;
    row3Padding = row2Padding + height / 13;
    row4Padding = row3Padding + buttonHeight / 2;
    row5Padding = (height - height / 15) + notchHeight;
    consolePadding = (height / 2) + notchHeight;
    
    //---------- TEXT STYLES ----------

    largeTextSize = width / 19.2; //75
    mediumTextSize = width / 22.15; //65
    smallTextSize = width / 32; //45
    tinyTextSize = width / 57.6; //25
    
    ofTrueTypeFont::setGlobalDpi(72);
    fontLarge.load("LondonBetween.ttf", largeTextSize);
    fontLarge.setLetterSpacing(1.25);
    fontMedium.load("LondonBetween.ttf", mediumTextSize);
    fontMedium.setLetterSpacing(1);
    fontSmall.load("LondonBetween.ttf", smallTextSize);
    fontDS.load("LondonBetween.ttf", smallTextSize / 1.1);
    fontTiny.load("LondonBetween.ttf", tinyTextSize);
    fontTiny.setLetterSpacing(1.5);
    
    console_log.push_back(appName + " " + version);
    console_log.push_back("");
    console_log.push_back("");
    console_log.push_back("");

    
    //---------- COLOR ----------
    //---------- GENERIC COLOR ----------
    
    white = ofColor(255);
    black = ofColor(0);
    
    //---------- EOS GENERIC COLORS ----------
    
    EOSBlue = ofColor(22,40,58); //Channels In Use
    EOSLightGreen = ofColor(6,155,37); //Light Green
    EOSGreen = ofColor(6,55,37); //PSD
    EOSLightRed = ofColor(165,21,23); //Light Red
    EOSRed = ofColor(65,21,23); //Snapshots
    EOSLightGrey = ofColor(85,90,101);
    EOSDarkGrey = ofColor(30,30,30);
    
    //---------- EOS SPECIFIC COLORS ----------
    
    EOSBackground = ofColor(15,25,35);
    EOSLive = ofColor(183,128,6);
    EOSBlind = ofColor(10,115,222);
    
    //---------- EOS SHUTTER COLORS ----------
    
    shutterBackground = ofColor(150,150,255); //180,181,255
    shutterOutsideStroke = ofColor(125,115,130);
    shutterFrameFill = ofColor(62,56,71);
    shutterFrameStroke = ofColor(204,195,209);
    shutterOutsideStroke = ofColor(125,115,130);
    
    //---------- EOS DIRECT SELECT COLORS ----------

    EOSChannel = ofColor::fromHex(0x275787);
    EOSGroup = ofColor::fromHex(0x517ba0);
    EOSIntensity = ofColor::fromHex(0xb14932);
    EOSColor = ofColor::fromHex(0x495476);
    EOSFocus = ofColor::fromHex(0x00624c);
    EOSBeam = ofColor::fromHex(0x0e3089);
    EOSPreset = ofColor::fromHex(0x085f7e);
    EOSfx = ofColor::fromHex(0x512789);
    EOSMacro = ofColor::fromHex(0x62626a);
    EOSSnap = ofColor::fromHex(0x9d1f2a);
    EOSMagic = ofColor::fromHex(0x891951);
    EOSScene = ofColor::fromHex(0x007e4e);
    
    //---------------------------------------
    //---------- ASSIGNMENT COLORS ----------
    
    BGFill = shutterBackground;
    buttonActive = EOSLightGrey;
}
