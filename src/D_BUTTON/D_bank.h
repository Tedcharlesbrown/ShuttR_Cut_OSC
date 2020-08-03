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
    void toggleDS(int keySwitch);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    int totalSelects = 20;
    float buttonSize, padding, oneAlign, twoAlign, middleAlign, threeAlign, fourAlign, fiveAlign;
    string selected;
    ofColor colorSelect;
    
    BUTTON quickButton, customButton, leftButton, rightButton;
    BUTTON channelButton, groupButton, IPButton, FPButton, CPButton, BPButton, presetButton, macroButton, effectsButton, snapButton, MSButton, sceneButton, flexiButton;
    
private:
};

#endif
