#ifndef D_bank_h
#define D_bank_h

#include "D_button.h"

#include "ofxiOS.h"

class BANK : public ofxiOSApp {
    
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
    
    BUTTON button;
    
    BUTTON quickButton, customButton, leftButton, rightButton;
    BUTTON channelButton, groupButton, IPButton, FPButton, CPButton, BPButton, presetButton, macroButton, effectsButton, snapButton, MSButton, sceneButton, flexiButton;
    
private:
};

#endif
