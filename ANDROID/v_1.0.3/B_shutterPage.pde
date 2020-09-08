//--------------------------------------------------------------
// B_shutterPage.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- SHUTTER PAGE - SETUP / UPDATE / DRAW ----------
//--------------------------------------------------------------

void shutterPageSetup() {
	bgAssembly = loadImage("IMG_bgAssembly.png");
	bgAssembly.resize(int(assemblyDiameter * 2), int(assemblyDiameter * 2));

	thrustA.setup("a"); thrustB.setup("b"); thrustC.setup("c"); thrustD.setup("d");
	angleA.setup("a"); angleB.setup("b"); angleC.setup("c"); angleD.setup("d");
	assembly.setup();
}

//--------------------------------------------------------------

void shutterPageUpdate() {
	if (thrustButton.action) {
		if (noneSelected) {
			thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
		} else {
			sendShutterHome("THRUST");
		}
		thrustButton.action = false;
	}
	if (angleButton.action) {
		if (noneSelected) {
			angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
		} else {
			sendShutterHome("ANGLE");
		}
		angleButton.action = false;
	}
	if (shutterButton.action) {
		if (noneSelected) {
			angleA.rotateAngle = 0; angleB.rotateAngle = 0; angleC.rotateAngle = 0; angleD.rotateAngle = 0;
			thrustA.buttonA.position = 1; thrustB.buttonB.position = 1; thrustC.buttonC.position = 1; thrustD.buttonD.position = 1;
			assembly.frameX = assembly.defaultX;
		} else if (shutterButton.doubleClicked) {
			sendSneak("Shutter");
		} else {
			sendShutterHome("SHUTTER");
		}
		shutterButton.action = false;
	}
}

//--------------------------------------------------------------

void shutterPageDraw() {
	assemblyBackground();

	angleA.frameDisplay(thrustA.buttonA.position); angleC.frameDisplay(thrustC.buttonC.position); angleB.frameDisplay(thrustB.buttonB.position); angleD.frameDisplay(thrustD.buttonD.position);

	assemblyFront();

	thrustButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight);
	angleButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight);
	shutterButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight);

	push();
	translate(centerX, centerY);
	rotate(rotation);

	angleA.update(); angleB.update(); angleC.update(); angleD.update();
	thrustA.update(); thrustB.update(); thrustC.update(); thrustD.update();
	thrustA.buttonA.angleLimit(angleA.anglePercent); thrustB.buttonB.angleLimit(angleB.anglePercent); thrustC.buttonC.angleLimit(angleC.anglePercent); thrustD.buttonD.angleLimit(angleD.anglePercent);

	pop();

	assembly.update();
}

//--------------------------------------------------------------
// MARK: ---------- ASSEMBLY FOREGROUND / BACKGROUND ----------
//--------------------------------------------------------------

void assemblyBackground() {
	push();

	translate(centerX, centerY);

	fill(shutterColor);
	noStroke();
	circle(0, 0, assemblyDiameter); //INSIDE FILL

	pop();
}

void assemblyFront() {
	push();

	fill(EOSBackground);
	noStroke();
	rect(0, settingsBarHeight + settingsBarStrokeWeight, width, centerY - settingsBarHeight - assemblyRadius); //UPPER FILL

	translate(centerX, centerY);

	rect(-centerX, assemblyRadius, width, height - centerY); //LOWER FILL

	stroke(EOSBackground);
	strokeWeight(shutterStrokeWeight);
	noFill();
	for (int i = int(assemblyDiameter + shutterStrokeWeight); i < assemblyDiameter + assemblyRadius + shutterStrokeWeight; i += shutterStrokeWeight) {
		circle(0, 0, i);
	}

	stroke(shutterOutsideStroke);
	strokeWeight(shutterStrokeWeight);
	noFill();
	circle(0, 0, assemblyDiameter); //OUTSIDE FILL

	rotate(rotation);

	fill(255, 25);
	noStroke();
	rect(- assemblyRadius + outsideWeight, crosshairWeight / 2, assemblyDiameter - outsideWeight * 2, - crosshairWeight / 2); //CROSSHAIR
	rect(- crosshairWeight / 2, - assemblyRadius + outsideWeight, crosshairWeight / 2, assemblyDiameter - outsideWeight * 2); //CROSSHAIR

	pop();
}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

void shutterPageTouchDown() {
	thrustButton.touchDown();
	angleButton.touchDown();
	shutterButton.touchDown();

	thrustA.touchDown(); thrustB.touchDown(); thrustC.touchDown(); thrustD.touchDown();
	angleA.touchDown(); angleB.touchDown(); angleC.touchDown(); angleD.touchDown();
	assembly.touchDown();
}

//--------------------------------------------------------------

void shutterPageTouchMoved() {
	thrustA.touchMoved(fineButton.clicked); thrustB.touchMoved(fineButton.clicked); thrustC.touchMoved(fineButton.clicked); thrustD.touchMoved(fineButton.clicked);
	angleA.touchMoved(fineButton.clicked); angleB.touchMoved(fineButton.clicked); angleC.touchMoved(fineButton.clicked); angleD.touchMoved(fineButton.clicked);
	assembly.touchMoved(fineButton.clicked);
}

//--------------------------------------------------------------

void shutterPageTouchUp() {
	thrustButton.touchUp();
	angleButton.touchUp();
	shutterButton.touchUp();

	thrustA.touchUp(); thrustB.touchUp(); thrustC.touchUp(); thrustD.touchUp();
	angleA.touchUp(); angleB.touchUp(); angleC.touchUp(); angleD.touchUp();
	assembly.touchUp();
}

//--------------------------------------------------------------

void shutterPageDoubleTap() {
	shutterButton.touchDoubleTap();

	thrustA.touchDoubleTap(); thrustB.touchDoubleTap(); thrustC.touchDoubleTap(); thrustD.touchDoubleTap();
	angleA.touchDoubleTap(); angleB.touchDoubleTap(); angleC.touchDoubleTap(); angleD.touchDoubleTap();
	assembly.touchDoubleTap();
}


//--------------------------------------------------------------
// MARK: ---------- OSC LISTENERS / PARSING ----------
//--------------------------------------------------------------

void sendThrustA() {
	if (thrustA.buttonA.eventTrigger) {
		sendShutter("THRUST", "a", (thrustA.buttonA.thrustPercent));
		thrustA.buttonA.eventTrigger = false;
	}
}
void sendThrustB() {
	if (thrustB.buttonB.eventTrigger) {
		sendShutter("THRUST", "b", (thrustB.buttonB.thrustPercent));
		thrustB.buttonB.eventTrigger = false;
	}
}
void sendThrustC() {
	if (thrustC.buttonC.eventTrigger) {
		sendShutter("THRUST", "c", (thrustC.buttonC.thrustPercent));
		thrustC.buttonC.eventTrigger = false;
	}
}
void sendThrustD() {
	if (thrustD.buttonD.eventTrigger) {
		sendShutter("THRUST", "d", (thrustD.buttonD.thrustPercent));
		thrustD.buttonD.eventTrigger = false;
	}
}

void sendAngleA(){
    if (angleA.eventTrigger) {
		sendShutter("ANGLE", "a", angleA.anglePercent);
		angleA.eventTrigger = false;
	}
}
void sendAngleB(){
    if (angleB.eventTrigger) {
		sendShutter("ANGLE", "b", angleB.anglePercent);
		angleB.eventTrigger = false;
	}
}
void sendAngleC(){
    if (angleC.eventTrigger) {
		sendShutter("ANGLE", "c", angleC.anglePercent);
		angleC.eventTrigger = false;
	}
}
void sendAngleD(){
    if (angleD.eventTrigger) {
		sendShutter("ANGLE", "d", angleD.anglePercent);
		angleD.eventTrigger = false;
	}
}

void sendAssembly() {
	if (assembly.eventTrigger) {
		sendShutter("ASSEMBLY", "", int(assembly.assemblyAngle));
		assembly.eventTrigger = false;
	}
}
