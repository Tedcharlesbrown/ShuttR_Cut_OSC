//--------------------------------------------------------------
// B_panTiltPage.h && B_panTiltPage.mm
//--------------------------------------------------------------

//--------------------------------------------------------------
// MARK: ---------- PAN TILT PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void focusPageSetup() {
	focusEncoder.setup(assemblyDiameter / 1.25);
}

//--------------------------------------------------------------
void focusPageUpdate() {
	if (panButton.action && panButton.clicked) {
		panButton.clicked = true; tiltButton.clicked = false;
		panButton.action = false;
		panTiltShow = "PAN"; focusParameter = "pan";
	} else if (tiltButton.action && tiltButton.clicked) {
		panButton.clicked = false; tiltButton.clicked = true;
		tiltButton.action = false;
		panTiltShow = "TILT"; focusParameter = "tilt";
	} else if (!panButton.clicked && !tiltButton.clicked) {
		panTiltShow = "FOCUS"; focusParameter = "focus";
	}

	if (minusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
		sendEncoderPercent(focusParameter, -1);
		minusPercentButton.action = false;
	} else if (homeButton.action) {
		if (focusParameter == "focus" && homeButton.doubleClicked) {  //If double tapped, sneak
			sendSneak("focus");
		} else {
			sendEncoderPercent(focusParameter, 0);
		}
		homeButton.action = false;
	} else if (plusPercentButton.action && focusParameter != "focus") { //if param is focus, don't send.
		sendEncoderPercent(focusParameter, 1);
		plusPercentButton.action = false;
	}
}

//--------------------------------------------------------------
void focusPageDraw() {

	panButton.showBig("PAN", panPercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
	tiltButton.showBig("TILT", tiltPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);

	minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
	homeButton.show(panTiltShow, "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
	plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");

	focusEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void focusPageTouchDown() {
	panButton.touchDown(true);
	tiltButton.touchDown(true);

	minusPercentButton.touchDown();
	homeButton.touchDown();
	plusPercentButton.touchDown();

	focusEncoder.touchDown();
}

//--------------------------------------------------------------
void focusPageTouchMoved() {
	focusEncoder.touchMoved();
}

//--------------------------------------------------------------
void focusPageTouchUp() {
	minusPercentButton.touchUp();
	homeButton.touchUp();
	plusPercentButton.touchUp();

	focusEncoder.touchUp();
}

//--------------------------------------------------------------
void focusPageDoubleTap() {
	homeButton.touchDoubleTap();
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

void sendFocusEncoder(){
    if (focusEncoder.eventTrigger && focusParameter != "focus") {
        if (fineButton.clicked) {
            sendEncoder(focusParameter, focusEncoder.encoderOutput / 1000);
        } else {
            sendEncoder(focusParameter, focusEncoder.encoderOutput * 2);
        }
        focusEncoder.eventTrigger = false;
    }
}