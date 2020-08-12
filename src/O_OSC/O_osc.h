#pragma once

#include "ofxiOS.h"
#include "ofxEosOscMsg.h" //TCP OSC
#include "ofxOsc.h" //OSC
#include "ofxEosSync.h"

#include "A0_globals.h"

class OSC {
    
public:
    void sendPing();
    
    void sendChannel(string parameter);
    void sendChannelNumber(string parameter);
    
    void sendHigh();
    void sendFlash(string parameter);
    
    void sendEncoder(string parameter, int message);
    void fineEncoder(int message);
    void sendEncoderPercent(string parameter, int message);
    
    void sendShutter(string parameter, string ID, int message);
    void sendShutterHome(string parameter);
    
    ofxEosSync eos;
    ofxOscSender sender;
    
    void connect() {
        eos.setup("192.168.0.35", 3032);
    }
    
private:
};
