#pragma once

#include "ofxiOS.h"
#include "A0_globals.h"
#include "E_shutterButtons.h"

#include "O_osc.h"

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
    
    float offset, rotateOffset, rotateAngle, x, y, diff, anglePercent;
    float magicNumber; //THIS MAGIC NUMBER MUST BE FOUND
    string ID;
    bool clicked = false;
    bool doubleClicked = false;
    
    OSC osc;
    
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
    
    float frameX, frameY, defaultX, botLimit, topLimit, output;
    bool clicked = false;
    bool doubleClicked = false;
    
    OSC osc;
    
private:
};
