#pragma once

#include "ofxiOS.h"
#include "A_ofApp.h"
#include "C_keyboard.h"
#include "D_button.h"
#include "D_bank.h"
#include "D_encoder.h"

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
    
    BUTTON shutterPage, encoderPage, directSelectPage, panTiltPage, minusButton, plusButton, fineButton, highButton, flashButton, channelButton;
    
    //--------------------------------------------------------------
    // MARK: ----------SHUTTER PAGE----------
    //--------------------------------------------------------------
    
    void shutterPageSetup();
    void shutterPageUpdate();
    void shutterPageDraw();
    void assemblyColor();
    void assemblyBG();
    
    void shutterPageTouchDown(ofTouchEventArgs & touch);
    void shutterPageTouchMoved(ofTouchEventArgs & touch);
    void shutterPageTouchUp(ofTouchEventArgs & touch);
    void shutterPageDoubleTap(ofTouchEventArgs & touch);
    
    ofImage bgAssembly;
    THRUST_HANDLE thrustA, thrustB, thrustC, thrustD;
    ANGLE_HANDLE angleA, angleB, angleC, angleD;
    ASSEMBLY_HANDLE assembly;
    
    BUTTON thrustButton, angleButton, shutterButton;
    
    //--------------------------------------------------------------
    // MARK: ----------PAN TILT PAGE----------
    //--------------------------------------------------------------
    
    void panTiltPageSetup();
    void panTiltPageUpdate();
    void panTiltPageDraw();
    
    void panTiltPageTouchDown(ofTouchEventArgs & touch);
    void panTiltPageTouchMoved(ofTouchEventArgs & touch);
    void panTiltPageTouchUp(ofTouchEventArgs & touch);
    void panTiltPageDoubleTap(ofTouchEventArgs & touch);
    
    ENCODER focusEncoder;
    string panPercent, tiltPercent, focusParameter, panTiltShow = "";
    
    BUTTON panButton, tiltButton;
    
    //--------------------------------------------------------------
    // MARK: ----------ENCODER PAGE----------
    //--------------------------------------------------------------
    
    void encoderPageSetup();
    void encoderPageUpdate();
    void encoderPageDraw();
    
    void encoderPageTouchDown(ofTouchEventArgs & touch);
    void encoderPageTouchMoved(ofTouchEventArgs & touch);
    void encoderPageTouchUp(ofTouchEventArgs & touch);
    void encoderPageDoubleTap(ofTouchEventArgs & touch);
    
    ENCODER formEncoder;
    string irisPercent, edgePercent, zoomPercent, frostPercent, formParameter, parameterShow = "";
    
    BUTTON irisButton, edgeButton, zoomButton, frostButton, minusPercentButton, homeButton, plusPercentButton;
    
    //--------------------------------------------------------------
    // MARK: ----------DIRECT SELECT PAGE----------
    //--------------------------------------------------------------
    
    void DSPageSetup();
    void DSPageUpdate();
    void DSPageDraw();
    
    void DSPageTouchDown(ofTouchEventArgs & touch);
    void DSPageTouchMoved(ofTouchEventArgs & touch);
    void DSPageTouchUp(ofTouchEventArgs & touch);
    void DSPageDoubleTap(ofTouchEventArgs & touch);
    
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
    
    bool oscSendLight = false;
    bool oscReceiveLight = false;
    
    //----------------------------------------------------
    
private:
};
