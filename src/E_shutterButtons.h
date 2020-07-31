#ifndef E_shutterButtons_h
#define E_shutterButtons_h

#include "ofxiOS.h"

class THRUST_BUTTON : public ofxiOSApp {

public:
    void draw(string ID, float rotateAngle);
    void addOffset(float diff);
    void angleLimit(float angleRotateLimit);
    
    float position = 1; // The position of the slider between 0 and 1
    string ID;
    float rotateAngle;
    float output;
private:
    
};

class ANGLE_BUTTON : public ofxiOSApp {

public:
    void draw(string ID, float rotateAngle);
    void frameShow(float thrust);
    
    float position = 1; // The position of the slider between 0 and 1
    string ID;
    float rotateAngle;
private:
    
};


#endif
