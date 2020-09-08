//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------ASSEMBLY----------
//--------------------------------------------------------------

class ASSEMBLY_HANDLE {

	float frameX, frameY, defaultX, botLimit, topLimit;
	boolean clicked = false;
	boolean doubleClicked = false;

	float assemblyAngle = 0;
	boolean eventTrigger = false;

	void sendOSC() {
		eventTrigger = true;
	}

//--------------------------------------------------------------

	void setup() {
		frameX = centerX;
		frameY = centerY + assemblyRadius + clickDiameter * 1.5;
		defaultX = frameX;
		botLimit = centerX - assemblyRadius;
		topLimit = centerX + assemblyRadius;
	}

//--------------------------------------------------------------

	void update() {
		frameX = constrain(frameX, botLimit, topLimit);
		rotation = map(frameX, botLimit, topLimit, radians(45), radians(-45));

		push();

		// ----------HORIZONTAL LINE----------
		noFill();
		stroke(shutterOutsideStroke);
		strokeWeight(assemblyLineWeight);
		rect(botLimit, frameY - assemblyLineWeight / 2, assemblyDiameter, assemblyLineWeight, buttonCorner);

		// ----------VERTICAL LINE----------
		stroke(shutterOutsideStroke);
		rect(centerX - assemblyLineWeight / 2, frameY - clickRadius / 2, assemblyLineWeight, clickRadius, buttonCorner);

		// ----------BUTTON----------
		fill(shutterOutsideStroke);
		stroke(shutterFrameStroke);
		strokeWeight(assemblyButtonWeight);
		circle(frameX, frameY, clickDiameter);

		pop();
	}

//--------------------------------------------------------------

	void incomingOSC(float value) {
		frameX = map(value, -50, 50, botLimit, topLimit);
	}

//--------------------------------------------------------------

	void touchDown() {
		if (dist(touch.x, touch.y, frameX, frameY) < clickRadius) {
			this.clicked = true;
			ignoreOSC = true;
		}
	}

//--------------------------------------------------------------

	void touchMoved(boolean fine) {
		if (clicked) {
			if (fine) {
				frameX += (touch.x - ofGetPreviousMouseX()) / 3;
			} else {
				frameX += (touch.x - ofGetPreviousMouseX());
			}
			assemblyAngle = map(frameX, botLimit, topLimit, -50, 50);

			sendOSC();
		}
	}

//--------------------------------------------------------------

	void touchUp() {
		this.clicked = false;
		this.doubleClicked = false;
	}

//--------------------------------------------------------------

	void touchDoubleTap() {
		if (dist(touch.x, touch.y, frameX, frameY) < clickRadius) {
			this.doubleClicked = true;
			rotation = 0;
			frameX = defaultX;
			assemblyAngle = 0;

			sendOSC();
		}
	}

}