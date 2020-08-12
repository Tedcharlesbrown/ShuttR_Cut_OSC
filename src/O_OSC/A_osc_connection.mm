#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::connect() {
    eos.close();
    eos.setup(inputIP, 3032);
    fineEncoder(0);
    
    connectRequest = false;
}

//--------------------------------------------------------------

void ofApp::checkConnection() {
}

//--------------------------------------------------------------
