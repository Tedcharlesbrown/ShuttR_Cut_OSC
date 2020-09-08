#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::connect(bool connectTCP,bool connectEOS, bool log) {
    if (log) {
        console_log.push_back(log_Connecting + inputIP);
        saveXML();
    }
    
    if (connectEOS) {
        eos.close();
        eos.waitForThread();
        eos.setup(inputIP, 3032);
    }
    
    if (connectTCP) {
        tcp.close();
        tcp.setup(inputIP, 3032);
        
        if (tcp.isConnected()) {
            connectRequest = true;
            pingSent = false;
        } else {
            isConnected = false;
            if (console_log.back().find(log_Connecting) != string::npos) {
                console_log.push_back(log_NoConnect);
            }
        }
    }
}

//--------------------------------------------------------------

void ofApp::checkConnection() {
    
    if (receivedPingTime > sentPingTime || ofGetElapsedTimeMillis() > sentPingTime + 3000) { //IF GOT NEW PING OR TIME OUT
        
        if (sentPingTime > receivedPingTime && !hasOSC) { //IF CURRENT TIME IS > NEW PING TIME + BUFFER
            isConnected = false;
            if (console_log.back().find(log_Connecting) != string::npos) { //IF LAST IS CONNECTING
                console_log.push_back(log_CheckOSC);
            } else if (console_log.back() == log_YesConnect) {  //IF LAST IS SUCCESFULL CONNECT
                console_log.push_back(log_lostConnect);
            }
            if (!isConnected) {
                connect(false, true, false);
            }
        }
        
        connectRequest = false; //RESET
        pingSent = false;       //RESET
    }
}

//--------------------------------------------------------------

void ofApp::heartBeat() {
    checkTime = 30 * 1000;
    
    if (!hasWifi || !isConnected) {
        checkTime = 3000;
    }
        
    deltaTime = ofGetElapsedTimeMillis() - sentPingTime;
    
    if ((deltaTime > checkTime || connectRequest) && eos.isConnected()) { //IF TIMED PING OR CONNECT REQUEST
        
        if (!pingSent) {
            hasOSC = false; //RESET OSC CONNECTION
            ofSleepMillis(20); //not proud of this //20
            IPAddress = getIPAddress();
            sendPing();
            pingSent = true;
        }
        
        if (!hasWifi) {
            IPAddress = getIPAddress();
        }
        
        //        fineEncoder(0);
        
        checkConnection();
        
    }
}

//--------------------------------------------------------------
