#ifndef B_gui_h
#define B_gui_h

#include "ofxiOS.h"
#include "C_keyboard.h"
#include "D_button.h"

extern bool settingsMenu;

class GUI {
    
public:
    void setup();
    void update();
    void draw();
    
    void settingsBar(float x,float y,float width,float height,float strokeWeight);
    void settingsButton(float x, float y, float width, float height, float weight);
    void oscLight(string ID, float x, float y, float width, float height, float weight);
    void settingsShow();
    
    void about();
    void topUIShow();
    
    //----------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    //----------------------------------------------------

    BUTTON pageOne, pageTwo, pageThree, minusButton, plusButton, fineButton, highButton, flashButton, channelButton, thrustButton, angleButton, shutterButton, irisButton, edgeButton, zoomButton, frostButton, minusPercentButton, homeButton, plusPercentButton, ipFieldButton, idFieldButton, incomingButton, outgoingButton, helpButton;
    
    KEYBOARD keyboard;
    
    ofImage settingsHelp;
    
    //----------------------------------------------------
    
    void oscSent(int time);
    void oscEvent(int time);
    
    //----------------------------------------------------
    
    int sentTime, receivedTime;
    bool oscSendLight = false;
    bool oscReceiveLight = false;
    
    //----------------------------------------------------
    
    float settingsX, settingsY, settingsWidth, settingsHeight;
    string userInputIP = "";
    string userInputID = "1";
    string userInputTX = "8000";
    string userInputRX = "9000";
    int keySwitch = 0;
    
private:
};


#endif
