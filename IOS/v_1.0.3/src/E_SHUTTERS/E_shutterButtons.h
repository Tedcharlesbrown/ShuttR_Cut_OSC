#pragma once

#include "ofxiOS.h"

//--------------------------------------------------------------
// MARK: ----------THRUST_BUTTON----------
//--------------------------------------------------------------

class THRUST_BUTTON {

public:
    void draw(string ID, float rotateAngle);
    void addOffset(float diff);
    void angleLimit(float angleRotateLimit);
    
    float position = 1; // The position of the slider between 0 and 1
    string ID;
    float rotateAngle;
    
    float thrustPercent = 0;
    ofEvent<float> oscOutputPercent;
    void sendOSC() {
        ofNotifyEvent(oscOutputPercent,thrustPercent);
    }
    
private:
};

//--------------------------------------------------------------
// MARK: ----------ANGLE_BUTTON----------
//--------------------------------------------------------------

class ANGLE_BUTTON {

public:
    void draw(string ID, float rotateAngle);
    void frameShow(float thrust);
    
    float position = 1; // The position of the slider between 0 and 1
    string ID;
    float rotateAngle;
    
private:
};
