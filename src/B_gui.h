#ifndef B_gui_h
#define B_gui_h

#include "ofxiOS.h"
#include "D_button.h"

extern bool settingsMenu;

class GUI {
    
public:
    void update();
    
    void settingsBar(float x,float y,float width,float height,float strokeWeight);
    void settingsButton(float x, float y, float width, float height, float weight);
    void oscLight(string ID, float x, float y, float width, float height, float weight);
    
    void about();
    void topUIShow();
    
    //----------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    //----------------------------------------------------

    BUTTON pageOne, pageTwo, pageThree, minusButton, plusButton, fineButton, highButton, flashButton, channelButton, thrustButton, angleButton, shutterButton, irisButton, edgeButton, zoomButton, frostButton, minusPercentButton, homeButton, plusPercentButton, ipFieldButton, idFieldButton;
    
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


#endif
