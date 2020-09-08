//--------------------------------------------------------------
// C_keyboard.h && C_keyboard.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

class KEYBOARD {
	String input = "";
	float slide = 1;
	boolean show = false;
	boolean isOffScreen = false;
	boolean enter = false;
	boolean clickedOff = false;

//----------------------------------------------------

	BUTTON enterButton, clearButton, zeroButton, dotButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton;

//--------------------------------------------------------------
// MARK: ---------- OPEN / CLOSE ----------
//--------------------------------------------------------------

	void open() {
		show = true;
	}

	void close() {
		show = false;
		clickedOff = false;
		enter = false;
	}

//--------------------------------------------------------------
// MARK: ---------- UPDATE / DRAW ----------
//--------------------------------------------------------------

	void update() {
		if (zeroButton.action) {
			input += "0";
			zeroButton.action = false;
		} else if (oneButton.action) {
			input += "1";
			oneButton.action = false;
		} else if (twoButton.action) {
			input += "2";
			twoButton.action = false;
		} else if (threeButton.action) {
			input += "3";
			threeButton.action = false;
		} else if (fourButton.action) {
			input += "4";
			fourButton.action = false;
		} else if (fiveButton.action) {
			input += "5";
			fiveButton.action = false;
		} else if (sixButton.action) {
			input += "6";
			sixButton.action = false;
		} else if (sevenButton.action) {
			input += "7";
			sevenButton.action = false;
		} else if (eightButton.action) {
			input += "8";
			eightButton.action = false;
		} else if (nineButton.action) {
			input += "9";
			nineButton.action = false;
		} else if (dotButton.action) {
			input += ".";
			dotButton.action = false;
		} else if (clearButton.action) {
			clearButton.action = false;
			if (input.length() > 0) {
				input = input.substring(0, input.length() - 1);
			} else {
				return;
			}
		} else if (enterButton.action) {
			enter = true;
			enterButton.action = false;
		}
	}

//--------------------------------------------------------------

	void draw() {
		float buttonWidth = smallButtonWidth;
		float buttonPadding = buttonWidth * 1.25;

		push();

		if (!show) {
			if (slide < 1) {
				slide += 0.05;
			} else {
				isOffScreen = true;
			}
		} else if (show) {
			if (slide > 0) {
				slide -= 0.05;
			} else {
				isOffScreen = false;
			}

		}

		constrain(slide, 0, 1);
		translate(0, height * slide);

		push();
		rectMode(CENTER);
		fill(0, 150);
		noStroke();
		rect(guiCenterAlign, rowBottomPadding - buttonHeight * 2.5, buttonPadding * 3.5, buttonHeight * 7, buttonCorner * 5);
		pop();

		enterButton.show("ENTER", guiCenterAlign, rowBottomPadding, buttonWidth * 2, buttonHeight, "LARGE");

		clearButton.show("CLEAR", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
		zeroButton.show("0", guiCenterAlign, rowBottomPadding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");
		dotButton.show(".", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 1.25, buttonWidth, buttonHeight, "MEDIUM");

		oneButton.show("1", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
		twoButton.show("2", guiCenterAlign, rowBottomPadding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");
		threeButton.show("3", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 2.5, buttonWidth, buttonHeight, "MEDIUM");

		fourButton.show("4", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
		fiveButton.show("5", guiCenterAlign, rowBottomPadding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");
		sixButton.show("6", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 3.75, buttonWidth, buttonHeight, "MEDIUM");

		sevenButton.show("7", guiCenterAlign - buttonPadding, rowBottomPadding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
		eightButton.show("8", guiCenterAlign, rowBottomPadding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");
		nineButton.show("9", guiCenterAlign + buttonPadding, rowBottomPadding - buttonHeight * 5, buttonWidth, buttonHeight, "MEDIUM");

		pop();
	}

//--------------------------------------------------------------
// MARK: ---------- TOUCH EVENTS ----------
//--------------------------------------------------------------

	void touchDown() {
		enterButton.touchDown();

		clearButton.touchDown();
		zeroButton.touchDown();
		dotButton.touchDown();

		oneButton.touchDown();
		twoButton.touchDown();
		threeButton.touchDown();

		fourButton.touchDown();
		fiveButton.touchDown();
		sixButton.touchDown();

		sevenButton.touchDown();
		eightButton.touchDown();
		nineButton.touchDown();

		if (touch.y < (rowBottomPadding - buttonHeight * 2.5) - (buttonHeight * 4)) {
			clickedOff = true;
		}
	}

//--------------------------------------------------------------
	void touchUp() {
		enterButton.touchUp();

		clearButton.touchUp();
		zeroButton.touchUp();
		dotButton.touchUp();

		oneButton.touchUp();
		twoButton.touchUp();
		threeButton.touchUp();

		fourButton.touchUp();
		fiveButton.touchUp();
		sixButton.touchUp();

		sevenButton.touchUp();
		eightButton.touchUp();
		nineButton.touchUp();
	}

//--------------------------------------------------------------


}
