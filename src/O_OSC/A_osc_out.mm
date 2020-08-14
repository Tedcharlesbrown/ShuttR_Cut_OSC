#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::sendChannel(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    if (!noneSelected) { //IF A CHANNEL IS SELECTED
        ofxEosOscMsg m;
        for (int i = 1; i >= 0; i--) { //SEND NEXT OR LAST KEY
            m.clear();
            m.setAddress("eos/user/" + inputID + "/key/" + parameter);
            m.addStringArg(ofToString(i));
            eos.sendMessage(m);
        }
    }
}
//--------------------------------------------------------------

void ofApp::sendChannelNumber(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    m.setAddress("/eos/user" + inputID + "/cmd/" + parameter + "#");
    eos.sendMessage(m);
}

//--------------------------------------------------------------

void ofApp::sendHigh() {
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/enter");
        m.addStringArg(ofToString(i));
        eos.sendMessage(m);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/highlight");
        m.addStringArg(ofToString(i));
        eos.sendMessage(m);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/enter");
        m.addStringArg(ofToString(i));
        eos.sendMessage(m);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("/eos/user/" + inputID + "/key/select_last");
        m.addStringArg(ofToString(i));
        eos.sendMessage(m);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/enter");
        m.addStringArg(ofToString(i));
        eos.sendMessage(m);
    }
}

//--------------------------------------------------------------

void ofApp::sendFlash(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    bool released = false;
    string OSCPrefix = "";
    if (parameter == "FLASH_OFF") {
        OSCPrefix = "eos/user/" + inputID + "/key/flash_off";
    } else if (parameter == "FLASH_ON") {
        OSCPrefix = "eos/user/" + inputID + "/key/flash_on";
    } else if (parameter == "OFF") {
        OSCPrefix = "eos/user/" + inputID + "/key/flash_on";
        released = true;
    }
    m.clear();
    m.setAddress(OSCPrefix);
    if (released) {
        m.addStringArg("0");
    } else {
        m.addStringArg("1");
    }
    eos.sendMessage(m);
}

//--------------------------------------------------------------

void ofApp::sendShutter(string parameter, string ID, int message) {
    oscSentTime = ofGetElapsedTimeMillis();
    ignoreOSC = true;
    
    ofxEosOscMsg m;
    if (parameter == "THRUST") {
        m.setAddress("/eos/user/" + inputID + "/param/frame thrust " + ID);
    } else if (parameter == "ANGLE") {
        m.setAddress("/eos/user/" + inputID + "/param/frame angle " + ID);
    } else if (parameter == "ASSEMBLY") {
        m.setAddress("/eos/user/" + inputID + "/param/frame assembly");
    }
    m.addFloatArg(message);
    eos.sendMessage(m);
}

//--------------------------------------------------------------

void ofApp::sendShutterHome(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    if (!noneSelected) { //IF A CHANNEL IS SELECTED
        ofxEosOscMsg a,b,c,d;
        if (parameter == "THRUST") {
            a.setAddress("/eos/user/" + inputID + "/param/frame thrust a/home");
            b.setAddress("/eos/user/" + inputID + "/param/frame thrust b/home");
            c.setAddress("/eos/user/" + inputID + "/param/frame thrust c/home");
            d.setAddress("/eos/user/" + inputID + "/param/frame thrust d/home");
            eos.sendMessage(a); eos.sendMessage(b); eos.sendMessage(c); eos.sendMessage(d);
        } else if (parameter == "ANGLE") {
            a.setAddress("/eos/user/" + inputID + "/param/frame angle a/home");
            b.setAddress("/eos/user/" + inputID + "/param/frame angle b/home");
            c.setAddress("/eos/user/" + inputID + "/param/frame angle c/home");
            d.setAddress("/eos/user/" + inputID + "/param/frame angle d/home");
            eos.sendMessage(a); eos.sendMessage(b); eos.sendMessage(c); eos.sendMessage(d);
        } else if (parameter == "SHUTTER") {
            a.setAddress("/eos/user/" + inputID + "/param/shutter/home");
            eos.sendMessage(a);
        }
//        eos.sendMessage(a); eos.sendMessage(b); eos.sendMessage(c); eos.sendMessage(d);
    }
}

//--------------------------------------------------------------

void ofApp::fineEncoder(int message) { //ONLY USED TO RESET OSC TICKS, ONLY CALLED IN CONNECT();
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    m.setAddress("/eos/user/" + inputID + "/wheel");
    m.addIntArg(message);
    eos.sendMessage(m);
}

//--------------------------------------------------------------
void ofApp::sendEncoder(string parameter, float message){
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    m.setAddress("/eos/user/" + inputID + "/wheel/" + parameter);
    m.addFloatArg(message);
    eos.sendMessage(m);
}

//--------------------------------------------------------------

void ofApp::sendEncoderPercent(string parameter, int message) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    for (int i = 0; i >= 0; i--) { //SEND ENTER
        m.clear();
        m.setAddress("/eos/user/" + inputID + "/key/enter");
        m.addIntArg(i);
        eos.sendMessage(m);
    }
    for (int i = 0; i >= 0; i--) { //SEND SELECT_LAST
        m.clear();
        m.setAddress("/eos/user/" + inputID + "/key/select_last");
        m.addIntArg(i);
        eos.sendMessage(m);
    }
    m.clear();
    switch(message) {
        case -1:
            m.setAddress("/eos/user/" + inputID + "/param/" + parameter + "/-%");
            break;
        case 0:
            m.setAddress("/eos/user/" + inputID + "/param/" + parameter + "/home");
            break;
        case 1:
            m.setAddress("/eos/user/" + inputID + "/param/" + parameter + "/+%");
            break;
    }
    eos.sendMessage(m);
}

//--------------------------------------------------------------

void ofApp::sendDSPage(string bank, string direction){
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    m.setAddress("eos/user/" + inputID + "/ds/" + bank + "/page/" + direction);
    eos.sendMessage(m);
}
void ofApp::sendDSRequest(string bank, string parameter, string buttonID){
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    m.setAddress("eos/user/" + inputID + "/ds/" + bank + "/" + parameter + "/1/" + buttonID); //BUTTON ID ONLY NEEDED FOR TRYING TO GET CUSTOM SELECTS
    eos.sendMessage(m);
}
void ofApp::sendDS(string bank, string buttonID){
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    m.setAddress("eos/user/" + inputID + "/ds/" + bank + "/" + buttonID);
    eos.sendMessage(m);
}


//--------------------------------------------------------------

void ofApp::sendPing() {
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    
    m.setAddress("/eos/ping");
    eos.sendMessage(m);
}

//--------------------------------------------------------------
