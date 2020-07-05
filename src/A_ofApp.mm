#include "A_ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    styleInit();
    sender.setup("192.168.0.35",8000);
    receiver.setup(9000);
    
    gui.pageOne.clicked = true;
}
//--------------------------------------------------------------
void ofApp::update(){
    gui.update();
    oscSent();
    oscEvent();
    keyboard.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(EOSBackground);
    
    
    //--------------------------------------------------------------
    gui.topUIShow();
    gui.settingsBar(0,0,width,settingsBarHeight,settingsBarStrokeWeight);
    gui.settingsButton(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonStrokeWeight);
    gui.oscLight("TX", smallButtonWidth / 2, settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    gui.oscLight("RX", smallButtonWidth / 2, settingsBarHeight - settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonStrokeWeight);
    //--------------------------------------------------------------
    
    keyboard.draw();
}
//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    gui.touchDown(touch);
    if (keyboard.show) {
        keyboard.touchDown(touch);
    }
//        gui.oscSent(ofGetElapsedTimeMillis());
//        ofxOscMessage m;
//        m.setAddress("/mouse/button");
//        m.addIntArg(1);
//        m.addStringArg("down");
//        sender.sendMessage(m, false);
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    gui.touchMoved(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    gui.touchUp(touch);
    keyboard.touchUp(touch);
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
