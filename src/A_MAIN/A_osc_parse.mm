#include "A_ofApp.h"

//--------------------------------------------------------------

void ofApp::shutterPageAddListeners() {
//    ofAddListener(gui.thrustA.buttonA.oscOutputPercent, this, &ofApp::sendThrustA);
//    ofAddListener(gui.thrustB.buttonB.oscOutputPercent, this, &ofApp::sendThrustB);
//    ofAddListener(gui.thrustC.buttonC.oscOutputPercent, this, &ofApp::sendThrustC);
//    ofAddListener(gui.thrustD.buttonD.oscOutputPercent, this, &ofApp::sendThrustD);
//
//    ofAddListener(gui.angleA.oscOutputPercent, this, &ofApp::sendAngleA);
//    ofAddListener(gui.angleB.oscOutputPercent, this, &ofApp::sendAngleB);
//    ofAddListener(gui.angleC.oscOutputPercent, this, &ofApp::sendAngleC);
//    ofAddListener(gui.angleD.oscOutputPercent, this, &ofApp::sendAngleD);
//
//    ofAddListener(gui.assembly.oscOutputPercent, this, &ofApp::sendAssembly);
}

void ofApp::sendThrustA(float & oscOutputPercent){
    osc.sendShutter("THRUST","a",oscOutputPercent);
}
void ofApp::sendThrustB(float & oscOutputPercent){
//    osc.sendShutter("THRUST","b",oscOutputPercent);
}
void ofApp::sendThrustC(float & oscOutputPercent){
//    osc.sendShutter("THRUST","c",oscOutputPercent);
}
void ofApp::sendThrustD(float & oscOutputPercent){
//    osc.sendShutter("THRUST","d",oscOutputPercent);
}

void ofApp::sendAngleA(float & oscOutputPercent){
//    osc.sendShutter("ANGLE","a",oscOutputPercent);
}
void ofApp::sendAngleB(float & oscOutputPercent){
//    osc.sendShutter("ANGLE","b",oscOutputPercent);
}
void ofApp::sendAngleC(float & oscOutputPercent){
//    osc.sendShutter("ANGLE","c",oscOutputPercent);
}
void ofApp::sendAngleD(float & oscOutputPercent){
//    osc.sendShutter("ANGLE","d",oscOutputPercent);
}

void ofApp::sendAssembly(float & oscOutputPercent){
//    osc.sendShutter("ASSEMBLY","a",oscOutputPercent);
}
