#include "C_keyboard.h"
#include "A_ofApp.h"

//--------------------------------------------------------------
void KEYBOARD::update(){
    if (zeroButton.action) {
        userInput += "0";
        zeroButton.action = false;
    } else if (oneButton.action) {
        userInput += "1";
        oneButton.action = false;
    } else if (twoButton.action) {
        userInput += "2";
        twoButton.action = false;
    } else if (threeButton.action) {
        userInput += "3";
        threeButton.action = false;
    } else if (fourButton.action) {
        userInput += "4";
        fourButton.action = false;
    } else if (fiveButton.action) {
        userInput += "5";
        fiveButton.action = false;
    } else if (sixButton.action) {
        userInput += "6";
        sixButton.action = false;
    } else if (sevenButton.action) {
        userInput += "7";
        sevenButton.action = false;
    } else if (eightButton.action) {
        userInput += "8";
        eightButton.action = false;
    } else if (nineButton.action) {
        userInput += "9";
        nineButton.action = false;
    } else if (dotButton.action) {
        userInput += ".";
        dotButton.action = false;
    } else if (clearButton.action) {
        clearButton.action = false;
        if (userInput.length() > 0) {
            userInput = userInput.substr(0, userInput.length() - 1);
        } else {
            return;
        }
    } else if (enterButton.action) {
        enter = true;
        enterButton.action = false;
    }
}

void KEYBOARD::open(bool _open) {
    show = _open;
    if (!show) {
        clickedOff = false;
        enter = false;
    }
}

//--------------------------------------------------------------
void KEYBOARD::draw(){
    float buttonWidth = genericButtonWidth;
    float buttonPadding = buttonWidth * 1.1;
    
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
    ofDrawRectRounded(guiCenterAlign, row5Padding - buttonHeight * 2.5, buttonWidth * 4, buttonHeight * 8, buttonCorner * 10);
    ofPopStyle();
    
    enterButton.show("ENTER",guiCenterAlign,row5Padding,buttonWidth * 2,buttonHeight,"LARGE");
    
    clearButton.show("CLEAR",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
    zeroButton.show("0", guiCenterAlign, row5Padding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
    dotButton.show(".",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 1.25, genericButtonWidth, buttonHeight, "MEDIUM");
    
    oneButton.show("1",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
    twoButton.show("2", guiCenterAlign, row5Padding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
    threeButton.show("3",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 2.5, genericButtonWidth, buttonHeight, "MEDIUM");
    
    fourButton.show("4",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
    fiveButton.show("5", guiCenterAlign, row5Padding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
    sixButton.show("6",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 3.75, genericButtonWidth, buttonHeight, "MEDIUM");
    
    sevenButton.show("7",guiCenterAlign - buttonPadding, row5Padding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
    eightButton.show("8", guiCenterAlign, row5Padding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
    nineButton.show("9",guiCenterAlign + buttonPadding, row5Padding - buttonHeight * 5, genericButtonWidth, buttonHeight, "MEDIUM");
    
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
