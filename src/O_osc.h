#ifndef O_osc_h
#define O_osc_h

#include "ofxiOS.h"
#include "ofxOsc.h" //OSC

class OSC : public ofxiOSApp {
    
public:
    void sendEncoder(string userID, string ID, int message);
    
    
    
    ofxOscSender sender;
    ofxOscReceiver receiver;
    
private:
};

#endif
