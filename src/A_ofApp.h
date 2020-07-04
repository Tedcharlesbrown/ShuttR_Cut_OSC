#pragma once

#include "ofxiOS.h"
#include "ofxOsc.h"
#include "A0_globals.h"
#include "B_gui.h"
#include "C_keyboard.h"

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
    
    void oscSent();
    void oscEvent();
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    //----------------------------------------------------
    
    string name = "ShuttR Cut OSC";
    string version = "v0.1.0 (OpenFrameworks)";
    
    //----------------------------------------------------
    
    ofxOscSender sender;
    ofxOscReceiver receiver;
    
    //----------------------------------------------------
    
    GUI gui;
    //PAGE pageOne, pageTwo, pageThree;
    SETTINGS settings;
    KEYBOARD keyboard;
    
    //----------------------------------------------------
    
private:
};
