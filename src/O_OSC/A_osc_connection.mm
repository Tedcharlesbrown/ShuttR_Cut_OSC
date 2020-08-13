#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::connect() {
    isConnected = false;
    
    eos.close();
    eos.setup(inputIP, 3032);
    
    
    sendPing();
    fineEncoder(0);
    
    connectRequest = false;
    
    if (!eos.isConnected()) { //IF IP IS NOT VALID
        console_log.push_back("CHECK IP, INVALID ADDRESS");
    }
}

//--------------------------------------------------------------

void ofApp::heartBeat() {
    float elapsedTime = 10000;
    if (!hasWifi) {
        elapsedTime = 1000;
    }
    
    
    deltaTime = ofGetElapsedTimeMillis() - connectTime;
    
//    int seconds = ofGetElapsedTimeMillis() / 1000;
    
//    cout << seconds << ">" << lastPing / 1000 + elapsedTime / 1000  + 1 << endl;
//    cout << deltaTime << ">" << connectTime << endl;
    
//    if (ofGetElapsedTimeMillis() > lastPing + elapsedTime + 1000) {
////        cout << "NOT CONNECTED  " << seconds <<  endl;
//        isConnected = false;
//    }
    
    
    if (deltaTime > elapsedTime) {
        IPAddress = getIPAddress();
    
//        sendPing();
        
        connectTime = ofGetElapsedTimeMillis();
    }
}

//--------------------------------------------------------------

