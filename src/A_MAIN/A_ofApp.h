#pragma once

#include "ofxiOS.h"
#include "ofxXmlSettings.h" //XML

#include <ifaddrs.h> //IP ADDRESS
#include <arpa/inet.h> //IP ADDRESS

#include "A0_globals.h"
#include "B_gui.h"
#include "C_keyboard.h"
#include "D_button.h"
#include "O_osc.h"

class ofApp : public ofxiOSApp {
    
public:
    void setup();
    void update();
    void draw();
    
    void styleInit();
    
    void getNotchHeight();

    void connect();
    
    string getIPAddress();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    
    GUI gui;
    
    //----------------------------------------------------
    
private:
};
