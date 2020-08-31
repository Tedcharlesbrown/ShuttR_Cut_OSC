#pragma once

#include "ofxiOS.h"

#include "ofxNetwork.h"

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
    void intensityButtonAction();
    void pageButtonAction();
    void oscLightUpdate();
    
    void buttonAction();
    
    KEYBOARD keyboard;
    OVERLAY intensityOverlay;
    
    //--------------------------------------------------------------
    // MARK: ----------XML----------
    //--------------------------------------------------------------
    
    void saveXML();
    void getXML();
    
    ofxXmlSettings XML;

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
    float settingsX, settingsY, settingsWidth, settingsHeight;
    
    BUTTON shutterPage, formPage, dSelectPage, focusPage, imagePage, minusButton, plusButton, fineButton, highButton, flashButton, channelButton, intensityButton;
    
    //--------------------------------------------------------------
    // MARK: ----------SHUTTER PAGE----------
    //--------------------------------------------------------------
    
    void shutterPageSetup();
    void shutterPageUpdate();
    void shutterPageDraw();
    void assemblyBackground();
    void assemblyFront();
    
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
    
    void focusPageSetup();
    void focusPageUpdate();
    void focusPageDraw();
    
    void focusPageTouchDown(ofTouchEventArgs & touch);
    void focusPageTouchMoved(ofTouchEventArgs & touch);
    void focusPageTouchUp(ofTouchEventArgs & touch);
    void focusPageDoubleTap(ofTouchEventArgs & touch);
    
    void sendFocusEncoder(float & oscOutputPercent);
    
    ENCODER focusEncoder;
    string panPercent, tiltPercent, focusParameter, panTiltShow = "";
    
    BUTTON panButton, tiltButton;
    
    //--------------------------------------------------------------
    // MARK: ----------ENCODER PAGE----------
    //--------------------------------------------------------------
    
    void formPageSetup();
    void formPageUpdate();
    void formPageDraw();
    
    void formPageTouchDown(ofTouchEventArgs & touch);
    void formPageTouchMoved(ofTouchEventArgs & touch);
    void formPageTouchUp(ofTouchEventArgs & touch);
    void formPageDoubleTap(ofTouchEventArgs & touch);
    
    void sendFormEncoder(float & oscOutputPercent);
    
    ENCODER formEncoder;
    string irisPercent, edgePercent, zoomPercent, frostPercent, formParameter, parameterShow = "";
    
    BUTTON irisButton, edgeButton, zoomButton, frostButton, minusPercentButton, homeButton, plusPercentButton;
    
    //--------------------------------------------------------------
    // MARK: ----------IMAGE PAGE----------
    //--------------------------------------------------------------
    
    void imagePageSetup();
    void imagePageUpdate();
    void imagePageDraw();
    
    void imagePageTouchDown(ofTouchEventArgs & touch);
    void imagePageTouchMoved(ofTouchEventArgs & touch);
    void imagePageTouchUp(ofTouchEventArgs & touch);
    void imagePageDoubleTap(ofTouchEventArgs & touch);
    
    ENCODER imageEncoder;
    BUTTON wheelButton;
    vector<BUTTON> imageWheel, imageWheelLeft, imageWheelRight;
    vector<string> wheelSelect, wheelGobo, wheelPercent;
        
    //--------------------------------------------------------------
    // MARK: ----------DIRECT SELECT PAGE----------
    //--------------------------------------------------------------
    
    void DSPageSetup();
    void DSPageUpdate();
    void DSPageDraw();
    
    void parseDirectSelectSend(ofVec4f & dSelectMainInfo);
    void parseDirectSelectPage(ofVec2f & dSelectPageInfo);
    
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
    
    string userInputIP = "";
    string userInputID = "1";
    int keySwitch = 0;
    bool ipChanged = false;

    string getIPAddress();
    
    BUTTON ipFieldButton, idFieldButton;
    
    //--------------------------------------------------------------
    // MARK: ----------TOUCH EVENTS----------
    //--------------------------------------------------------------
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);    
    
    void lostFocus();
    void gotFocus();
    
    //--------------------------------------------------------------
    // MARK: ----------OSC EVENTS----------
    //--------------------------------------------------------------
    
    ofxEosSync eos;
    ofxTCPClient tcp;
    
    bool oscSendLight = false;
    bool oscReceiveLight = false;
    
    void connect(bool connectTCP, bool connectEOS, bool log);
    void connectRunDelay();
    
    void checkConnection();
    
    void pingTimeOut();
    void heartBeat();
    
    bool pingSent = false;
    bool connectDelay = false;
    bool connectRun = false;
    int checkTime;
    unsigned long long sentPingTime = 0;
    unsigned long long deltaTime = 0;
    unsigned long long receivedPingTime = 0;
    
    // ----------------------- INCOMING OSC -----------------------
    void oscEvent();
    
    void getState(ofxEosOscMsg incomingOSC);
    void getCommandLine(ofxEosOscMsg incomingOSC);
    void getPanTilt(ofxEosOscMsg incomingOSC);
    void getWheel(ofxEosOscMsg incomingOSC);
    void getChannel(ofxEosOscMsg incomingOSC);
    void getColor(ofxEosOscMsg incomingOSC);
    void getIntensity(ofxEosOscMsg incomingOSC);
    
    void clearParams();
    
    void getDirectSelect(int bank, int buttonID, ofxEosOscMsg m);
    
    string multiChannelPrefix = "";
    string noParameter = "";
    
    // ----------------------- OUTGOING OSC -----------------------
    void sendPing();
    
    void sendIntensity(ofVec2f & intensityVector);
    void sendSneak(string parameter);
    
    void sendChannel(string parameter);
    void sendChannelNumber(string parameter);
    
    void sendHigh();
    void sendFlash(string parameter);
    
    void sendEncoder(string parameter, float message);
    void fineEncoder(int message);
    void sendEncoderPercent(string parameter, int message);
    
    void sendShutter(string parameter, string ID, int message);
    void sendShutterHome(string parameter);
    
    void sendDSPage(string bank, string direction);
    void sendDSRequest(string bank, string parameter);
    void sendDS(string bank, string buttonID);
    
    // ----------------------- OUTGOING KEY PRESSES -----------------------
    
    void sendKey(string key);
    void sendKey(string key, bool toggle);
    
    
private:
};
