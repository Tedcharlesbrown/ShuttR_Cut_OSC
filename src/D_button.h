#ifndef D_button_h
#define D_button_h

#include "ofxiOS.h"

class BUTTON : public ofxiOSApp {
    
public:
    void show(string ID, float x, float y, float width, float height, string textSize);
    
    void update();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
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
