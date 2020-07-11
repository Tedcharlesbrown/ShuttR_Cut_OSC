#ifndef E_shutterHandles_h
#define E_shutterHandles_h

#include "ofxiOS.h"
#include "A0_globals.h"
#include "E_shutterButtons.h"

class THRUST_HANDLE : public ofxiOSApp {
    
public:
    void setup(string ID);
    
    
    float offset, rotateOffset, sliderX, sliderY, diff;
    string ID;
    bool clicked = false;
    
    
private:
};


class ANGLE_HANDLE : public ofxiOSApp {
    
public:
    void setup(string ID);
    void update();
    void frameDisplay();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    ANGLE_BUTTON buttonA, buttonB, buttonC, buttonD;
    
    float offset, rotateOffset, rotateAngle, x, y, diff, anglePercent;
    //float rotateAngleBot = radians(-45) + radians(clickRadius / (8.5));  //8.5 = 1000 / 100 (11.76) ||| 7 = 800 / 100 (7.14) ||| 7 = 800 / 50 (3.57)
    //float rotateAngleTop = radians(45) - radians(clickRadius / (8.5));  //(clickRadius / 2) / (assdiameter / clickdiameter)
    string ID;
    bool clicked = false;
    
    
private:
};

#endif
