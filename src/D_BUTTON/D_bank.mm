#include "A_ofApp.h"

//--------------------------------------------------------------
void BANK::setup(){
    buttonSize = plusMinusButtonWidth;
    oneAlign = guiCenterAlign - buttonSize * 2.2;
    twoAlign = guiCenterAlign - buttonSize * 1.1;
    middleAlign = guiCenterAlign;
    fourAlign = guiCenterAlign + buttonSize * 1.1;
    fiveAlign = guiCenterAlign + buttonSize * 2.2;
    
    selected = "DIRECT";
    colorSelect = EOSLive;
}
//--------------------------------------------------------------
void BANK::update(){
    if (leftButton.action) {
        leftButton.action = false; quickButton.clicked = false;
    } else if (rightButton.action) {
        rightButton.action = false; quickButton.clicked = false;
    } else if (channelButton.action) { toggleDS(0);
    } else if (groupButton.action) { toggleDS(1);
    } else if (IPButton.action) { toggleDS(2);
    } else if (FPButton.action) { toggleDS(3);
    } else if (CPButton.action) { toggleDS(4);
    } else if (BPButton.action) { toggleDS(5);
    } else if (presetButton.action) { toggleDS(6);
    } else if (macroButton.action) { toggleDS(7);
    } else if (effectsButton.action) { toggleDS(8);
    } else if (snapButton.action) { toggleDS(9);
    } else if (MSButton.action) { toggleDS(10);
    } else if (sceneButton.action) { toggleDS(11);
    }
}

//--------------------------------------------------------------
void BANK::draw(string ID, float _padding){
    this-> padding = _padding;
    
    leftButton.show("<", oneAlign, padding, buttonSize, buttonHeight, "MEDIUM");
    
    quickButton.show(selected, "SELECTS", middleAlign, padding, genericButtonWidth * 2, buttonHeight, "MEDIUM", colorSelect);
    
    rightButton.show(">", fiveAlign, padding, buttonSize, buttonHeight, "MEDIUM");
}

//--------------------------------------------------------------

void BANK::quickSelectsShow() {
    float DSRowOne = padding + buttonSize;
    
    channelButton.show("CHANNEL", oneAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSChannel);
    groupButton.show("GROUP", twoAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSGroup);
    IPButton.show("INTENS.", "PALETTE", middleAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSIntensity);
    FPButton.show("FOCUS", "PALETTE", fourAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSFocus);
    CPButton.show("COLOR", "PALETTE", fiveAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSColor);
    
    BPButton.show("BEAM", "PALETTE", oneAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSBeam);
    presetButton.show("PRESET", twoAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSPreset);
    macroButton.show("MACRO", middleAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSMacro);
    effectsButton.show("EFFECTS", fourAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSfx);
    snapButton.show("SNAP", fiveAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSSnap);
    
    MSButton.show("MAGIC", "SHEET", oneAlign, DSRowOne + buttonSize * 2.2, buttonSize, buttonSize, "SMALL", EOSMagic);
    sceneButton.show("SCENE", twoAlign, DSRowOne + buttonSize * 2.2, buttonSize, buttonSize, "SMALL", EOSScene);
    
    flexiButton.show("FLEXI", fourAlign, DSRowOne + buttonSize * 2.2, buttonSize * 2, buttonSize, "MEDIUM");
}

//--------------------------------------------------------------
void BANK::touchDown(ofTouchEventArgs & touch){
    leftButton.touchDown(touch); quickButton.touchDown(touch, true); rightButton.touchDown(touch);
    channelButton.touchDown(touch, true); groupButton.touchDown(touch, true); IPButton.touchDown(touch, true);
    FPButton.touchDown(touch, true); CPButton.touchDown(touch, true); BPButton.touchDown(touch, true);
    presetButton.touchDown(touch, true); macroButton.touchDown(touch, true); effectsButton.touchDown(touch, true); snapButton.touchDown(touch, true);
    MSButton.touchDown(touch, true); sceneButton.touchDown(touch, true); flexiButton.touchDown(touch, true);
}

//--------------------------------------------------------------
void BANK::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void BANK::touchUp(ofTouchEventArgs & touch){
    leftButton.touchUp(touch); rightButton.touchUp(touch);
}

//--------------------------------------------------------------
void BANK::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------

void BANK::toggleDS(int keySwitch) {
    
    channelButton.clicked = false; groupButton.clicked = false; IPButton.clicked = false; FPButton.clicked = false; CPButton.clicked = false; BPButton.clicked = false; presetButton.clicked = false; macroButton.clicked = false; effectsButton.clicked = false; snapButton.clicked = false; MSButton.clicked = false; sceneButton.clicked = false;
    
    quickButton.clicked = false;
    
    switch(keySwitch) {
        case 0:
            selected = "CHANNEL"; colorSelect = EOSChannel; channelButton.clicked = true; channelButton.action = false; break;
        case 1:
            selected = "GROUP"; colorSelect = EOSGroup; groupButton.clicked = true; groupButton.action = false; break;
        case 2:
            selected = "INTENSITY"; colorSelect = EOSIntensity; IPButton.clicked = true; IPButton.action = false; break;
        case 3:
            selected = "FOCUS"; colorSelect = EOSFocus; FPButton.clicked = true; FPButton.action = false; break;
        case 4:
            selected = "COLOR"; colorSelect = EOSColor; CPButton.clicked = true; CPButton.action = false; break;
        case 5:
            selected = "BEAM"; colorSelect = EOSBeam; BPButton.clicked = true; BPButton.action = false; break;
        case 6:
            selected = "PRESET"; colorSelect = EOSPreset; presetButton.clicked = true; presetButton.action = false; break;
        case 7:
            selected = "MACRO"; colorSelect = EOSMacro; macroButton.clicked = true; macroButton.action = false; break;
        case 8:
            selected = "EFFECT"; colorSelect = EOSfx; effectsButton.clicked = true; effectsButton.action = false; break;
        case 9:
            selected = "SNAP"; colorSelect = EOSSnap; snapButton.clicked = true; snapButton.action = false; break;
        case 10:
            selected = "MAGIC SHEET"; colorSelect = EOSMagic; MSButton.clicked = true; MSButton.action = false; break;
        case 11:
            selected = "SCENE"; colorSelect = EOSScene; sceneButton.clicked = true; sceneButton.action = false; break;
    }
    
}
