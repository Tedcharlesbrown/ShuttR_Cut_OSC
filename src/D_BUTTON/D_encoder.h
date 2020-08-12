#pragma once

#include "ofxiOS.h"
#include "O_osc_OLD.h"

class ENCODER{
    
public:
    void setup(float size);
    void update(string parameter);
    void draw(float x, float y);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch, bool fine);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    ofImage encoder;
    string parameter;
    int output = 0;
    float currentPos, lastPos = 0;
    float posX, posY;
    bool clicked = false;
    
    OSC_OLD osc;
    
private:
};
