#pragma once

#include "ofxiOS.h"
#include "ofxOsc.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

#include "A0_globals.h"
#include "B_gui.h"
#include "C_keyboard.h"
#include "D_button.h"

class ofApp : public ofxiOSApp {
    
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void styleInit();
    
    string getIPAddress();
    
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

    
    //----------------------------------------------------
    
    ofxOscSender sender;
    ofxOscReceiver receiver;
    
    //----------------------------------------------------
    
    GUI gui;
    KEYBOARD keyboard;
    
    //----------------------------------------------------
    
private:
};