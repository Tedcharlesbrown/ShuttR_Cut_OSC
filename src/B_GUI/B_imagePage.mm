#include "A_ofApp.h"

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void ofApp::imagePageSetup(){
    
}
//--------------------------------------------------------------
void ofApp::imagePageUpdate(){
    if (color1Button.action && color1Button.clicked) { //------------- COLOR ---------------
        color1Button.clicked = true; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        color1Button.action = false;
        imageParamShow = "COLOR 1"; imageIndexParameter = "Color_Select"; imageSpeedParameter = "";
    } else if (color2Button.action && color2Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = true; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        color2Button.action = false;
        imageParamShow = "COLOR 2"; imageIndexParameter = "Color_Select_2"; imageSpeedParameter = "";
    } else if (color3Button.action && color3Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = true;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        color3Button.action = false;
        imageParamShow = "COLOR 3"; imageIndexParameter = "Color_Select_3"; imageSpeedParameter = "";
    } else if (gobo1Button.action && gobo1Button.clicked) { //------------- GOBO ---------------
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = true; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        gobo1Button.action = false;
        imageParamShow = "GOBO 1"; imageIndexParameter = "Gobo_Select"; imageSpeedParameter = "Gobo_Index\\Speed";
    } else if (gobo2Button.action && gobo2Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = true; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        gobo2Button.action = false;
        imageParamShow = "GOBO 2"; imageIndexParameter = "Gobo_Select_2"; imageSpeedParameter = "Gobo_Index\\Speed_2";
    } else if (gobo3Button.action && gobo3Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = true;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        gobo3Button.action = false;
        imageParamShow = "GOBO 3"; imageIndexParameter = "Gobo_Select_3"; imageSpeedParameter = "Gobo_Index\\Speed_3";
    } else if (beam1Button.action && beam1Button.clicked) { //------------- BEAM ---------------
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = true; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        beam1Button.action = false;
        imageParamShow = "BEAM 1"; imageIndexParameter = "Beam_Fx_Select"; imageSpeedParameter = "Beam_Fx_Index\\Speed";
    } else if (beam2Button.action && beam2Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = true; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        beam2Button.action = false;
        imageParamShow = "BEAM 2"; imageIndexParameter = "Beam_Fx_Select_2"; imageSpeedParameter = "Beam_Fx_Index\\Speed_2";
    } else if (beam3Button.action && beam3Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = true;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = false;
        beam3Button.action = false;
        imageParamShow = "BEAM 3"; imageIndexParameter = "Beam_Fx_Select_3"; imageSpeedParameter = "Beam_Fx_Index\\Speed_3";
    } else if (ani1Button.action && ani1Button.clicked) { //------------- ANIMATION ---------------
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = true; ani2Button.clicked = false; ani3Button.clicked = false;
        ani1Button.action = false;
        imageParamShow = "ANI 1"; imageIndexParameter = "Animation_Select"; imageSpeedParameter = "Animation_Index\\Speed";
    } else if (ani2Button.action && ani2Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = true; ani3Button.clicked = false;
        ani2Button.action = false;
        imageParamShow = "ANI 2"; imageIndexParameter = "Animation_Select_2"; imageSpeedParameter = "Animation_Index\\Speed_2";
    } else if (ani3Button.action && ani3Button.clicked) {
        color1Button.clicked = false; color2Button.clicked = false; color3Button.clicked = false;
        gobo1Button.clicked = false; gobo2Button.clicked = false; gobo3Button.clicked = false;
        beam1Button.clicked = false; beam2Button.clicked = false; beam3Button.clicked = false;
        ani1Button.clicked = false; ani2Button.clicked = false; ani3Button.clicked = true;
        ani3Button.action = false;
        imageParamShow = "ANI 3"; imageIndexParameter = "Animation_Select_3"; imageSpeedParameter = "Animation_Index\\Speed_3";
    } else if (!color1Button.clicked && !color2Button.clicked && !color3Button.clicked && !gobo1Button.clicked && !gobo2Button.clicked && !gobo3Button.clicked && !beam1Button.clicked && !beam2Button.clicked && !beam3Button.clicked && !ani1Button.clicked && !ani2Button.clicked && !ani3Button.clicked) {//------------- ALL ---------------
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
    }
    
    //BUTTONS
    if (minusPercentButton.action && imageParamShow != "IMAGE") { //if param is form, don't send.
        sendImage(imageIndexParameter, "-/1", true);
        minusPercentButton.action = false;
    } else if (homeButton.action) {
        if (imageIndexParameter == "Image" && homeButton.doubleClicked) { //If double tapped, sneak
            sendSneak("image");
        } else {
            sendImage(imageIndexParameter,"0", true);
        }
        homeButton.action = false;
    } else if (plusPercentButton.action && imageParamShow != "IMAGE") { //if param is form, don't send.
        sendImage(imageIndexParameter, "+/1", true);
        plusPercentButton.action = false;
    }
    
    if (minusSpeedButton.action && imageParamShow != "IMAGE" && imageSpeedParameter != "") { //if param is form, don't send.
        if (fineButton.clicked) {
            sendImage(imageSpeedParameter, "+-/01", false);
        } else {
            sendImage(imageSpeedParameter, "+-/10", false);
        }
        minusSpeedButton.action = false;
    } else if (homeSpeedButton.action) {
        if (imageSpeedParameter == "Image" && homeSpeedButton.doubleClicked) { //If double tapped, sneak
            sendSneak("image");
        } else {
            sendImage(imageSpeedParameter,"0", false);
        }
        homeSpeedButton.action = false;
    } else if (plusSpeedButton.action && imageParamShow != "IMAGE" && imageSpeedParameter != "") { //if param is form, don't send.
        if (fineButton.clicked) {
            sendImage(imageSpeedParameter, "+/01", false);
        } else {
            sendImage(imageSpeedParameter, "+/10", false);
        }
        plusSpeedButton.action = false;
    }
    
    //updateHasImage
    if (!hasGobo1 && gobo1Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        gobo1Button.clicked = false;
    } else if (!hasGobo2 && gobo2Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        gobo2Button.clicked = false;
    } else if (!hasGobo3 && gobo3Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        gobo3Button.clicked = false;
    } else if (!hasBeam1 && beam1Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        beam1Button.clicked = false;
    } else if (!hasBeam2 && beam2Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        beam2Button.clicked = false;
    } else if (!hasBeam3 && beam3Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        beam3Button.clicked = false;
    } else if (!hasAni1 && ani1Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        ani1Button.clicked = false;
    } else if (!hasAni2 && ani2Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        ani2Button.clicked = false;
    } else if (!hasAni3 && ani3Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        ani3Button.clicked = false;
    } else if (!hasColor1 && color1Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        color1Button.clicked = false;
    } else if (!hasColor2 && color2Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        color2Button.clicked = false;
    } else if (!hasColor3 && color3Button.clicked) {
        imageParamShow = "IMAGE"; imageIndexParameter = "Image"; imageSpeedParameter = "Image";
        color3Button.clicked = false;
    }
    
    if (!hasGobo1) { gobo1Select = noParameter; gobo1Speed = noParameter; }
    if (!hasGobo2) { gobo2Select = noParameter; gobo2Speed = noParameter; }
    if (!hasGobo3) { gobo3Select = noParameter; gobo3Speed = noParameter; }
    if (!hasBeam1) { beam1Select = noParameter; beam1Speed = noParameter; }
    if (!hasBeam2) { beam2Select = noParameter; beam2Speed = noParameter; }
    if (!hasBeam3) { beam3Select = noParameter; beam3Speed = noParameter; }
    if (!hasAni1) { ani1Select = noParameter; ani1Speed = noParameter; }
    if (!hasAni2) { ani2Select = noParameter; ani2Speed = noParameter; }
    if (!hasAni3) { ani3Select = noParameter; ani3Speed = noParameter; }
    if (!hasColor1) { color1Select = noParameter; }
    if (!hasColor2) { color2Select = noParameter; }
    if (!hasColor3) { color3Select = noParameter; }
}

//--------------------------------------------------------------
void ofApp::imagePageDraw(){
    //------------- COLOR ---------------
    float colorPadding = row3Padding;
    if (hasColor1 && !hasColor2 && !hasColor3) {
        color1Button.showImage("COLOR WHEEL 1",color1Select, guiCenterAlign, colorPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasColor1 && hasColor2 && !hasColor3) {
        color1Button.showImage("COLOR WHEEL 1",color1Select, guiCenterAlign - channelButtonWidth / 2, colorPadding, imageButtonWidth, buttonHeight, true);
        color2Button.showImage("COLOR WHEEL 2",color2Select, guiCenterAlign + channelButtonWidth / 2, colorPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasColor1 && hasColor2 && hasColor3){
        color1Button.showImage("COLOR WHEEL 1",color1Select, guiLeftAlign, colorPadding, imageButtonWidth, buttonHeight, true);
        color2Button.showImage("COLOR WHEEL 2",color2Select, guiCenterAlign, colorPadding, imageButtonWidth, buttonHeight, true);
        color3Button.showImage("COLOR WHEEL 3",color3Select, guiRightAlign, colorPadding, imageButtonWidth, buttonHeight, true);
    } else {
        color1Button.showImage("NO COLOR","---", guiCenterAlign, colorPadding, imageButtonWidth, buttonHeight, false);
    }
    
    //------------- GOBO ---------------
    float goboPadding = row4Padding + buttonHeight * 0.85;
    if (hasGobo1 && !hasGobo2 && !hasGobo3) {
        gobo1Button.showImage("GOBO WHEEL 1",gobo1Select, gobo1Speed, guiCenterAlign, goboPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasGobo1 && hasGobo2 && !hasGobo3) {
        gobo1Button.showImage("GOBO WHEEL 1",gobo1Select, gobo1Speed, guiCenterAlign - channelButtonWidth / 2, goboPadding, imageButtonWidth, buttonHeight, true);
        gobo2Button.showImage("GOBO WHEEL 2",gobo2Select, gobo2Speed, guiCenterAlign + channelButtonWidth / 2, goboPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasGobo1 && hasGobo2 && hasGobo3){
        gobo1Button.showImage("GOBO WHEEL 1",gobo1Select, gobo1Speed, guiLeftAlign, goboPadding, imageButtonWidth, buttonHeight, true);
        gobo2Button.showImage("GOBO WHEEL 2",gobo2Select, gobo2Speed, guiCenterAlign, goboPadding, imageButtonWidth, buttonHeight, true);
        gobo3Button.showImage("GOBO WHEEL 3",gobo3Select, gobo3Speed, guiRightAlign, goboPadding, imageButtonWidth, buttonHeight, true);
    } else {
        gobo1Button.showImage("NO GOBO","---", "---",guiCenterAlign, goboPadding, imageButtonWidth, buttonHeight, false);
    }
    
    //------------- BEAM ---------------
    float beamPadding = row7Padding - buttonHeight * 0.35;
    if (hasBeam1 && !hasBeam2 && !hasBeam3) {
        beam1Button.showImage("BEAM FX 1",beam1Select, beam1Speed, guiCenterAlign, beamPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasBeam1 && hasBeam2 && !hasBeam3) {
        beam1Button.showImage("BEAM FX 1",beam1Select, beam1Speed, guiCenterAlign - channelButtonWidth / 2, beamPadding, imageButtonWidth, buttonHeight, true);
        beam2Button.showImage("BEAM FX 2",beam2Select, beam2Speed, guiCenterAlign + channelButtonWidth / 2, beamPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasBeam1 && hasBeam2 && !hasBeam3){
        beam1Button.showImage("BEAM FX 1",beam1Select, beam1Speed, guiLeftAlign, beamPadding, imageButtonWidth, buttonHeight, true);
        beam2Button.showImage("BEAM FX 2",beam2Select, beam2Speed, guiCenterAlign, beamPadding, imageButtonWidth, buttonHeight, true);
        beam3Button.showImage("BEAM FX 3",beam3Select, beam3Speed, guiRightAlign, beamPadding, imageButtonWidth, buttonHeight, true);
    } else {
        beam1Button.showImage("NO BEAM","---","---",guiCenterAlign, beamPadding, imageButtonWidth, buttonHeight, false);
    }
    
    //------------- ANIMATION ---------------
    float animationPadding = row9Padding - buttonHeight * 0.25;
    if (hasAni1 && !hasAni2 && !hasAni3) {
        ani1Button.showImage("ANIMATION 1",ani1Select, ani1Speed, guiCenterAlign, animationPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasAni1 && hasAni2 && !hasAni3) {
        ani1Button.showImage("ANIMATION 1",ani1Select, ani1Speed, guiCenterAlign - channelButtonWidth / 2, animationPadding, imageButtonWidth, buttonHeight, true);
        ani2Button.showImage("ANIMATION 2",ani2Select, ani2Speed, guiCenterAlign + channelButtonWidth / 2, animationPadding, imageButtonWidth, buttonHeight, true);
    } else if (hasAni1 && hasAni2 && !hasAni3){
        ani1Button.showImage("ANIMATION 1",ani1Select, ani1Speed, guiLeftAlign, animationPadding, imageButtonWidth, buttonHeight, true);
        ani2Button.showImage("ANIMATION 2",ani2Select, ani2Speed, guiCenterAlign, animationPadding, imageButtonWidth, buttonHeight, true);
        ani3Button.showImage("ANIMATION 3",ani3Select, ani3Speed, guiRightAlign, animationPadding, imageButtonWidth, buttonHeight, true);
    } else {
        ani1Button.showImage("NO ANIMATION","---","---", guiCenterAlign, animationPadding, imageButtonWidth, buttonHeight,false);
    }
    
    //BUTTONS
    minusPercentButton.show("<", "INDEX", guiLeftAlign, rowBottomPadding - buttonHeight * 1.25, genericButtonWidth, buttonHeight);
    plusPercentButton.show(">", "INDEX", guiRightAlign, rowBottomPadding - buttonHeight * 1.25, genericButtonWidth, buttonHeight);
    
    minusSpeedButton.show("-%", "IND/SPD", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
    plusSpeedButton.show("+%", "IND/SPD", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
    
    if (imageParamShow == "IMAGE") {
        homeButton.show(imageParamShow, "HOME", guiCenterAlign, rowBottomPadding - (buttonHeight * 1.25) / 2, genericButtonWidth, buttonHeight * 2);
    } else {
        homeButton.show("INDEX", "HOME", guiCenterAlign, rowBottomPadding - buttonHeight * 1.25, genericButtonWidth, buttonHeight);
        homeSpeedButton.show("IND/SPD", "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
    }
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void ofApp::imagePageTouchDown(ofTouchEventArgs & touch){
    if (hasGobo1) { gobo1Button.touchDown(touch,true); }
    if (hasGobo2) { gobo2Button.touchDown(touch,true); }
    if (hasGobo3) { gobo3Button.touchDown(touch,true); }
    if (hasBeam1) { beam1Button.touchDown(touch,true); }
    if (hasBeam2) { beam2Button.touchDown(touch,true); }
    if (hasBeam3) { beam3Button.touchDown(touch,true); }
    if (hasAni1) { ani1Button.touchDown(touch,true); }
    if (hasAni2) { ani2Button.touchDown(touch,true); }
    if (hasAni3) { ani3Button.touchDown(touch,true); }
    if (hasColor1) { color1Button.touchDown(touch,true); }
    if (hasColor2) { color2Button.touchDown(touch,true); }
    if (hasColor3) { color3Button.touchDown(touch,true); }
    
    minusPercentButton.touchDown(touch);
    homeButton.touchDown(touch);
    plusPercentButton.touchDown(touch);
    
    minusSpeedButton.touchDown(touch);
    homeSpeedButton.touchDown(touch);
    plusSpeedButton.touchDown(touch);
}

//--------------------------------------------------------------
void ofApp::imagePageTouchMoved(ofTouchEventArgs & touch){
}

//--------------------------------------------------------------
void ofApp::imagePageTouchUp(ofTouchEventArgs & touch){
    minusPercentButton.touchUp(touch);
    homeButton.touchUp(touch);
    plusPercentButton.touchUp(touch);
    
    minusSpeedButton.touchUp(touch);
    homeSpeedButton.touchUp(touch);
    plusSpeedButton.touchUp(touch);
}

//--------------------------------------------------------------
void ofApp::imagePageDoubleTap(ofTouchEventArgs & touch){
    homeButton.touchDoubleTap(touch);
    homeSpeedButton.touchDoubleTap(touch);
}
