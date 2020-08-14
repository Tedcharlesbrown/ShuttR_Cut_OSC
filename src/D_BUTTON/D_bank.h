#pragma once

#include "D_button.h"

#include "ofxiOS.h"

class BANK {
    
public:
    void setup(int ID);
    void update();
    void draw(float padding);
    
    void quickSelectsShow();
    
    void quickSelectAction();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    int ID;
    int totalSelects;
    float buttonSize, padding, align, oneAlign, twoAlign, middleAlign, threeAlign, fourAlign, fiveAlign;
    float directSelectSize;
    ofColor colorSelect;
    string selected;
    float bankHeight;
    
    ofVec3f directSelectVec;
    ofEvent<ofVec3f> oscOutputDS;
    void sendOSC() {
        ofNotifyEvent(oscOutputDS,directSelectVec);
    }
    
    float totalPalettes;
    vector<BUTTON> palette, directSelect;
    
    BUTTON button;
    
    BUTTON quickButton, customButton, leftButton, rightButton;
    BUTTON channelButton, groupButton, IPButton, FPButton, CPButton, BPButton, presetButton, macroButton, effectsButton, snapButton, MSButton, sceneButton, flexiButton;
    
private:
};
