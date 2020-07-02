#pragma once

#include "ofxiOS.h"
#include "gui.h"

//extern float height;
extern float centerX, width, height;

class ofApp : public ofxiOSApp {
    
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void styleInit();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    string name = "ShuttR Cut OSC";
    string version = "v0.1.0 (OpenFrameworks)";
    
    float centerY, assemblyRadius, clickDiameter, clickRadius, thrustDiameter, encoderDiameter;
    int assemblyDiameter;
    //float rotation = radians(0);
    
    ofColor white, black,EOSDarkGrey, EOSBackground, shutterOutsideStroke, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed;
    
    float settingsBarHeight, settingsBarStrokeWeight, buttonCorner, smallButtonWidth, activeChannelWidth, row1Padding, genericButtonWidth, plusMinusButtonWidth, row2Padding, row3Padding,
    row4Padding, guiLeftAlign, guiCenterAlign, guiRightAlign, buttonHeight, buttonStrokeWeight, largeTextSize, mediumTextSize, smallTextSize, tinyTextSize, parameterButtonWidth, row5Padding,
    consoleWidth, consoleHeight, consolePadding;
    
    gui GUI;
    
private:
};


