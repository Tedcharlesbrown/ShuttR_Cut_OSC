#ifndef B_gui_h
#define B_gui_h

#include "ofxiOS.h"

class GUI {
    
public:
    void update();
    
    void settingsBar(float x,float y,float width,float height,ofColor stroke,float strokeWeight,ofColor fill);
    void settingsButton(float x, float y, float width, float height, float round, ofColor stroke, float weight, ofColor onFill, ofColor offFill);
    void oscLight(string ID, float x, float y, float width, float height, float round, ofColor stroke, float weight, ofColor onSend, ofColor offSend, ofColor onGet, ofColor offGet);
    
    //----------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    void oscSent(int time);
    void oscEvent(int time);
    
    //----------------------------------------------------
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    //----------------------------------------------------
    
    int sentTime, receivedTime;
    bool oscSendLight = false;
    bool oscReceiveLight = false;
    
    //----------------------------------------------------
    
    float settingsX, settingsY, settingsWidth, settingsHeight;
    bool settingsMenu = false;
    
private:
};

    //----------------------------------------------------
    //----------------------------------------------------
    //----------------------------------------------------

class PAGE {
public:
    void update();
    void pageButton(float x, float y, float width, float height, float round, ofColor stroke, float weight, ofColor onFill, ofColor offfill);
    
    float x, y, w, h;
    bool clicked, action = false;
    
    void touchDown(ofTouchEventArgs & touch);
    
private:
};



#endif
