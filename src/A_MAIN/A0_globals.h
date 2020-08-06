#pragma once

#include "ofxiOS.h"

extern string name, version, IPAddress, inputIP, inputID, inputRX, inputTX, selectedChannel;
extern vector<string> consoleLog;
extern bool connectRequest, isConnected, noneSelected, ignoreOSC, isLive;

extern int selectedChannelInt, channelIntensity;

extern ofTrueTypeFont fontLarge, fontMedium, fontSmall, fontTiny;
extern float buttonCorner;

extern float width, height;
extern float centerX, centerY, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
extern int assemblyDiameter;
extern float rotation;

//----------------------------------------------------

extern float settingsBarHeight, settingsBarStrokeWeight, smallButtonWidth, activeChannelWidth, row1Padding, genericButtonWidth, plusMinusButtonWidth, row2Padding, row3Padding,
row4Padding, guiLeftAlign, guiCenterAlign, guiRightAlign, buttonHeight, buttonStrokeWeight, largeTextSize, mediumTextSize, smallTextSize, tinyTextSize, parameterButtonWidth, row5Padding,
consoleWidth, consoleHeight, consolePadding, shutterStrokeWeight, outsideWeight, thrustWeight, angleWeight, crosshairWeight, assemblyButtonWeight, assemblyLineWeight;
//----------------------------------------------------

extern ofColor white, black, EOSBlue, buttonActive, EOSLightGrey, EOSDarkGrey, EOSBackground, shutterBackground, shutterOutsideStroke, shutterFrameFill, shutterFrameStroke, shutterOutsideStroke, BGFill, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLive, EOSBlind, EOSState, EOSBarState, shutterColor;
extern ofColor EOSChannel, EOSGroup, EOSIntensity, EOSColor, EOSFocus, EOSSnap, EOSBeam, EOSPreset, EOSfx, EOSMacro, EOSMagic, EOSScene;

//----------------------------------------------------
