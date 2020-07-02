#include "ofApp.h"

float centerX, width, height;

//--------------------------------------------------------------
void ofApp::setup(){	
    styleInit();
}
//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(EOSBackground);
    //GUI.settingsBar(settingsBarHeight);
    GUI.settingsBar(0,0,width,settingsBarHeight,shutterOutsideStroke,settingsBarStrokeWeight,EOSDarkGrey);
    GUI.settingsButton(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonCorner, shutterOutsideStroke, buttonStrokeWeight, white, black);
    GUI.oscLight("TX", smallButtonWidth / 2, settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonCorner, black, buttonStrokeWeight, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed);
    GUI.oscLight("RX", smallButtonWidth / 2, settingsBarHeight - settingsBarHeight / 4, smallButtonWidth, settingsBarHeight / 2, buttonCorner, black, buttonStrokeWeight, EOSLightGreen, EOSGreen, EOSLightRed, EOSRed);
}
//--------------------------------------------------------------
void ofApp::exit(){
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    GUI.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    GUI.touchMoved(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    GUI.touchUp(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    GUI.touchDoubleTap(touch);
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    GUI.touchCancelled(touch);
    
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
