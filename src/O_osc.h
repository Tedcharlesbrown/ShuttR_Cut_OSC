#ifndef O_osc_h
#define O_osc_h

#include "ofxiOS.h"
#include "ofxOsc.h" //OSC

class OSC : public ofxiOSApp {
    
public:
    void sendPing();
    
    void sendEncoder(string userID, string ID, int message, bool fine);
    void fineEncoder(string userID, int message);
    void sendEncoderPercent(string userID, string ID, int message);
    
    
    
    ofxOscSender sender;
    ofxOscReceiver receiver;
    
private:
};

#endif
