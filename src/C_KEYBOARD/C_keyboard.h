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
    bool enter = false;
    bool clickedOff = false;
    
private:
};
