#pragma once

#include "ofxiOS.h"

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
    float currentPos, lastPos = 0;
    float posX, posY;
    bool clicked = false;
    
    float encoderOutput = 0;
    ofEvent<float> oscOutputPercent;
    void sendOSC() {
        ofNotifyEvent(oscOutputPercent,encoderOutput);
    }
    
private:
};
