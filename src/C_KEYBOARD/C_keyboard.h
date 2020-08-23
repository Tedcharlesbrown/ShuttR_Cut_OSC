#pragma once

#include "ofxiOS.h"
#include "D_button.h"

class KEYBOARD {
    
public:
    void update();
    void draw();
    
    void open();
    void close();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    BUTTON enterButton, clearButton, zeroButton, dotButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton;
    
    //----------------------------------------------------
    
    string input = "";
    float slide = 1;
    bool show = false;
    bool isOffScreen = false;
    bool enter = false;
    bool clickedOff = false;
    
private:
};

class OVERLAY {
    
public:
    void setup();
    void update();
    void draw();
    
    void open();
    void close();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch, bool fine);
    void touchUp(ofTouchEventArgs & touch);
    
    void incomingOSC(float value);
    
    //----------------------------------------------------
    
    BUTTON fullButton, levelButton, outButton, sneakButton, minusPercentButton, homeButton, plusPercentButton;
    ofImage fader;
    
    //----------------------------------------------------
    
    string input = "";
    float slide = 1;
    bool show = false;
    bool isOffScreen = false;
    bool enter = false;
    bool clickedOff = false;
    
    bool clicked;
    float sliderX, sliderY;
    float botLimit, topLimit, defaultY;
    
    ofVec2f sliderVector;
    ofEvent<ofVec2f> oscOutputEvent;
    void sendOSC() {
        ofNotifyEvent(oscOutputEvent,sliderVector);
    }
    
private:
};
