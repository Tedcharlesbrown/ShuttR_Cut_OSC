//--------------------------------------------------------------
// C_keyboard.h && C_overlay.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

class OVERLAY {
	String input = "";
	float slide = 1;
	boolean show = false;
	boolean isOffScreen = false;
	boolean enter = false;
	boolean clickedOff = false;

	boolean clicked;
	float sliderX, sliderY;
	float botLimit, topLimit, defaultY;

	PVector sliderVector;
	boolean eventTrigger = false;

	void sendOSC() {
		eventTrigger = true;
	}

//----------------------------------------------------

	BUTTON fullButton, levelButton, outButton, minusPercentButton, homeButton, plusPercentButton;
	PImage fader;

//----------------------------------------------------

	void open() {
		show = true;
		isOffScreen = false;
	}

	void close() {
		show = false;
		clickedOff = false;
		isOffScreen = true;
		enter = false;
	}

	//--------------------------------------------------------------

	void setup() {
		botLimit = centerY - assemblyRadius + clickRadius / 2;
		topLimit = centerY + assemblyRadius - clickRadius;
		defaultY = centerY - clickRadius;

		sliderX = guiCenterAlign;

		sliderVector = new PVector(0,0);

		fader = loadImage("Fader.png");
		fader.resize(int(clickDiameter), int(clickDiameter * 2));
	}

	void update() {
		sliderY = constrain(sliderY, botLimit, topLimit);
		sliderVector.y = map(sliderY, botLimit, topLimit, 100, 0);

		if (fullButton.action) {
			sliderVector.x = 1;
			sendOSC();
			fullButton.action = false;
		}
		if (levelButton.action) {
			sliderVector.x = 2;
			sendOSC();
			levelButton.action = false;
		}
		if (outButton.action) {
			sliderVector.x = 3;
			sendOSC();
			outButton.action = false;
		}
		if (minusPercentButton.action) {
			sliderVector.x = 4;
			sendOSC();
			minusPercentButton.action = false;
		}
		if (plusPercentButton.action) {
			sliderVector.x = 5;
			sendOSC();
			plusPercentButton.action = false;
		}
		if (homeButton.doubleClicked) {
			sliderVector.x = 6;
			sendOSC();
			homeButton.action = false;
		} else if (homeButton.action) {
			sliderVector.x = 7;
			sendOSC();
			homeButton.action = false;
		}

	}

//--------------------------------------------------------------

	void draw() {
		if (show) {
			push();

			fullButton.show("FULL", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight, "LARGE");
			levelButton.show("LEVEL", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight, "LARGE");
			outButton.show("OUT", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight, "LARGE");

			minusPercentButton.show("-%", guiLeftAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");
			homeButton.show("INTENS.", "HOME", guiCenterAlign, rowBottomPadding, genericButtonWidth, buttonHeight);
			plusPercentButton.show("+%", guiRightAlign, rowBottomPadding, genericButtonWidth, buttonHeight, "MEDIUM");

			fill(shutterOutsideStroke);
			noStroke();
			rect(sliderX - assemblyLineWeight / 2, botLimit, assemblyLineWeight, assemblyDiameter - clickRadius, buttonCorner);

			// ----------FADER----------
			translate(sliderX, sliderY);
			image(fader, -fader.width / 2, -fader.height / 2);
			pop();
		}
	}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

	void touchDown() {
		if (touch.y < row2Padding - buttonHeight / 2) {
			clickedOff = true;
		}

		if (touch.x > sliderX - fader.width / 2 && touch.x < sliderX + fader.width / 2 && touch.y > sliderY - fader.height / 2 && touch.y < sliderY + fader.height / 2) {
			clicked = true;
			sliderVector.x = 0;
		}

		fullButton.touchDown();
		levelButton.touchDown();
		outButton.touchDown();

		minusPercentButton.touchDown();
		homeButton.touchDown();
		plusPercentButton.touchDown();
	}

//--------------------------------------------------------------

	void touchMoved(boolean fine) {
		if (clicked) {
			if (fine) {
				sliderY += (touch.y - ofGetPreviousMouseY()) / 3;
			} else {
				sliderY += (touch.y - ofGetPreviousMouseY());
			}
			sendOSC();
		}
	}


//--------------------------------------------------------------
	void touchUp() {
		clicked = false;
		fullButton.touchUp();
		levelButton.touchUp();
		outButton.touchUp();

		minusPercentButton.touchUp();
		homeButton.touchUp();
		plusPercentButton.touchUp();
	}

	void touchDoubleTap() {
		homeButton.touchDoubleTap();
	}

//--------------------------------------------------------------

	void incomingOSC(float value) {
		if (!clicked) {
			sliderY = map(value, 100, 0, botLimit, topLimit);
		}
	}

}