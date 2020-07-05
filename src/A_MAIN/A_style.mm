#include "A_ofApp.h"


string name = "ShuttR Cut OSC";
string version = "v0.1.0 (OpenFrameworks)";
string IPAddress, RXPort, TXPort = "";

ofTrueTypeFont fontLarge, fontMedium, fontSmall, fontTiny;

float width, height, centerX, centerY, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
int assemblyDiameter;
//float rotation = radians(0);

//----------------------------------------------------

float settingsBarHeight, settingsBarStrokeWeight, smallButtonWidth, activeChannelWidth, row1Padding, genericButtonWidth, plusMinusButtonWidth, row2Padding, row3Padding, buttonCorner,
row4Padding, guiLeftAlign, guiCenterAlign, guiRightAlign, buttonHeight, buttonStrokeWeight, largeTextSize, mediumTextSize, smallTextSize, tinyTextSize, parameterButtonWidth, row5Padding,
consoleWidth, consoleHeight, consolePadding;

//----------------------------------------------------

ofColor white, black, buttonActive, EOSLightGrey, EOSDarkGrey, EOSBackground, shutterOutsideStroke, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLive, EOSBlind;


//--------------------------------------------------------------
void ofApp::styleInit(){
    width = ofGetWidth();
    height = ofGetHeight();
    clickDiameter = width / 9.6;
    clickRadius = clickDiameter / 2;
    encoderDiameter = width / 6;
    float screenAdjust = (height / width) - 1;
    assemblyDiameter = width - (clickDiameter + (clickRadius / 2)) / screenAdjust;
    assemblyRadius = assemblyDiameter / 2;
    thrustDiameter = assemblyRadius / 2;
    centerX = width / 2;
    centerY = height - assemblyDiameter + assemblyRadius / 3;
    
    //----------------------------------------------------
    
    guiLeftAlign = centerX - centerX / 1.5;
    guiCenterAlign = centerX;
    guiRightAlign = centerX + centerX / 1.5;
    buttonHeight = height / 19.7;
    settingsBarHeight = height / 20;
    settingsBarStrokeWeight = 5;
    smallButtonWidth = width / 10;
    activeChannelWidth = (width / 4.5) * 1.5;
    plusMinusButtonWidth = width / 6;
    genericButtonWidth = width / 4.5;
    parameterButtonWidth = genericButtonWidth / 1.25;
    buttonCorner = width / 57.6;
    buttonStrokeWeight = (width / 144) * 1.5;
    row1Padding = settingsBarHeight + buttonHeight;
    row2Padding = row1Padding + height / 11.84;
    row3Padding = row2Padding + height / 11.84;
    row4Padding = row3Padding + buttonHeight / 2;
    row5Padding = height - height / 15;
    consoleWidth = width / 1.25;
    consoleHeight = height / 20;
    consolePadding = height / 2;
    
    //----------------------------------------------------

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
    
    //----------------------------------------------------
    
    white = ofColor(255);
    black = ofColor(0);
    
    EOSLightGreen = ofColor(6,155,37); //Light Green
    EOSGreen = ofColor(6,55,37); //PSD
    EOSLightRed = ofColor(165,21,23); //Light Red
    EOSRed = ofColor(65,21,23); //Snapshots
    
    EOSLightGrey = ofColor(85,90,101);
    EOSDarkGrey = ofColor(30,30,30);
    EOSBackground = ofColor(15,25,35);
    EOSLive = ofColor(183,128,6);
    EOSBlind = ofColor(10,115,222);
    
    shutterOutsideStroke = ofColor(125,115,130);
    
    buttonActive = EOSLightGrey;
}
