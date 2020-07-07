#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::oscInit() {
    //listenTargets.push_back("Intens"); listenTargets.push_back("Thrust A"); listenTargets.push_back("Thrust B"); listenTargets.push_back("Thrust C");
    listenTargets[0] = "Intens"; listenTargets[1] = "Thrust A"; listenTargets[2] = "Angle A"; listenTargets[3] = "Thrust B"; listenTargets[4] = "Angle B";
    listenTargets[5] = "Thrust C"; listenTargets[6] = "Angle C"; listenTargets[7] = "Thrust D"; listenTargets[8] = "Angle D"; listenTargets[9] = "Frame Assembly";
    listenTargets[10] = "Iris"; listenTargets[11] = "Edge"; listenTargets[12] = "Zoom"; listenTargets[13] = "Diffusn";
}

//--------------------------------------------------------------


void ofApp::checkConnection() {
}

//--------------------------------------------------------------


void ofApp::oscSent(){
    //    gui.oscSent(ofGetElapsedTimeMillis());
    //    ofxOscMessage m;
    //    m.setAddress("/mouse/button");
    //    m.addIntArg(1);
    //    m.addStringArg("down");
    //    sender.sendMessage(m, false);
}


void ofApp::oscEvent() {
    while(receiver.hasWaitingMessages()){
        // get the next message
        gui.oscEvent(ofGetElapsedTimeMillis());
        ofxOscMessage m;
        receiver.getNextMessage(m);
        
        if (m.getAddress() == "/eos/out/ping") {
            //SOMEHOW CHECK THE FUCKING CONNECTION
        }
        // ----------------------- GET ALL LIVE / BLIND STATUS -----------------------
        if (m.getAddress() == "/eos/out/event/state") {
            //BLIND = 0
            return;
        }
        // ----------------------- GET ALL CHANNEL DATA -----------------------
        if (m.getAddress() == "/eos/out/active/chan") {
            parseChannel(m.getArgAsString(0));
            return;
        }
        // ----------------------- GET ALL WHEEL PARAMS -----------------------
        for (int i = 0; i < 200; i++) {
            if (m.getAddress() == "/eos/out/active/wheel/" + ofToString(i)) {
                parseWheel(m.getArgAsString(0));
                return;
            }
        }
    }
}

void ofApp::parseWheel(string incomingOSC) {
    
    
    //cout << incomingOSC << endl;
    
//    for (int i = 0; i < sizeof(listenTargets); i++) {
//        if (incomingOSC.find(listenTargets[i]) != std::string::npos) {
//            cout << i << endl;
//        }
//    }
    
    
//    for (std::string & s : listenTargets) {
//        if (incomingOSC.find(s) != std::string::npos) {
//            cout << s << endl;
//        }
//    }
//        if (!incomingOSC.find("Intens")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Thrust A")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Thrust B")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Thrust C")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Thrust D")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Angle A")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Angle B")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Angle C")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Angle D")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Frame Assembly")) {
//            //cout << incomingOSC << endl;
//        } else if (!incomingOSC.find("Iris")) {
//            gui.irisPercent = incomingOSC;
//        } else if (!incomingOSC.find("Edge")) {
//            gui.edgePercent = incomingOSC;
//        } else if (!incomingOSC.find("Zoom")) {
//            gui.zoomPercent = incomingOSC;
//        } else if (!incomingOSC.find("Diffusn")) {
//            gui.frostPercent = incomingOSC;
//        }
}

void ofApp::parseChannel(string incomingOSC) {
    if (incomingOSC.size() > 1) {
        if (incomingOSC.find("@") != string::npos) { //IF NO MATCH, RETURNS REDICULOUSLY HIGH NUMBER
            int indexValueEnd = incomingOSC.find(" ");
            incomingOSC = incomingOSC.substr(0,indexValueEnd);
            selectedChannel = incomingOSC;
        } else {
            selectedChannel = "---";
        }
    }
    
    
    
    
//    if (incomingOSC.size() > 1) {
//        if (incomingOSC.find("@") < 1000) { //IF NO MATCH, RETURNS REDICULOUSLY HIGH NUMBER
//            int indexValueEnd = incomingOSC.find(" ");
//            incomingOSC = incomingOSC.substr(0,indexValueEnd);
//            selectedChannel = incomingOSC;
//        } else {
//            selectedChannel = "---";
//        }
//    }
}

void ofApp::connect() {
    IPAddress = getIPAddress();
    sender.setup(inputIP,ofToInt(inputTX));
    receiver.setup(ofToInt(inputRX));
    connectRequest = false;
    
    //gui.oscSent(ofGetElapsedTimeMillis());
    ofxOscMessage m;
    m.setAddress("/eos/ping");
    sender.sendMessage(m, false);
}
