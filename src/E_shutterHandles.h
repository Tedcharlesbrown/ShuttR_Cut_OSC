#ifndef E_shutterHandles_h
#define E_shutterHandles_h

#include "ofxiOS.h"
#include "A0_globals.h"
#include "E_shutterButtons.h"

class THRUST_HANDLE : public ofxiOSApp {
    
public:
    void setup(string ID);
    void update();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    THRUST_BUTTON buttonA, buttonB, buttonC, buttonD;
    
    float rotateOffset, sliderX, sliderY, diff, _thrustDiameter;
    string ID;
    bool clicked = false;
    
    
private:
};


class ANGLE_HANDLE : public ofxiOSApp {
    
public:
    void setup(string ID);
    void update();
    void frameDisplay(float thrust);
    
    void calculateAngle();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    ANGLE_BUTTON buttonA, buttonB, buttonC, buttonD;
    
    float offset, rotateOffset, rotateAngle, x, y, diff, anglePercent;
    float magicNumber; //THIS MAGIC NUMBER MUST BE FOUND
    string ID;
    bool clicked = false;
    
    
private:
};

#endif
