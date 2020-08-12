#pragma once

#include "ofxiOS.h"

#include "ofxEosOscMsg.h" //TCP OSC
#include "ofxEosSync.h"

#include "ofxXmlSettings.h" //XML

#include <ifaddrs.h> //IP ADDRESS
#include <arpa/inet.h> //IP ADDRESS

#include "C_keyboard.h"
#include "D_button.h"
#include "D_bank.h"
#include "D_encoder.h"

#include "E_shutterHandles.h"

extern bool settingsMenu;

class ofApp : public ofxiOSApp {
    
public:
    //--------------------------------------------------------------
    // MARK: ----------GUI----------
    //--------------------------------------------------------------
    void setup();
    void styleInit();
    void getNotchHeight();
    
    void update();
    void stateUpdate();
    
    void draw();
    
    void channelButtonAction();
    void pageButtonAction();
    void oscLightUpdate();
    
    void buttonAction();
    
    KEYBOARD keyboard;
    
    //--------------------------------------------------------------
    // MARK: ----------XML----------
    //--------------------------------------------------------------
    
    void saveXML();
    void getXML();
    
    ofxXmlSettings XML;

    string xmlStructure;
    string message;

    //--------------------------------------------------------------
    // MARK: ----------TOP BAR----------
    //--------------------------------------------------------------
    
    void topBarDraw();
    void topBarUpdate();
    void settingsBar(float x,float y,float width,float height,float strokeWeight);
    void settingsButton(float x, float y, float width, float height, float weight);
    void oscLight(string ID, float x, float y, float width, float height, float weight);
    
    void statusBarDraw();
    
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
    
    void shutterPageAddListeners();
    void sendThrustA(float & oscOutputPercent);
    void sendThrustB(float & oscOutputPercent);
    void sendThrustC(float & oscOutputPercent);
    void sendThrustD(float & oscOutputPercent);
    
    void sendAngleA(float & oscOutputPercent);
    void sendAngleB(float & oscOutputPercent);
    void sendAngleC(float & oscOutputPercent);
    void sendAngleD(float & oscOutputPercent);
    
    void sendAssembly(float & oscOutputPercent);
    
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
    
    void sendFocusEncoder(float & oscOutputPercent);
    
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
    
    void sendFormEncoder(float & oscOutputPercent);
    
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
    void settingsUpdate();
    void settingsDraw();
    void console();
    void about();
    
    float settingsX, settingsY, settingsWidth, settingsHeight;
    string userInputIP = "";
    string userInputID = "1";
    int keySwitch = 0;
    
    string getIPAddress();
    
    BUTTON ipFieldButton, idFieldButton, incomingButton, outgoingButton, helpButton;
    ofImage settingsHelp;
    
    //--------------------------------------------------------------
    // MARK: ----------TOUCH EVENTS----------
    //--------------------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    
    void lostFocus();
    void gotFocus();
    
    //----------------------------------------------------
    
    bool oscSendLight = false;
    bool oscReceiveLight = false;

    
    //--------------------------------------------------------------
    // MARK: ----------OSC EVENTS----------
    //--------------------------------------------------------------
    
    ofxEosSync eos;
    
    void connect();
    
    // ----------------------- INCOMING OSC -----------------------
    void oscEvent();
    
    void getState(ofxEosOscMsg incomingOSC);
    void getCommandLine(ofxEosOscMsg incomingOSC);
    void getPanTilt(ofxEosOscMsg incomingOSC);
    void getWheel(ofxEosOscMsg incomingOSC);
    void getChannel(ofxEosOscMsg incomingOSC);
    void getColor(ofxEosOscMsg incomingOSC);
    
    void checkConnection();
    
    string multiChannelPrefix = "";
    string noParameter = "";
    
    bool hasShutters = false;
    bool hasIris = false;
    bool hasEdge = false;
    bool hasZoom = false;
    bool hasFrost = false;
    bool hasPanTilt = false;
    
    
    // ----------------------- OUTGOING OSC -----------------------
    void sendPing();
    
    void sendChannel(string parameter);
    void sendChannelNumber(string parameter);
    
    void sendHigh();
    void sendFlash(string parameter);
    
    void sendEncoder(string parameter, float message);
    void fineEncoder(int message);
    void sendEncoderPercent(string parameter, int message);
    
    void sendShutter(string parameter, string ID, int message);
    void sendShutterHome(string parameter);
    
    
private:
};
