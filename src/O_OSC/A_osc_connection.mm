#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::connect() {
    saveXML();
        
    eos.close();
    eos.waitForThread();
    eos.setup(inputIP, 3032);
    
    console_log.push_back(log_Connecting + inputIP);
    
    connectRequest = true;
}

//--------------------------------------------------------------

void ofApp::checkConnection() {
    if (ofGetElapsedTimeMillis() > lastPing + 1000) {
        isConnected = false;
    } else {
        if (!isConnected) {
            connect();
        }
    }
    connectRequest = false;
}

//--------------------------------------------------------------

void ofApp::heartBeat() {
    checkTime = 5000;
    
    if (!hasWifi) {
        checkTime = 1000;
    }
    
    deltaTime = ofGetElapsedTimeMillis() - connectTime;
    
    //    if (deltaTime > checkTime || connectRequest) {
    if (connectRequest) {
        
        IPAddress = getIPAddress();
        
        sendPing();
//        fineEncoder(0);
        
        checkConnection();
    }
    
    if (isConnected) {
        if (console_log.back().find(log_Connecting) != string::npos) {
            console_log.push_back(log_YesConnect);
        }
    }
}

//--------------------------------------------------------------

