#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    styleInit();
    sender.setup("192.168.0.35",8000);
    receiver.setup(9000);
}
//--------------------------------------------------------------
void ofApp::update(){
    gui.update();
    oscSent();
    oscEvent();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(EOSBackground);
    gui.settingsBar(0,0,width,settingsBarHeight,shutterOutsideStroke,settingsBarStrokeWeight,EOSDarkGrey);
    gui.settingsButton(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonCorner, shutterOutsideStroke, buttonStrokeWeight, white, black);
    gui.oscLight("TX", smallButtonWidth / 2, settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonCorner, black, buttonStrokeWeight, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed);
    gui.oscLight("RX", smallButtonWidth / 2, settingsBarHeight - settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonCorner, black, buttonStrokeWeight, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed);
    pageOne.pageButton(centerX - genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonCorner, shutterOutsideStroke, buttonStrokeWeight, buttonActive, black);
    pageTwo.pageButton(centerX, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonCorner, shutterOutsideStroke, buttonStrokeWeight, buttonActive, black);
    pageThree.pageButton(centerX + genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonCorner, shutterOutsideStroke, buttonStrokeWeight, buttonActive, black);
}
//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    gui.touchDown(touch);
    pageOne.touchDown(touch);
    pageTwo.touchDown(touch);
    pageThree.touchDown(touch);
//    gui.oscSent(ofGetElapsedTimeMillis());
//    ofxOscMessage m;
//    m.setAddress("/mouse/button");
//    m.addIntArg(1);
//    m.addStringArg("down");
//    sender.sendMessage(m, false);
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    gui.touchMoved(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    gui.touchUp(touch);
    pageOne.touchUp(touch);
    pageTwo.touchUp(touch);
    pageThree.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    gui.touchDoubleTap(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    gui.touchCancelled(touch);
    
}

//--------------------------------------------------------------


void ofApp::oscSent(){
    
}


void ofApp::oscEvent() {
    while(receiver.hasWaitingMessages()){
        // get the next message
        gui.oscEvent(ofGetElapsedTimeMillis());
        ofxOscMessage m;
        receiver.getNextMessage(m);
    }
}


//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}
