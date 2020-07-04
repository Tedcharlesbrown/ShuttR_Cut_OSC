#ifndef B_gui_h
#define B_gui_h

#include "ofxiOS.h"
#include "B_page.h"

extern bool settingsMenu;

class GUI {
    
public:
    void update();
    
    void settingsBar(float x,float y,float width,float height,float strokeWeight);
    void settingsButton(float x, float y, float width, float height, float weight);
    void oscLight(string ID, float x, float y, float width, float height, float weight);
    
    //----------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    PAGE pageOne, pageTwo, pageThree;
    
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
    
private:
};

    //----------------------------------------------------
    //----------------------------------------------------
    //----------------------------------------------------

class SETTINGS {
public:
    
    void ipFieldDraw(float x, float y, float width, float height, float weight);
    void idFieldDraw(float x, float y, float width, float height, float weight);
    
    void touchDown(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    string userInputIP = "192.168.0.35";
    string userInputID = "1";
    float ip_x, ip_y, ip_w, ip_h, id_x, id_y, id_w, id_h;
    bool ip_clicked = false;
    bool ip_action = false;
    bool id_clicked = false;
    bool id_action = false;
    
private:
};



#endif
