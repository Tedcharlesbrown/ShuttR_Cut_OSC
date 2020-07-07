#include "C_keyboard.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
void KEYBOARD::update(){
    if (zeroButton.action) {
        input += "0";
        zeroButton.action = false;
    } else if (oneButton.action) {
        input += "1";
        oneButton.action = false;
    } else if (twoButton.action) {
        input += "2";
        twoButton.action = false;
    } else if (threeButton.action) {
        input += "3";
        threeButton.action = false;
    } else if (fourButton.action) {
        input += "4";
        fourButton.action = false;
    } else if (fiveButton.action) {
        input += "5";
        fiveButton.action = false;
    } else if (sixButton.action) {
        input += "6";
        sixButton.action = false;
    } else if (sevenButton.action) {
        input += "7";
        sevenButton.action = false;
    } else if (eightButton.action) {
        input += "8";
        eightButton.action = false;
    } else if (nineButton.action) {
        input += "9";
        nineButton.action = false;
    } else if (dotButton.action) {
        input += ".";
        dotButton.action = false;
    } else if (clearButton.action) {
        clearButton.action = false;
        if (input.length() > 0) {
            input = input.substr(0, input.length() - 1);
        } else {
            return;
        }
    } else if (enterButton.action) {
        enter = true;
        enterButton.action = false;
    }
}

void KEYBOARD::open() {
    show = true;
}

void KEYBOARD::close() {
    show = false;
    clickedOff = false;
    enter = false;
}

//--------------------------------------------------------------
void KEYBOARD::draw(){
    float buttonWidth = plusMinusButtonWidth;
    float buttonPadding = buttonWidth * 1.25;
    
    ofPushMatrix();
    
    if (!show) {
        if (slide < 1){
            slide += 0.05;
        }
    } else if (show) {
        if (slide > 0) {
            slide -= 0.05;
        }
        
    }
    
    ofClamp(slide, 0,1);
    ofTranslate(0, height * slide);
    
    ofPushStyle();
    ofSetRectMode(OF_RECTMODE_CENTER);
    ofSetColor(0,150);
    ofDrawRectRounded(guiCenterAlign, row5Padding - buttonHeight * 2.5, buttonPadding * 3.5, buttonHeight * 8, buttonCorner * 5);
    ofPopStyle();
    
    enterButton.show("ENTER",guiCenterAlign,row5Padding,buttonWidth * 2,buttonHeight,"LARGE");
    
    clearButton.show("CLEAR",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
    zeroButton.show("0", guiCenterAlign, row5Padding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
    dotButton.show(".",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
    
    oneButton.show("1",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
    twoButton.show("2", guiCenterAlign, row5Padding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
    threeButton.show("3",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
    
    fourButton.show("4",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
    fiveButton.show("5", guiCenterAlign, row5Padding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
    sixButton.show("6",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
    
    sevenButton.show("7",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
    eightButton.show("8", guiCenterAlign, row5Padding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
    nineButton.show("9",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
    
    ofPopMatrix();
}

//--------------------------------------------------------------
void KEYBOARD::touchDown(ofTouchEventArgs & touch){
    enterButton.touchDown(touch);
    
    clearButton.touchDown(touch);
    zeroButton.touchDown(touch);
    dotButton.touchDown(touch);
    
    oneButton.touchDown(touch);
    twoButton.touchDown(touch);
    threeButton.touchDown(touch);
    
    fourButton.touchDown(touch);
    fiveButton.touchDown(touch);
    sixButton.touchDown(touch);
    
    sevenButton.touchDown(touch);
    eightButton.touchDown(touch);
    nineButton.touchDown(touch);

    //ofDrawRectRounded(guiCenterAlign, row5Padding - buttonHeight * 2.5, buttonWidth * 4, buttonHeight * 8, buttonCorner * 10);
    
    if (touch.y < (row5Padding - buttonHeight * 2.5) - (buttonHeight * 4)) {
        clickedOff = true;
    }
}

//--------------------------------------------------------------
void KEYBOARD::touchUp(ofTouchEventArgs & touch){
    enterButton.touchUp(touch);
    
    clearButton.touchUp(touch);
    zeroButton.touchUp(touch);
    dotButton.touchUp(touch);
    
    oneButton.touchUp(touch);
    twoButton.touchUp(touch);
    threeButton.touchUp(touch);
    
    fourButton.touchUp(touch);
    fiveButton.touchUp(touch);
    sixButton.touchUp(touch);
    
    sevenButton.touchUp(touch);
    eightButton.touchUp(touch);
    nineButton.touchUp(touch);
}

//--------------------------------------------------------------
