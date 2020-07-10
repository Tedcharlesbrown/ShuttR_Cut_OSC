#include "O_osc.h"

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
