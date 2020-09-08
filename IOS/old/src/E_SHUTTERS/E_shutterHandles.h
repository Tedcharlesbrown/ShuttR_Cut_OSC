#pragma once

#include "ofxiOS.h"

#include "A0_globals.h"
#include "E_shutterButtons.h"

//--------------------------------------------------------------
// MARK: ----------THRUST_HANDLE----------
//--------------------------------------------------------------

class THRUST_HANDLE : public ofxiOSApp {
    
public:
    void setup(string ID);
    void update();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch, bool fine);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    THRUST_BUTTON buttonA, buttonB, buttonC, buttonD;
    
    float rotateOffset, sliderX, sliderY, diff, _thrustDiameter;
    string ID;
    bool clicked = false;
    bool doubleClicked = false;
    
private:
};

//--------------------------------------------------------------
// MARK: ----------ANGLE_HANDLE----------
//--------------------------------------------------------------

class ANGLE_HANDLE {
    
public:
    void setup(string ID);
    void update();
    void frameDisplay(float thrust);
    
    void calculateAngle();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch, bool fine);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    ANGLE_BUTTON buttonA, buttonB, buttonC, buttonD;
    
    float offset, rotateOffset, rotateAngle, x, y, diff;
    float magicNumber; //THIS MAGIC NUMBER MUST BE FOUND
    string ID;
    bool clicked = false;
    bool doubleClicked = false;
    
    ofVec3f angleVec;
    
    float anglePercent = 0;
    ofEvent<float> oscOutputEvent;
    void sendOSC() {
        ofNotifyEvent(oscOutputEvent,anglePercent);
    }
    
private:
};

//--------------------------------------------------------------
// MARK: ----------ASSEMBLY_HANDLE----------
//--------------------------------------------------------------

class ASSEMBLY_HANDLE {
    
public:
    void setup();
    void update();
    
    void incomingOSC(float oscMessage);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch, bool fine);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    float frameX, frameY, defaultX, botLimit, topLimit;
    bool clicked = false;
    bool doubleClicked = false;
    
    float assemblyAngle = 0;
    ofEvent<float> oscOutputPercent;
    void sendOSC() {
        ofNotifyEvent(oscOutputPercent,assemblyAngle);
    }
    
private:
};
