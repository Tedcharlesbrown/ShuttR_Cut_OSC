#ifndef O_osc_h
#define O_osc_h

#include "ofxiOS.h"
#include "ofxOsc.h" //OSC

#include "A0_globals.h"

class OSC : public ofxiOSApp {
    
public:
    void sendPing();
    
    void sendEncoder(string ID, int message, bool fine);
    void fineEncoder(int message);
    void sendEncoderPercent(string ID, int message);
    
    
    
    ofxOscSender sender;
    ofxOscReceiver receiver;
    
private:
};

#endif
