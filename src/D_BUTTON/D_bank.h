#pragma once

#include "D_button.h"

#include "ofxiOS.h"

class BANK {
    
public:
    void setup();
    void update();
    void draw(string ID, float padding);
    
    void quickSelectsShow();
    
    void quickSelectAction();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    int totalSelects;
    float buttonSize, padding, align, oneAlign, twoAlign, middleAlign, threeAlign, fourAlign, fiveAlign;
    string selected;
    ofColor colorSelect;
    
    float totalPalettes;
    vector<BUTTON> palette, directSelect;
    
    float bankHeight;
    
    BUTTON button;
    
    BUTTON quickButton, customButton, leftButton, rightButton;
    BUTTON channelButton, groupButton, IPButton, FPButton, CPButton, BPButton, presetButton, macroButton, effectsButton, snapButton, MSButton, sceneButton, flexiButton;
    
private:
};
