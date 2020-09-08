//--------------------------------------------------------------
// B_formPage.h && B_formPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- ENCODER - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void formPageSetup() {
	formEncoder.setup(assemblyDiameter / 1.25);
}

//--------------------------------------------------------------

void formPageUpdate() {
	if (irisButton.action && irisButton.clicked) {
		irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
		irisButton.action = false;
		parameterShow = "IRIS"; formParameter = "iris";
	} else if (edgeButton.action && edgeButton.clicked) {
		irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
		edgeButton.action = false;
		parameterShow = "EDGE"; formParameter = "edge";
	} else if (zoomButton.action && zoomButton.clicked) {
		irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
		zoomButton.action = false;
		parameterShow = "ZOOM"; formParameter = "zoom";
	} else if (frostButton.action && frostButton.clicked) {
		irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
		frostButton.action = false;
		parameterShow = "FROST"; formParameter = "diffusion";
	} else if (!irisButton.clicked && !edgeButton.clicked && !zoomButton.clicked && !frostButton.clicked) {
		parameterShow = "FORM"; formParameter = "form";
	}

	if (minusPercentButton.action && formParameter != "form") { //if param is form, don't send.
		sendEncoderPercent(formParameter, -1);
		minusPercentButton.action = false;
	} else if (homeButton.action) {
		if (formParameter == "form" && homeButton.doubleClicked) { //If double tapped, sneak
			sendSneak("form");
		} else {
			sendEncoderPercent(formParameter, 0);
		}
		homeButton.action = false;
	} else if (plusPercentButton.action && formParameter != "form") { //if param is form, don't send.
		sendEncoderPercent(formParameter, 1);
		plusPercentButton.action = false;
	}
}

//--------------------------------------------------------------

void formPageDraw() {

	irisButton.showBig("IRIS", irisPercent, guiLeftAlign, row3Padding, smallButtonWidth, buttonHeight);
	edgeButton.showBig("EDGE", edgePercent, guiCenterAlign - genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
	zoomButton.showBig("ZOOM", zoomPercent, guiCenterAlign + genericButtonWidth / 2, row3Padding, smallButtonWidth, buttonHeight);
	frostButton.showBig("FROST", frostPercent, guiRightAlign, row3Padding, smallButtonWidth, buttonHeight);

	minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
	homeButton.show(parameterShow, "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
	plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");

	formEncoder.draw(centerX, centerY);
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void formPageTouchDown() {
	irisButton.touchDown(true);
	edgeButton.touchDown(true);
	zoomButton.touchDown(true);
	frostButton.touchDown(true);
	minusPercentButton.touchDown();
	homeButton.touchDown();
	plusPercentButton.touchDown();

	formEncoder.touchDown();
}

void formPageTouchMoved() {
	formEncoder.touchMoved();
}


void formPageTouchUp() {
	minusPercentButton.touchUp();
	homeButton.touchUp();
	plusPercentButton.touchUp();

	formEncoder.touchUp();
}

void formPageDoubleTap() {
	homeButton.touchDoubleTap();
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

void sendFormEncoder() {
	if (formEncoder.eventTrigger && formParameter != "form") {
		if (fineButton.clicked) {
			sendEncoder(formParameter, formEncoder.encoderOutput / 1000);
		} else {
			sendEncoder(formParameter, formEncoder.encoderOutput * 2);
		}
		formEncoder.eventTrigger = false;
	}
}