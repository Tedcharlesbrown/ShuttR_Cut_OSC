#pragma once

#include "ofxiOS.h"

class ENCODER{
    
public:
    ofImage encoder;
    string parameter;
    float currentPos, lastPos = 0;
    float posX, posY;
    float newTick, oldTick;
    bool clicked = false;

    //----------------------------------------------------

    float encoderOutput = 0;
    ofEvent<float> oscOutputEvent;
    void sendOSC() {
        ofNotifyEvent(oscOutputEvent,encoderOutput);
    }

    //----------------------------------------------------

    void setup(float size);
    void draw(float x, float y);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
private:
};
