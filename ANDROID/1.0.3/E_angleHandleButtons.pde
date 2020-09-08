//--------------------------------------------------------------
//E_shutterHandles.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ----------ANGLE_HANDLE----------
//--------------------------------------------------------------

class ANGLE_HANDLE {

	ANGLE_BUTTON buttonA, buttonB, buttonC, buttonD;

	float offset, rotateOffset, rotateAngle, x, y, diff;
	float magicNumber; //THIS MAGIC NUMBER MUST BE FOUND
	String ID;
	boolean clicked = false;
	boolean doubleClicked = false;

	// ofVec3f angleVec;

	float anglePercent = 0;
	boolean eventTrigger = false;

	void sendOSC() {
		eventTrigger = true;
	}

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
		magicNumber = radians(clickRadius / 3.5); //THIS MAGIC NUMBER MUST BE FOUND // clickRadius / 5.5

		buttonA = new ANGLE_BUTTON(); buttonB = new ANGLE_BUTTON(); buttonC = new ANGLE_BUTTON(); buttonD = new ANGLE_BUTTON();
	}

//--------------------------------------------------------------

	void update() {
		push();
		rotate(rotateAngle);

		float rotateX = cos((rotation) + rotateOffset + (rotateAngle));
		float rotateY = sin((rotation) + rotateOffset + (rotateAngle));

		this.x = centerX + rotateX * assemblyRadius;
		this.y = centerY + rotateY * assemblyRadius;

		if (this.ID == "a") {
			translate(0, -assemblyRadius);
			buttonA.draw("a", rotateAngle);
		} else if (this.ID == "b") {
			translate(assemblyRadius, 0);
			buttonB.draw("b", rotateAngle);
		} else if (this.ID == "c") {
			translate(0, assemblyRadius);
			buttonC.draw("c", rotateAngle);
		} else if (this.ID == "d") {
			translate(-assemblyRadius, 0);
			buttonD.draw("d", rotateAngle);
		}
		pop();

		calculateAngle();
	}

	//--------------------------------------------------------------

	void frameDisplay(float _thrust) {
		push();
		translate(centerX, centerY);

		float rotateAngleBot = radians(-45) + magicNumber;
		float rotateAngleTop = radians(45) - magicNumber;

		float rotateAngleReal = map(rotateAngle, rotateAngleBot, rotateAngleTop, -45, 45);

		rotate(radians(rotateAngleReal) + rotation);

		if (this.ID == "a") {
			buttonA.frameShow(_thrust);
		} else if (this.ID == "b") {
			buttonB.frameShow(_thrust);
		} else if (this.ID == "c") {
			buttonC.frameShow(_thrust);
		} else if (this.ID == "d") {
			buttonD.frameShow(_thrust);
		}
		pop();
	}

	//--------------------------------------------------------------

	void calculateAngle() {
		float rotateAngleBot = radians(-45) + magicNumber;
		float rotateAngleTop = radians(45) - magicNumber;
		rotateAngle = constrain(rotateAngle, rotateAngleBot, rotateAngleTop);

		anglePercent = map(rotateAngle, rotateAngleBot, rotateAngleTop, (45), (-45));
	}

//--------------------------------------------------------------

	void touchDown() {
		if (dist(touch.x, touch.y, x, y) < clickRadius) {
			this.clicked = true;
		}
	}

//--------------------------------------------------------------

	void touchMoved(boolean fine) {
		if (clicked) {
			ignoreOSC = true;

			int fineAdjust = 500; //5
			if (fine) {
				fineAdjust = 2000; //20
			}

			if (ID == "a") {
				rotateAngle += (cos((rotation)) * (touch.x - ofGetPreviousMouseX()) + sin((rotation)) * (touch.y - ofGetPreviousMouseY())) / fineAdjust;
			} else if (ID == "b") {
				rotateAngle += (cos((rotation)) * (touch.y - ofGetPreviousMouseY()) + sin((rotation)) * (touch.x - ofGetPreviousMouseX())) / fineAdjust;
			} else if (ID == "c") {
				rotateAngle -= (cos((rotation)) * (touch.x - ofGetPreviousMouseX()) + sin((rotation)) * (touch.y - ofGetPreviousMouseY())) / fineAdjust;
			} else if (ID == "d") {
				rotateAngle -= (cos((rotation)) * (touch.y - ofGetPreviousMouseY()) + sin((rotation)) * (touch.x - ofGetPreviousMouseX())) / fineAdjust;

			}
			sendOSC();
		}
		calculateAngle();
	}

//--------------------------------------------------------------
	void touchUp() {
		this.clicked = false;
		this.doubleClicked = false;
	}

//--------------------------------------------------------------

	void touchDoubleTap() {
		if (dist(touch.x, touch.y, x, y) < clickRadius) {
			this.doubleClicked = true;
			rotateAngle = 0;
			sendOSC();
		}
	}

//--------------------------------------------------------------
// MARK: ----------ANGLE_BUTTON----------
//--------------------------------------------------------------

	class ANGLE_BUTTON {
		float position = 1; // The position of the slider between 0 and 1
		String ID;
		float rotateAngle;

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
			}

			stroke(shutterFrameStroke);
			strokeWeight(angleWeight);
			fill(EOSBlue);
			circle(0, 0, clickDiameter);

			rotate((-rotateAngle) - rotation);

			textAlign(CENTER, CENTER);
			textFont(fontMedium);
			fill(white);

			text(showID, - mediumTextSize / 15, - mediumTextSize / 15);
		}

		void frameShow(float _thrust) {
			push();
			rectMode(CENTER);
			float thrustOffset = map(_thrust, clickDiameter / assemblyRadius, 1, 1, 0);

			float shutterWidth = assemblyDiameter + outsideWeight * 2;
			float shutterHeight = assemblyRadius + outsideWeight;

			stroke(shutterFrameStroke);
			strokeWeight(shutterStrokeWeight);
			fill(shutterFrameFill);

			if (ID == "a") {
				translate(0, - assemblyDiameter + assemblyRadius / 2);
				rect(0, assemblyRadius * thrustOffset, shutterWidth, shutterHeight);
			} else if (ID == "b") {
				translate(assemblyDiameter - assemblyRadius / 2, 0);
				rect(-assemblyRadius * thrustOffset, 0, shutterHeight, shutterWidth);
			} else if (ID == "c") {
				translate(0, assemblyDiameter - assemblyRadius / 2);
				rect(0, -assemblyRadius * thrustOffset, shutterWidth, shutterHeight);
			} else if (ID == "d") {
				translate(- assemblyDiameter + assemblyRadius / 2, 0);
				rect(assemblyRadius * thrustOffset, 0, shutterHeight, shutterWidth);
			}

			pop();
		}

	}
}