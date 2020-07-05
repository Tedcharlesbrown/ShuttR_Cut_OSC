#ifndef A0_globals_h
#define A0_globals_h

#include "ofxiOS.h"

extern string name, version;

extern ofTrueTypeFont fontLarge, fontMedium, fontSmall, fontTiny;
extern float buttonCorner;

extern float width, height;
extern float centerX, centerY, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
extern int assemblyDiameter;
//float rotation = radians(0);

//----------------------------------------------------

extern float settingsBarHeight, settingsBarStrokeWeight, smallButtonWidth, activeChannelWidth, row1Padding, genericButtonWidth, plusMinusButtonWidth, row2Padding, row3Padding,
row4Padding, guiLeftAlign, guiCenterAlign, guiRightAlign, buttonHeight, buttonStrokeWeight, largeTextSize, mediumTextSize, smallTextSize, tinyTextSize, parameterButtonWidth, row5Padding,
consoleWidth, consoleHeight, consolePadding;
//----------------------------------------------------

extern ofColor white, black, buttonActive, EOSLightGrey, EOSDarkGrey, EOSBackground, shutterOutsideStroke, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed, EOSLive, EOSBlind;

//----------------------------------------------------

#endif
