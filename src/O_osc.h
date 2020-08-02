#ifndef O_osc_h
#define O_osc_h

#include "ofxiOS.h"
#include "ofxOsc.h" //OSC

#include "A0_globals.h"

class OSC : public ofxiOSApp {
    
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
    void sendThrust(string parameter, int message);
    void sendAngle(string parameter, int message);
    void sendShutterHome(string parameter);
    
    
    ofxOscSender sender;
    ofxOscReceiver receiver;
    
private:
};

#endif
