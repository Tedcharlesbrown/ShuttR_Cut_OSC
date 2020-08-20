#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::connect(bool log) {
    
        
    eos.close();
    eos.waitForThread();
    eos.setup(inputIP, 3032);
    
    if (log) {
        console_log.push_back(log_Connecting + inputIP);
        saveXML();
    }
    
    
    connectRequest = true;
    pingSent = false;
    
    //    if (eos.isConnected()) {
    //        connectRequest = true;
    //        pingSent = false;
    //    } else {
    //        isConnected = false;
    //        console_log.push_back(log_CheckIP);
    //    }
    
}

//--------------------------------------------------------------

void ofApp::checkConnection() {
    
    
    if (receivedPingTime > sentPingTime || ofGetElapsedTimeMillis() > sentPingTime + 3000) { //IF GOT NEW PING OR TIME OUT
        
        if (sentPingTime > receivedPingTime && !hasOSC) { //IF CURRENT TIME IS > NEW PING TIME + BUFFER
            isConnected = false;
            if (console_log.back().find(log_Connecting) != string::npos) {
                console_log.push_back(log_NoConnect);
            }
            if (!isConnected) {
                connect(false);
            }
        } else {
            //             << eos.isConnected() << endl;
            
        }
        connectRequest = false; //RESET
        pingSent = false;       //RESET
    }
}

//--------------------------------------------------------------

void ofApp::heartBeat() {
    checkTime = 10000;
    
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
        
        //        fineEncoder(0);
        
        checkConnection();
        
    }
}

//--------------------------------------------------------------

