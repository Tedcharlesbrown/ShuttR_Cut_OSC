//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------THRUST_HANDLE----------
//--------------------------------------------------------------

class THRUST_HANDLE {
	THRUST_BUTTON buttonA, buttonB, buttonC, buttonD;

	float rotateOffset, sliderX, sliderY, diff, _thrustDiameter;
	String ID;
	boolean clicked = false;
	boolean doubleClicked = false;

//--------------------------------------------------------------

	void setup(String _ID) {
		this.ID = _ID;
		if (ID == "a") {
			rotateOffset = radians(-90);
		} else if (ID == "b") {
			rotateOffset = radians(0);
		} else if (ID == "c") {
			rotateOffset = radians(90);
		} else if (ID == "d") {
			rotateOffset = radians(180);
		}

		buttonA = new THRUST_BUTTON(); buttonB = new THRUST_BUTTON(); buttonC = new THRUST_BUTTON(); buttonD = new THRUST_BUTTON();

	}

//--------------------------------------------------------------


	void update() {
		_thrustDiameter = thrustDiameter * 1.5;
		push();
		if (this.ID == "a") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset))  * buttonA.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset))  * buttonA.position * _thrustDiameter;
			translate(0, - buttonA.position * _thrustDiameter);
			buttonA.draw(this.ID, (rotateOffset));
		} else if (this.ID == "b") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset)) * buttonB.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset)) * buttonB.position * _thrustDiameter;
			translate(buttonB.position * _thrustDiameter, 0);
			buttonB.draw(this.ID, (rotateOffset));
		} else if (this.ID == "c") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset)) * buttonC.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset)) * buttonC.position * _thrustDiameter;
			translate(0, buttonC.position * _thrustDiameter);
			buttonC.draw(this.ID, (rotateOffset));
		} else if (this.ID == "d") {
			this.sliderX = centerX + cos((rotation) + (rotateOffset)) * buttonD.position * _thrustDiameter;
			this.sliderY = centerY + sin((rotation) + (rotateOffset)) * buttonD.position * _thrustDiameter;
			translate(- buttonD.position * _thrustDiameter, 0);
			buttonD.draw(this.ID, (rotateOffset));
		}
		pop();
	}

//--------------------------------------------------------------

	void touchDown() {
		if (dist(touch.x, touch.y, this.sliderX, this.sliderY) < clickRadius) {
			this.clicked = true;
			ignoreOSC = true;
		}
	}

//--------------------------------------------------------------

	void touchMoved(boolean fine) {
		if (fine) {
			this.diff = (cos((rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin((rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY())) / 6;
		} else {
			this.diff = cos((rotation) + rotateOffset) * (touch.x - ofGetPreviousMouseX()) + sin((rotation) + rotateOffset) * (touch.y - ofGetPreviousMouseY());
		}
		if (this.clicked) {
			if (this.ID == "a") {
				buttonA.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			} else if (this.ID == "b") {
				buttonB.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			} else if (this.ID == "c") {
				buttonC.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			} else if (this.ID == "d") {
				buttonD.addOffset(map(this.diff, 0, _thrustDiameter, 0, 1));
			}
		}
	}

//--------------------------------------------------------------

	void touchUp() {
		this.clicked = false;
		this.doubleClicked = false;
	}

//--------------------------------------------------------------

	void touchDoubleTap() {
		if (dist(touch.x, touch.y, this.sliderX, this.sliderY) < clickRadius) {
			this.doubleClicked = true;
			if (ID == "a") {
				buttonA.position = 1;
				buttonA.thrustPercent = 0;
				buttonA.sendOSC();
			} else if (ID == "b") {
				buttonB.thrustPercent = 0;
				buttonB.position = 1;
				buttonB.sendOSC();
			} else if (ID == "c") {
				buttonC.position = 1;
				buttonC.thrustPercent = 0;
				buttonC.sendOSC();
			} else if (ID == "d") {
				buttonD.position = 1;
				buttonD.thrustPercent = 0;
				buttonD.sendOSC();
			}
		}
	}
}

//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------THRUST_BUTTON----------
//--------------------------------------------------------------

class THRUST_BUTTON {

	float position = 1; // The position of the slider between 0 and 1
	String ID;
	float rotateAngle;

	float thrustPercent = 0;
	boolean eventTrigger = false;

	void sendOSC() {
		this.eventTrigger = true;
	}

//--------------------------------------------------------------

	void draw(String _ID, float _rotateAngle) {
		this.ID = _ID;
		this.rotateAngle = _rotateAngle;

		String showID = "";
		if (_ID == "a") {
			showID = "A";
		} else if (_ID == "b") {
			showID = "B";
		} else if (_ID == "c") {
			showID = "C";
		} else if (_ID == "d") {
			showID = "D";
			rotateAngle -= 5;
		}

		stroke(shutterFrameStroke);
		strokeWeight(angleWeight);
		fill(EOSBlue);
		circle(0, 0, clickDiameter);

		rotate(radians(-rotateAngle) - rotation);

		textAlign(CENTER, CENTER);
		textFont(fontMedium);
		fill(white);

		text(showID,- mediumTextSize / 15, - mediumTextSize / 15);
	}

	void addOffset(float _diff) {
		float topLimit = clickDiameter / assemblyRadius;
		position = constrain(position + _diff, topLimit, 1);
		thrustPercent = map(position, topLimit, 1, 100, 0);

		sendOSC();
	}

	void angleLimit(float _angleRotateLimit) {
		float topLimit = clickDiameter / assemblyRadius;
		int angle = int(abs(_angleRotateLimit));
		float angleLimit = 0;

		//TODO: FIX THIS IMPLEMENTATION, WHAT IS SPECIAL ABOUT 0.375? (PERCENTAGE OF THRUST)
		switch (angle) {
		case 0:
			angleLimit = angle;
			break;
		case 1:
			angleLimit = angle - 0.1;
			break;
		case 2:
			angleLimit = angle - 0.3;
			break;
		case 3:
			angleLimit = angle - 0.4;
			break;
		case 4:
			angleLimit = angle - 0.5;
			break;
		case 5:
			angleLimit = angle - 0.6;
			break;
		case 6:
			angleLimit = angle - 0.7;
			break;
		case 7:
			angleLimit = angle - 0.9;
			break;
		case 8:
			angleLimit = angle - 1;
			break;
		case 9:
			angleLimit = angle - 1.1;
			break;
		case 10:
			angleLimit = angle - 1.2;
			break;
		case 11:
			angleLimit = angle - 1.3;
			break;
		case 12:
			angleLimit = angle - 1.4;
			break;
		case 13:
		case 14:
			angleLimit = angle - 1.5;
			break;
		case 15:
			angleLimit = angle - 1.6;
			break;
		case 16:
		case 17:
			angleLimit = angle - 1.7;
			break;
		case 18:
		case 19:
		case 20:
		case 21:
		case 22:
		case 23:
			angleLimit = angle - 1.8;
			break;
		case 24:
		case 25:
			angleLimit = angle - 1.7;
			break;
		case 26:
			angleLimit = angle - 1.6;
			break;
		case 27:
			angleLimit = angle - 1.5;
			break;
		case 28:
			angleLimit = angle - 1.4;
			break;
		case 29:
			angleLimit = angle - 1.3;
			break;
		case 30:
			angleLimit = angle - 1.1;
			break;
		case 31:
			angleLimit = angle - 1;
			break;
		case 32:
			angleLimit = angle - 0.8;
			break;
		case 33:
			angleLimit = angle - 0.5;
			break;
		case 34:
			angleLimit = angle - 0.3;
			break;
		case 35:
			angleLimit = angle;
			break;
		case 36:
			angleLimit = angle + 0.3;
			break;
		case 37:
			angleLimit = angle + 0.7;
			break;
		case 38:
			angleLimit = angle + 1.1;
			break;
		case 39:
			angleLimit = angle + 1.5;
			break;
		case 40:
			angleLimit = angle + 2;
			break;
		case 41:
			angleLimit = angle + 2.5;
			break;
		case 42:
			angleLimit = angle + 3;
			break;
		case 43:
			angleLimit = angle + 3.6;
			break;
		case 44:
			angleLimit = angle + 4.3;
			break;
		case 45:
			angleLimit = angle + 5;
			break;
		}

		float angleBotLimit = map(angleLimit, 0, 50, 1, (topLimit + 1) / 2); //0.375
		float angleTopLimit = 1 - angleBotLimit;
		position = constrain(position, topLimit + angleTopLimit, angleBotLimit);
	}

}