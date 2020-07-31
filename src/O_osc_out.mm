#include "O_osc.h"
//--------------------------------------------------------------

void OSC::sendChannel(string parameter) {
    if (!noneSelected) { //IF A CHANNEL IS SELECTED
        ofxOscMessage m;
        for (int i = 1; i >= 0; i--) { //SEND NEXT OR LAST KEY
            m.clear();
            m.setAddress("eos/user/" + inputID + "/key/" + parameter);
            m.addStringArg(ofToString(i));
            sender.sendMessage(m, false);
        }
    }
}
//--------------------------------------------------------------

void OSC::sendChannelNumber(string parameter) {
    ofxOscMessage m;
    m.setAddress("/eos/user" + inputID + "/cmd/" + parameter + "#");
    sender.sendMessage(m, false);
}

//--------------------------------------------------------------

void OSC::sendHigh() {
    ofxOscMessage m;
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/enter");
        m.addStringArg(ofToString(i));
        sender.sendMessage(m, false);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/highlight");
        m.addStringArg(ofToString(i));
        sender.sendMessage(m, false);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/enter");
        m.addStringArg(ofToString(i));
        sender.sendMessage(m, false);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("/eos/user/" + inputID + "/key/select_last");
        m.addStringArg(ofToString(i));
        sender.sendMessage(m, false);
    }
    for (int i = 1; i >= 0; i--) {
        m.clear();
        m.setAddress("eos/user/" + inputID + "/key/enter");
        m.addStringArg(ofToString(i));
        sender.sendMessage(m, false);
    }
}

//--------------------------------------------------------------

void OSC::sendFlash(string parameter) {
    ofxOscMessage m;
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
    sender.sendMessage(m, false);
}

//--------------------------------------------------------------

void OSC::sendThrust(string parameter, int message) {
    ofxOscMessage m;
    m.setAddress("/eos/user/" + inputID + "/param/frame thrust " + parameter);
    m.addFloatArg(message);
    sender.sendMessage(m, false);
}

//--------------------------------------------------------------

void OSC::sendAngle(string parameter, int message) {
    ofxOscMessage m;
    m.setAddress("/eos/user/" + inputID + "/param/frame angle " + parameter);
    m.addFloatArg(message);
    sender.sendMessage(m, false);
}

//--------------------------------------------------------------

void OSC::sendShutterHome(string parameter) {
    if (!noneSelected) { //IF A CHANNEL IS SELECTED
        ofxOscMessage a,b,c,d;
        if (parameter == "THRUST") {
            a.setAddress("/eos/user/" + inputID + "/param/frame thrust a/home");
            b.setAddress("/eos/user/" + inputID + "/param/frame thrust b/home");
            c.setAddress("/eos/user/" + inputID + "/param/frame thrust c/home");
            d.setAddress("/eos/user/" + inputID + "/param/frame thrust d/home");
        } else if (parameter == "ANGLE") {
            a.setAddress("/eos/user/" + inputID + "/param/frame angle a/home");
            b.setAddress("/eos/user/" + inputID + "/param/frame angle b/home");
            c.setAddress("/eos/user/" + inputID + "/param/frame angle c/home");
            d.setAddress("/eos/user/" + inputID + "/param/frame angle d/home");
        } else if (parameter == "SHUTTER") {
            a.setAddress("/eos/user/" + inputID + "/param/shutter/home");
            b.setAddress("/eos/user/" + inputID + "/param/shutter/home");
            c.setAddress("/eos/user/" + inputID + "/param/shutter/home");
            d.setAddress("/eos/user/" + inputID + "/param/shutter/home");
        }
        sender.sendMessage(a, false); sender.sendMessage(b, false); sender.sendMessage(c, false); sender.sendMessage(d, false);
    }
}

//--------------------------------------------------------------

void OSC::fineEncoder(int message) { //ONLY USED TO RESET OSC TICKS, ONLY CALLED IN CONNECT();
    ofxOscMessage m;
    
    m.setAddress("/eos/user/" + inputID + "/wheel");
    m.addIntArg(message);
    sender.sendMessage(m, false);
}

//--------------------------------------------------------------
void OSC::sendEncoder(string parameter, int message, bool fine){
    if (parameter != "form") {
        ofxOscMessage m;
        float fineAdjust = 2;
        if (fine) {
            fineAdjust = 0.001;
        }
        m.setAddress("/eos/user/" + inputID + "/wheel/" + parameter);
        m.addFloatArg(message * fineAdjust);
        sender.sendMessage(m, false);
    }
}

//--------------------------------------------------------------

void OSC::sendEncoderPercent(string parameter, int message) {
        ofxOscMessage m;
        for (int i = 0; i >= 0; i--) { //SEND ENTER
            m.clear();
            m.setAddress("/eos/user/" + inputID + "/key/enter");
            m.addIntArg(i);
            sender.sendMessage(m, false);
        }
        for (int i = 0; i >= 0; i--) { //SEND SELECT_LAST
            m.clear();
            m.setAddress("/eos/user/" + inputID + "/key/select_last");
            m.addIntArg(i);
            sender.sendMessage(m, false);
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
        sender.sendMessage(m, false);
}

//--------------------------------------------------------------

void OSC::sendPing() {
    ofxOscMessage m;
    
    m.setAddress("/eos/ping");
    sender.sendMessage(m, false);
}

//--------------------------------------------------------------
