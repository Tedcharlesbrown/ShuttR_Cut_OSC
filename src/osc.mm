#include "O_osc.h"

//--------------------------------------------------------------
void OSC::sendEncoder(string userID, string ID, int message){
    ofxOscMessage m;
    m.setAddress("/eos/user/" + userID + "/wheel/" + ID);
    m.addIntArg(message);
    sender.sendMessage(m, false);
}
