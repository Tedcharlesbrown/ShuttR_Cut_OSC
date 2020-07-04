#ifndef C_keyboard_h
#define C_keyboard_h

#include "ofxiOS.h"
#include "D_button.h"

class KEYBOARD : public ofxiOSApp {
    
public:
    void update();
    void draw();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    BUTTON enterButton, clearButton, zeroButton, dotButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton;
    
    //----------------------------------------------------
    
    string userInput = "";
    float slide = 1;
    bool open = false;
    bool enter = false;
    
private:
};

#endif
