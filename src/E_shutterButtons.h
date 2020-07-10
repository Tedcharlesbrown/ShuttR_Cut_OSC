#ifndef E_shutterButtons_h
#define E_shutterButtons_h

#include "ofxiOS.h"

class ANGLE_BUTTON : public ofxiOSApp {

public:
    void draw(string ID, float rotateAngle);
    
    float position = 1; // The position of the slider between 0 and 1
    string ID;
    float rotateAngle;
private:
    
};


#endif
