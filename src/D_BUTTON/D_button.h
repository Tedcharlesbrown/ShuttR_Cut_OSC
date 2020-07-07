#ifndef D_button_h
#define D_button_h

#include "ofxiOS.h"

class BUTTON : public ofxiOSApp {
    
public:
    void show(float x, float y, float width, float height); //NO TEXT
    void show(string ID, float x, float y, float width, float height, string textSize); //ONE TEXT
    void show(string ID, string ID2, float x, float y, float width, float height); //TWO TEXT
    
    void showBig(string ID, string ID2, float x, float y, float width, float height); //TWO TEXT WITH BOTTOM
    
    void touchDown(ofTouchEventArgs & touch);
    void touchDown(ofTouchEventArgs & touch, bool toggle);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    string ID;
    float x, y, w, h;
    bool clicked = false;
    bool doubleClicked = false;
    bool action = false;
    bool released = false;

    
private:
};

#endif
