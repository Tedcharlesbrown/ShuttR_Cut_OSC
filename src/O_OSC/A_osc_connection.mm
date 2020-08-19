#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::connect() {
//    isConnected = false;
    
    saveXML();
    
    eos.close();
    eos.setup(inputIP, 3032);
    
    console_log.push_back(log_Connecting + inputIP);
    
    connectRequest = true;
}

//--------------------------------------------------------------

void ofApp::checkConnection() {
    if (ofGetElapsedTimeMillis() > lastPing) {
        isConnected = false;
    }
    connectRequest = false;
}

//--------------------------------------------------------------

void ofApp::heartBeat() {
    float checkTime = 10000;
    
    if (!hasWifi) {
        checkTime = 1000;
    }
    
    deltaTime = ofGetElapsedTimeMillis() - connectTime;
        
    if (deltaTime > checkTime || connectRequest) {
        IPAddress = getIPAddress();
    
        sendPing();
//        fineEncoder(0);
        
        checkConnection();
    }
}

//--------------------------------------------------------------

