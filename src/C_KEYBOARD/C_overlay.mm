#include "C_keyboard.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

void OVERLAY::open() {
    show = true;
    isOffScreen = false;
}

void OVERLAY::close() {
    show = false;
    clickedOff = false;
    isOffScreen = true;
    enter = false;
}

//--------------------------------------------------------------

void OVERLAY::setup(){
    botLimit = centerY - assemblyRadius;
    topLimit = centerY + assemblyRadius;
    defaultY = centerY;
    
    sliderX = guiCenterAlign + genericButtonWidth / 1.25;
    sliderVector.set(0,0);
}

void OVERLAY::update(){
    sliderY = ofClamp(sliderY, botLimit, topLimit);
    sliderVector.y = ofMap(sliderY, botLimit, topLimit, 100, 0);
    
    if (fullButton.action) {
        sliderVector.x = 1;
        sendOSC();
        fullButton.action = false;
    }
    if (levelButton.action) {
        sliderVector.x = 2;
        sendOSC();
        levelButton.action = false;
    }
    if (outButton.action) {
        sliderVector.x = 3;
        sendOSC();
        outButton.action = false;
    }
    if (minusPercentButton.action) {
        sliderVector.x = 4;
        sendOSC();
        minusPercentButton.action = false;
    }
    if (plusPercentButton.action) {
        sliderVector.x = 5;
        sendOSC();
        plusPercentButton.action = false;
    }
    if (sneakButton.action) {
        sliderVector.x = 11;
        sendOSC();
        sneakButton.action = false;
    }
    if (homeButton.action) {
        sliderVector.x = 12;
        sendOSC();
        homeButton.action = false;
    }
}

//--------------------------------------------------------------

void OVERLAY::draw(){
    if (show) {
        ofPushStyle();
        ofSetColor(EOSBackground,230);
        ofDrawRectangle(0, row2Padding + buttonHeight / 2, width, height);
        
        fullButton.show("FULL",guiLeftAlign, row6Padding, genericButtonWidth, buttonHeight,"LARGE");
        levelButton.show("LEVEL",guiLeftAlign, row7Padding, genericButtonWidth, buttonHeight,"LARGE");
        outButton.show("OUT",guiLeftAlign,row8Padding,genericButtonWidth,buttonHeight,"LARGE");
        sneakButton.show("SNEAK",guiLeftAlign,row10Padding,genericButtonWidth,buttonHeight,"LARGE");
        
        minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
        homeButton.show("HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
        plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
        
        ofSetColor(shutterOutsideStroke);
        ofDrawRectRounded(sliderX - assemblyLineWeight / 4, centerY - assemblyRadius, assemblyLineWeight / 2, assemblyDiameter, buttonCorner);
        
        // ----------BUTTON----------
        // OUTSIDE BUTTON
        ofSetColor(shutterFrameStroke);
        ofDrawCircle(sliderX, sliderY, clickRadius);
        // INSIDE BUTTON
        ofSetColor(shutterOutsideStroke);
        ofDrawCircle(sliderX, sliderY, clickRadius - assemblyButtonWeight);
        
        ofPopStyle();
    }
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void OVERLAY::touchDown(ofTouchEventArgs & touch){
    if (touch.y < row2Padding - buttonHeight / 2){
        clickedOff = true;
    }
    if (touch.x > sliderX - clickRadius && touch.x < sliderX + clickRadius && touch.y > sliderY - clickRadius && touch.y < sliderY + clickRadius) {
        clicked = true;
        sliderVector.x = 0;
    }
    fullButton.touchDown(touch);
    levelButton.touchDown(touch);
    outButton.touchDown(touch);
    sneakButton.touchDown(touch);
    
    minusPercentButton.touchDown(touch);
    homeButton.touchDown(touch);
    plusPercentButton.touchDown(touch);
}

//--------------------------------------------------------------

void OVERLAY::touchMoved(ofTouchEventArgs & touch, bool fine){
    if (clicked) {
        if (fine) {
            sliderY += (touch.y - ofGetPreviousMouseY()) / 3;
        } else {
            sliderY += (touch.y - ofGetPreviousMouseY());
        }
        sendOSC();
    }
}


//--------------------------------------------------------------
void OVERLAY::touchUp(ofTouchEventArgs & touch){
    clicked = false;
    fullButton.touchUp(touch);
    levelButton.touchUp(touch);
    outButton.touchUp(touch);
    sneakButton.touchUp(touch);
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
}

//--------------------------------------------------------------

void OVERLAY::incomingOSC(float value){
    if (!clicked) {
        sliderY = ofMap(value, 100, 0, botLimit, topLimit);
    }
}
