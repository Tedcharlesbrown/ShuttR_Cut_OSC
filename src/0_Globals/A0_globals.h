#pragma once

#include "ofxiOS.h"

//--------------------------------------------------------------
// MARK: ---------- EOS SETTINGS ----------
//--------------------------------------------------------------

// ----------------------- NAME / IP / ID / RX / TX / SELECTED CHANNEL -----------------------
extern string appName, version, headerName, IPAddress, inputIP, inputID, inputRX, inputTX, selectedChannel;

// ----------------------- EOS BOOLEANS -----------------------
extern bool noneSelected, ignoreOSC, isLive;

// ----------------------- NETWORK BOOLEANS -----------------------
extern bool connectRequest, isConnected, hasWifi, hasOSC;

// ----------------------- RX / TX LIGHT TIME -----------------------
extern float oscSentTime, oscReceivedTime;

// ----------------------- CHANNEL / INTENSITY -----------------------
extern int channelInt, channelInt255;
extern float channelHue, channelSat;

//--------------------------------------------------------------
// MARK: ---------- TEXT STYLES ----------
//--------------------------------------------------------------
extern float largeTextSize, mediumTextSize, smallTextSize, tinyTextSize;
extern ofTrueTypeFont fontLarge, fontMedium, fontSmall, fontTiny, fontDS;

//--------------------------------------------------------------
// MARK: ---------- SIZE CONSTANTS ----------
//--------------------------------------------------------------

// ----------------------- PARENT CONSTANTS -----------------------
extern float width, height, centerX, centerY;
extern float notchHeight;

// ----------------------- GUI HEIGHT -----------------------
extern float settingsBarHeight;
extern float row1Padding, row2Padding, row3Padding, row4Padding, row5Padding;

// ----------------------- GUI ALIGN -----------------------
extern float guiLeftAlign, guiCenterAlign, guiRightAlign;

// ----------------------- BUTTON WIDTH / HEIGHT -----------------------
extern float smallButtonWidth, activeChannelWidth, genericButtonWidth, plusMinusButtonWidth, parameterButtonWidth;
extern float buttonHeight;
extern float buttonCorner;

// ----------------------- STROKE WEIGHT -----------------------
extern float settingsBarStrokeWeight, buttonStrokeWeight, shutterStrokeWeight, outsideWeight, thrustWeight, angleWeight, crosshairWeight, assemblyButtonWeight, assemblyLineWeight;

// ----------------------- CONSOLE LOG -----------------------
extern float  consoleWidth, consoleHeight, consolePadding;
extern vector<string> console_log;

// ----------------------- SHUTTER PAGE CONSTANTS -----------------------
extern float assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
extern int assemblyDiameter;
extern float rotation;

//--------------------------------------------------------------
// MARK: ---------- COLOR ----------
//--------------------------------------------------------------

//---------- GENERIC COLOR ----------
extern ofColor white, black;

//---------- EOS GENERIC COLORS ----------
extern ofColor EOSBlue, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLightGrey, EOSDarkGrey;

//---------- EOS SPECIFIC COLORS ----------
extern ofColor EOSBackground, EOSLive, EOSBlind, EOSState, EOSBarState;

//---------- EOS SHUTTER COLORS ----------
extern ofColor shutterColor, shutterBackground, shutterOutsideStroke, shutterFrameFill, shutterFrameStroke;

//---------- EOS DIRECT SELECT COLORS ----------
extern ofColor EOSChannel, EOSGroup, EOSIntensity, EOSColor, EOSFocus, EOSBeam, EOSPreset, EOSfx, EOSMacro, EOSSnap, EOSMagic, EOSScene;

//---------- ASSIGNMENT COLORS ----------

extern ofColor buttonActive, BGFill;

//----------------------------------------------------
