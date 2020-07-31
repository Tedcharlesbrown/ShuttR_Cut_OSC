#include "A_ofApp.h"


string name = "ShuttR Cut OSC";
string version = "v0.1.0 (OpenFrameworks)";
string IPAddress, inputIP, inputID, inputRX, inputTX, selectedChannel = "";

vector<string> consoleLog;

bool connectRequest = true;
bool isConnected = false;
bool noneSelected = true;
bool ignoreOSC = false;
bool isLive = true;

int selectedChannelInt;

ofTrueTypeFont fontLarge, fontMedium, fontSmall, fontTiny;

float width, height, centerX, centerY, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
int assemblyDiameter;
float rotation = 0;

//----------------------------------------------------

float settingsBarHeight, settingsBarStrokeWeight, smallButtonWidth, activeChannelWidth, row1Padding, genericButtonWidth, plusMinusButtonWidth, row2Padding, row3Padding, buttonCorner,
row4Padding, guiLeftAlign, guiCenterAlign, guiRightAlign, buttonHeight, buttonStrokeWeight, largeTextSize, mediumTextSize, smallTextSize, tinyTextSize, parameterButtonWidth, row5Padding,
consoleWidth, consoleHeight, consolePadding, shutterStrokeWeight, outsideWeight, thrustWeight, angleWeight, crosshairWeight, assemblyButtonWeight, assemblyLineWeight;

//----------------------------------------------------

ofColor white, black, buttonActive, EOSLightGrey, EOSDarkGrey, EOSBackground, shutterOutsideStroke, EOSBlue, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLive, EOSBlind, shutterBackground, shutterFrameFill, shutterFrameStroke, BGFill, EOSState, EOSBarState;
ofColor shutterColor = ofColor(0);
//--------------------------------------------------------------
void ofApp::stateUpdate(){
    if (isLive){
        EOSState = EOSLive;
        EOSBarState = EOSDarkGrey;
    } else {
        EOSState = EOSBlind;
        EOSBarState = EOSBlue;
    }
}
//--------------------------------------------------------------
void ofApp::styleInit(){
    
    shutterColor.setHsb(163.056,103.167,255);
    
    //---------- PARENT WIDTH AND HEIGHT ----------
    
    width = ofGetWidth();
    height = ofGetHeight();
    
    //---------- FRAME ASSEMBLY VARIABLES ----------
    clickDiameter = width / 9.6;
    clickRadius = clickDiameter / 2;
    encoderDiameter = width / 6;
    float screenAdjust = (height / width) - 1;
    assemblyDiameter = width - (clickDiameter + (clickRadius / 2)) / screenAdjust;
    assemblyRadius = assemblyDiameter / 2;
    thrustDiameter = assemblyRadius / 2;
    centerX = width / 2;
    centerY = height - assemblyDiameter + assemblyRadius / 3;
    
    ///---------- FRAME ASSEMBLY STYLES ----------
    
    shutterStrokeWeight = width / 72; //20
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
    consoleHeight = height / 20;
    
    
    //---------- GUI WIDTH ----------
    
    smallButtonWidth = width / 10;
    activeChannelWidth = (width / 4.5) * 1.5;
    plusMinusButtonWidth = width / 6;
    genericButtonWidth = width / 4.5;
    parameterButtonWidth = genericButtonWidth / 1.25;
    consoleWidth = width / 1.25;
    
    //---------- GUI PADDDING ----------
    
    row1Padding = settingsBarHeight + buttonHeight;
    row2Padding = row1Padding + height / 11.84;
    row3Padding = row2Padding + height / 11.84;
    row4Padding = row3Padding + buttonHeight / 2;
    row5Padding = height - height / 15;
    consolePadding = height / 2;
    
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
    fontTiny.load("LondonBetween.ttf", tinyTextSize);
    fontTiny.setLetterSpacing(1.5);
    
    consoleLog.push_back(name);
    consoleLog.push_back(version);
    
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
    
    //---------------------------------------
    //---------- ASSIGNMENT COLORS ----------
    
    BGFill = shutterBackground;
    buttonActive = EOSLightGrey;
}
