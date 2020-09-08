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
    botLimit = centerY - assemblyRadius + clickRadius / 2;
    topLimit = centerY + assemblyRadius - clickRadius;
    defaultY = centerY - clickRadius;
    
    sliderX = guiCenterAlign;
    sliderVector.set(0,0);
    
    fader.load("Fader.png");
    fader.resize(clickDiameter, clickDiameter * 2);
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
    if (homeButton.doubleClicked) {
        sliderVector.x = 6;
        sendOSC();
        homeButton.action = false;
    } else if (homeButton.action) {
        sliderVector.x = 7;
        sendOSC();
        homeButton.action = false;
    }
    
}

//--------------------------------------------------------------

void OVERLAY::draw(){
    if (show) {
        ofPushStyle();
        
        fullButton.show("FULL",guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight,"LARGE");
        levelButton.show("LEVEL",guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight,"LARGE");
        outButton.show("OUT",guiRightAlign,row3Padding,genericButtonWidth,buttonHeight,"LARGE");
        
        minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
        homeButton.show("INTENS.", "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
        plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
        
        ofSetColor(shutterOutsideStroke);
        ofDrawRectRounded(sliderX - assemblyLineWeight / 2, botLimit, assemblyLineWeight, assemblyDiameter - clickRadius, buttonCorner);
        
        // ----------FADER----------
        ofTranslate(sliderX, sliderY);
        fader.draw(-fader.getWidth() / 2,-fader.getHeight() / 2);
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
    
    if (touch.x > sliderX - fader.getWidth() / 2 && touch.x < sliderX + fader.getWidth() / 2 && touch.y > sliderY - fader.getHeight() / 2 && touch.y < sliderY + fader.getHeight() / 2) {
        clicked = true;
        sliderVector.x = 0;
    }
    
    fullButton.touchDown(touch);
    levelButton.touchDown(touch);
    outButton.touchDown(touch);
    
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
    
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
}

void OVERLAY::touchDoubleTap(ofTouchEventArgs & touch){
    homeButton.touchDoubleTap(touch);
}

//--------------------------------------------------------------

void OVERLAY::incomingOSC(float value){
    if (!clicked) {
        sliderY = ofMap(value, 100, 0, botLimit, topLimit);
    }
}
