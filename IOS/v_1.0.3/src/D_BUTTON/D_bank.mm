#include "A_ofApp.h"

//--------------------------------------------------------------
void BANK::setup(int _ID){
    this-> ID = _ID;
    buttonSize = smallButtonWidth / 1.1;
    directSelectSize = (((height - notchHeight) / 2) / 4) - ((buttonSize * 2) / 5);
    if (directSelectSize > buttonSize) {
        directSelectSize = buttonSize;
    }
    bankHeight = buttonSize * 1.1 + directSelectSize * 4;
    
    oneAlign = guiCenterAlign - buttonSize * 2.2;
    twoAlign = guiCenterAlign - buttonSize * 1.1;
    middleAlign = guiCenterAlign;
    fourAlign = guiCenterAlign + buttonSize * 1.1;
    fiveAlign = guiCenterAlign + buttonSize * 2.2;
    
    selected = "DIRECT";
    colorSelect = black;
    
    totalSelects = 20;
    for (int i = 0; i <= totalSelects; i++) {
        directSelect.push_back(button);
        bankText.push_back("");
        bankNumber.push_back("");
    }
    totalPalettes = 12;
    for (int i = 0; i <= totalPalettes; i++) {
        palette.push_back(button);
    }
    
    dSelectVector.x = ID; //SET BANK ID FOR EVENT LISTENER
}
//--------------------------------------------------------------
void BANK::update(){
    if (leftButton.action) {
        dSelectPage.set(ID,-1);
        sendPage();
        leftButton.action = false; quickButton.clicked = false;
    } else if (rightButton.action) {
        dSelectPage.set(ID,1);
        sendPage();
        rightButton.action = false; quickButton.clicked = false;
    }
    
    if (palette.at(12).action) { //FLEXI
        if (palette.at(12).clicked) {
            dSelectVector.w = 1;
        } else {
            dSelectVector.w = 0;
        }
        sendOSC();
        palette.at(12).action = false;
    }
    
    for (int i = 0; i <= totalSelects; i++) {
        if (directSelect.at(i).action) {
            dSelectVector.y = 0; //RESET PARAMETER
            dSelectVector.z = i+1;
            sendOSC();
            directSelect.at(i).action = false;
        }
    }
    
    quickSelectAction();
}

//--------------------------------------------------------------
void BANK::draw(float _padding){
    this-> padding = _padding;
    leftButton.show("<", oneAlign, padding, buttonSize, buttonHeight, "MEDIUM");
    
    quickButton.show(selected, "SELECTS", middleAlign, padding, genericButtonWidth * 2, buttonHeight, "MEDIUM", colorSelect);
    
    rightButton.show(">", fiveAlign, padding, buttonSize, buttonHeight, "MEDIUM");
    
    int x = 0;
    float y = 0.9;
    for (int i = 0; i < totalSelects; i++) {
        x = i % 5;
        switch(x) {
        case 0: align = oneAlign; break;
        case 1: align = twoAlign; break;
        case 2: align = middleAlign; break;
        case 3: align = fourAlign; break;
        case 4: align = fiveAlign; break;
        }
        directSelect.at(i).showDS(bankText.at(i), bankNumber.at(i), align, padding + directSelectSize * (y + y * 0.1), buttonSize, directSelectSize, colorSelect);
        if (x == 4) {
            y++;
        }
    }
    
    if (quickButton.clicked) {
        ofPushStyle();
        ofSetColor(EOSBackground, 150);
        ofDrawRectangle(0, padding + buttonSize / 2 - buttonStrokeWeight, width, padding + (buttonSize * 3.3) + buttonSize / 2 + buttonStrokeWeight);
        ofPopStyle();
    }
}

//--------------------------------------------------------------

void BANK::quickSelectsShow() {
    float DSRowOne = padding + buttonSize * 1.5;
    
    palette.at(0).show("CHAN", oneAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSChannel);
    palette.at(1).show("GROUP", twoAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSGroup);
    palette.at(2).show("INTENS.", "PALETTE", middleAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSIntensity);
    palette.at(3).show("FOCUS", "PALETTE", fourAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSFocus);
    palette.at(4).show("COLOR", "PALETTE", fiveAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSColor);
    
    palette.at(5).show("BEAM", "PALETTE", oneAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSBeam);
    palette.at(6).show("PRESET", twoAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSPreset);
    palette.at(7).show("MACRO", middleAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSMacro);
    palette.at(8).show("EFFECTS", fourAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSfx);
    palette.at(9).show("SNAP", fiveAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSSnap);
    
    palette.at(10).show("MAGIC", "SHEET", oneAlign, DSRowOne + buttonSize * 2.2, buttonSize, buttonSize, "SMALL", EOSMagic);
    palette.at(11).show("SCENE", twoAlign, DSRowOne + buttonSize * 2.2, buttonSize, buttonSize, "SMALL", EOSScene);
    
    palette.at(12).show("FLEXI", fourAlign, DSRowOne + buttonSize * 2.2, buttonSize * 2, buttonSize, "MEDIUM");
}

//--------------------------------------------------------------

void BANK::quickSelectAction() {
    
    for (int i = 0; i <= totalPalettes - 1; i++) {
        if (palette.at(i).action) {
            quickButton.clicked = false;
            palette.at(i).action = false;
            for (int j = i + 1; j <= totalPalettes - 1; j++) { //ITERATE FORWARDS AND CLICK OFF
                palette.at(j).clicked = false;
            }
            for (int j = i - 1; j >= 0; j--) { //ITERATE BACKWARDS AND CLICK OFF
                palette.at(j).clicked = false;
            }
            dSelectVector.z = 0; //RESET BUTTON ID
            switch(i) {
                case 0:
                    dSelectVector.y = 1;
                    selected = "CHANNEL"; colorSelect = EOSChannel; break;
                case 1:
                    dSelectVector.y = 2;
                    selected = "GROUP"; colorSelect = EOSGroup; break;
                case 2:
                    dSelectVector.y = 3;
                    selected = "INTENSITY"; colorSelect = EOSIntensity; break;
                case 3:
                    dSelectVector.y = 4;
                    selected = "FOCUS"; colorSelect = EOSFocus; break;
                case 4:
                    dSelectVector.y = 5;
                    selected = "COLOR"; colorSelect = EOSColor; break;
                case 5:
                    dSelectVector.y = 6;
                    selected = "BEAM"; colorSelect = EOSBeam; break;
                case 6:
                    dSelectVector.y = 7;
                    selected = "PRESET"; colorSelect = EOSPreset; break;
                case 7:
                    dSelectVector.y = 8;
                    selected = "MACRO"; colorSelect = EOSMacro;  break;
                case 8:
                    dSelectVector.y = 9;
                    selected = "EFFECT"; colorSelect = EOSfx;  break;
                case 9:
                    dSelectVector.y = 10;
                    selected = "SNAP"; colorSelect = EOSSnap; break;
                case 10:
                    dSelectVector.y = 11;
                    selected = "MAGIC SHEET"; colorSelect = EOSMagic; break;
                case 11:
                    dSelectVector.y = 12;
                    selected = "SCENE"; colorSelect = EOSScene; break;
            }
            sendOSC();
        }
    }
    
}

//--------------------------------------------------------------
void BANK::touchDown(ofTouchEventArgs & touch){
    leftButton.touchDown(touch); quickButton.touchDown(touch, true); rightButton.touchDown(touch);
    if (quickButton.clicked) {
        for (int i = 0; i <= totalPalettes - 1; i++) {
            palette.at(i).touchDown(touch, false);
        }
        palette.at(12).touchDown(touch, true); //FLEXI
    } else {
        for (int i = 0; i <= totalSelects; i++) {
            directSelect.at(i).touchDown(touch);
        }
    }
}

//--------------------------------------------------------------
void BANK::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void BANK::touchUp(ofTouchEventArgs & touch){
    leftButton.touchUp(touch); rightButton.touchUp(touch);
    if (!quickButton.clicked) {
        for (int i = 0; i <= totalSelects; i++) {
            directSelect.at(i).touchUp(touch);
        }
    }
}

//--------------------------------------------------------------
void BANK::touchDoubleTap(ofTouchEventArgs & touch){

}
