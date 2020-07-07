#pragma once

#include "ofxiOS.h"
#include "ofxOsc.h" //OSC
#include "ofxXmlSettings.h" //XML

#include <ifaddrs.h> //IP ADDRESS
#include <arpa/inet.h> //IP ADDRESS

#include "A0_globals.h"
#include "B_gui.h"
#include "C_keyboard.h"
#include "D_button.h"

extern ofxOscSender sender;

class ofApp : public ofxiOSApp {
    
public:
    void setup();
    void update();
    void draw();
    
    void styleInit();
    
    void oscInit();
    void parseChannel(string m);
    void parseWheel(string m);
    
    string getIPAddress();
    
    void connect();
    void checkConnection();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void oscSent();
    void oscEvent();
    
    void lostFocus();
    void gotFocus();
    
    //----------------------------------------------------
    ofxXmlSettings XML;

    string xmlStructure;
    string message;
    //----------------------------------------------------
    
    //ofxOscSender sender;
    ofxOscReceiver receiver;
    string listenTargets[14];
    bool hasTargets[14];
    
    //----------------------------------------------------
    
    GUI gui;
    KEYBOARD keyboard;
    
    //----------------------------------------------------
    
private:
};
