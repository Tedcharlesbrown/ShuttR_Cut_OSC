#ifndef B_gui_h
#define B_gui_h

#include "ofxiOS.h"
#include "A_ofApp.h"
#include "C_keyboard.h"
#include "D_button.h"
#include "D_bank.h"

#include "E_shutterHandles.h"

#include "O_osc.h"

extern bool settingsMenu;

class GUI {
    
public:
    //--------------------------------------------------------------
    // MARK: ----------GUI----------
    //--------------------------------------------------------------
    void setup();
    void update();
    void draw();
    
    OSC osc;
    KEYBOARD keyboard;
    
    //--------------------------------------------------------------
    // MARK: ----------TOP BAR----------
    //--------------------------------------------------------------
    
    void topBarDraw();
    void topBarUpdate();
    void settingsBar(float x,float y,float width,float height,float strokeWeight);
    void settingsButton(float x, float y, float width, float height, float weight);
    void oscLight(string ID, float x, float y, float width, float height, float weight);
    
    string oldChannel = "";
    
    BUTTON pageOne, pageTwo, pageThree, minusButton, plusButton, fineButton, highButton, flashButton, channelButton;
    
    //--------------------------------------------------------------
    // MARK: ----------PAGE ONE----------
    //--------------------------------------------------------------
    
    void pageOneSetup();
    void pageOneUpdate();
    void pageOneDraw();
    void pageOneButtonAction();
    void assemblyColor();
    void assemblyBG();
    
    void pageOneTouchDown(ofTouchEventArgs & touch);
    void pageOneTouchMoved(ofTouchEventArgs & touch);
    void pageOneTouchUp(ofTouchEventArgs & touch);
    void pageOneDoubleTap(ofTouchEventArgs & touch);
    
    ofImage bgAssembly;
    THRUST_HANDLE thrustA, thrustB, thrustC, thrustD;
    ANGLE_HANDLE angleA, angleB, angleC, angleD;
    ASSEMBLY_HANDLE assembly;
    
    BUTTON thrustButton, angleButton, shutterButton;
    
    //--------------------------------------------------------------
    // MARK: ----------PAGE TWO----------
    //--------------------------------------------------------------
    
    void pageTwoSetup();
    void pageTwoUpdate();
    void pageTwoDraw();
    
    void pageTwoTouchDown(ofTouchEventArgs & touch);
    void pageTwoTouchMoved(ofTouchEventArgs & touch);
    void pageTwoTouchUp(ofTouchEventArgs & touch);
    void pageTwoDoubleTap(ofTouchEventArgs & touch);
    
    ofImage encoder;
    float encoderPosition, lastPosition = 0;
    bool encoderClicked = false;
    string irisPercent, edgePercent, zoomPercent, frostPercent, parameter, parameterShow = "";
    
    BUTTON irisButton, edgeButton, zoomButton, frostButton, minusPercentButton, homeButton, plusPercentButton;
    
    //--------------------------------------------------------------
    // MARK: ----------PAGE THREE----------
    //--------------------------------------------------------------
    
    void pageThreeSetup();
    void pageThreeUpdate();
    void pageThreeDraw();
    
    void pageThreeTouchDown(ofTouchEventArgs & touch);
    void pageThreeTouchMoved(ofTouchEventArgs & touch);
    void pageThreeTouchUp(ofTouchEventArgs & touch);
    void pageThreeDoubleTap(ofTouchEventArgs & touch);
    
    BANK bankOne, bankTwo;
    
    //--------------------------------------------------------------
    // MARK: ----------SETTINGS----------
    //--------------------------------------------------------------
    
    void settingsSetup();
    void settingsDraw();
    void console();
    void about();
    
    float settingsX, settingsY, settingsWidth, settingsHeight;
    string userInputIP = "";
    string userInputID = "1";
    string userInputTX = "8000";
    string userInputRX = "9000";
    int keySwitch = 0;
    
    BUTTON ipFieldButton, idFieldButton, incomingButton, outgoingButton, helpButton;
    ofImage settingsHelp;
    
    //--------------------------------------------------------------
    // MARK: ----------EVENTS----------
    //--------------------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    //----------------------------------------------------
    
    void oscSent(int time);
    void oscEvent(int time);
    
    int sentTime, receivedTime;
    bool oscSendLight = false;
    bool oscReceiveLight = false;
    
    //----------------------------------------------------
    
private:
};


#endif
