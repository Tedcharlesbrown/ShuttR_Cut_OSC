#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::sendIntensity(ofVec2f & oscOutput) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    if (oscOutput.x == 0) {
        m.setAddress("/eos/user/" + inputID + "/param/intensity");
        m.addFloatArg(oscOutput.y);
        eos.sendMessage(m);
    } else if (oscOutput.x < 4) {
        int switchCase = oscOutput.x;
        string address = "/eos/user/" + inputID + "/param/intensity/";
        switch(switchCase) {
            case 1: address += "full"; break;
            case 2: address += "level"; break;
            case 3: address += "out"; break;
        }
        m.setAddress(address);
        eos.sendMessage(m);
    } else {
        sendKey("clear_cmdline");
        sendKey("select_last");
        if (oscOutput.x == 4) {
            sendKey("-%");
        } else if (oscOutput.x == 5) {
            sendKey("+%");
        } else {
            sendKey("intensity");
            if (oscOutput.x == 6) {
                sendKey("sneak");
            } else {
                sendKey("home");
            }
            sendKey("enter");
        }
    }
}

//--------------------------------------------------------------

void ofApp::sendSneak(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    
    sendKey("clear_cmdline");
    sendKey("select_last");
    sendKey(parameter);
    sendKey("sneak");
    sendKey("enter");
}

//--------------------------------------------------------------

void ofApp::sendChannel(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    
    if (!noneSelected) { //IF A CHANNEL IS SELECTED
        sendKey(parameter);
    }
}
//--------------------------------------------------------------

void ofApp::sendChannelNumber(string parameter) {
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    m.setAddress("/eos/user/" + inputID + "/cmd/" + parameter + "#");
    eos.sendMessage(m);
}

//--------------------------------------------------------------

void ofApp::sendHigh() {
    oscSentTime = ofGetElapsedTimeMillis();
    
    sendKey("clear_cmdline");
    sendKey("highlight");
    sendKey("enter");
    sendKey("select_last");
    sendKey("enter");
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
        ofxEosOscMsg a,b,c,d,m;
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
        sendKey("select_last");
        sendKey("enter");
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
    if (isPaidVersion) {
        oscSentTime = ofGetElapsedTimeMillis();
        
        ofxEosOscMsg m;
        m.setAddress("/eos/user/" + inputID + "/wheel/" + parameter);
        m.addFloatArg(message);
        eos.sendMessage(m);
    }
}

//--------------------------------------------------------------

void ofApp::sendEncoderPercent(string parameter, int message) {
    if (isPaidVersion) {
        oscSentTime = ofGetElapsedTimeMillis();
        
        ofxEosOscMsg m;
        sendKey("enter");
        sendKey("select_last");
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
}

//--------------------------------------------------------------

void ofApp::sendDSPage(string bank, string direction){
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    m.setAddress("eos/user/" + inputID + "/ds/" + bank + "/page/" + direction);
    eos.sendMessage(m);
}
void ofApp::sendDSRequest(string bank, string parameter){
    oscSentTime = ofGetElapsedTimeMillis();
    ofxEosOscMsg m;
    m.setAddress("eos/user/" + inputID + "/ds/" + bank + "/" + parameter + "/1/20");
    eos.sendMessage(m);
}
void ofApp::sendDS(string bank, string buttonID){
    if (isPaidVersion) {
        oscSentTime = ofGetElapsedTimeMillis();
        ofxEosOscMsg m;
        m.setAddress("eos/user/" + inputID + "/ds/" + bank + "/" + buttonID);
        eos.sendMessage(m);
    }
}


//--------------------------------------------------------------

void ofApp::sendPing() {
//    oscSentTime = ofGetElapsedTimeMillis();
    sentPingTime = ofGetElapsedTimeMillis();
    
    ofxEosOscMsg m;
    
    m.setAddress("/eos/ping");
    m.addStringArg(appName);
    eos.sendMessage(m);
}

//--------------------------------------------------------------


void ofApp::sendKey(string key) {
    ofxEosOscMsg m;
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/" + key);
        m.addStringArg(ofToString(i));
        eos.sendMessage(m);
    }
}

void ofApp::sendKey(string key, bool toggle) {
    ofxEosOscMsg m;
    m.setAddress("eos/user/" + inputID + "/key/" + key);
    if (toggle) {
        m.addStringArg("1");
    } else {
        m.addStringArg("0");
    }
    eos.sendMessage(m);
}
