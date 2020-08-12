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
#include "O_osc.h"

class ofApp : public ofxiOSApp {
    
public:
    void setup();
    void update();
    void draw();
    
    void styleInit();
    void stateUpdate();
    
    void getNotchHeight();
    
    void oscInit();
    void parseChannel(string m);
    void parseWheel(string m);
    
    void connect();
    void checkConnection();
    
    string getIPAddress();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void oscEvent();
    
    void lostFocus();
    void gotFocus();
    
    //----------------------------------------------------
    void saveXML();
    void getXML();
    
    ofxXmlSettings XML;

    string xmlStructure;
    string message;
    //----------------------------------------------------
    
    string multiChannelPrefix = "";
    string noParameter = "";
    
//    OSC osc;
    
    ofxOscReceiver receiver;
    string listenTargets[14];
    bool hasTargets[14];
    bool hasPanTilt = false;
    
    //----------------------------------------------------
    
    GUI gui;
    KEYBOARD keyboard;
    
    //----------------------------------------------------
    
private:
};
