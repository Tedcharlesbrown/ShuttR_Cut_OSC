#pragma once

#include "ofxiOS.h"
#include "ofxEosOscMsg.h" //TCP OSC
#include "ofxEosSync.h"

#include "A0_globals.h"

class OSC {
    
public:
    // ----------------------- INCOMING OSC -----------------------
    
    void oscInit();
    void parseChannel(string m);
    void parseWheel(string m);
    
    string multiChannelPrefix = "";
    string noParameter = "";
    
    string listenTargets[14];
    bool hasTargets[14];
    bool hasPanTilt = false;
    
    
    // ----------------------- OUTGOING OSC -----------------------
    void sendPing();
    
    void sendChannel(string parameter);
    void sendChannelNumber(string parameter);
    
    void sendHigh();
    void sendFlash(string parameter);
    
    void sendEncoder(string parameter, float message);
    void fineEncoder(int message);
    void sendEncoderPercent(string parameter, int message);
    
    void sendShutter(string parameter, string ID, int message);
    void sendShutterHome(string parameter);
    
    
    
    // -----------------------  -----------------------
    
    ofxEosSync eos;
    
    void connect() {
        eos.setup("192.168.0.35", 3032);
    }
    
private:
};
