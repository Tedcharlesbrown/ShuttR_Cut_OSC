class Keyboard {
	Button enterButton = new Button(false, false);
	Button clearButton = new Button(false, false);
	Button zeroButton = new Button(false, false);
	Button dotButton = new Button(false, false);
	Button oneButton = new Button(false, false);
	Button twoButton = new Button(false, false);
	Button threeButton = new Button(false, false);
	Button fourButton = new Button(false, false);
	Button fiveButton = new Button(false, false);
	Button sixButton = new Button(false, false);
	Button sevenButton = new Button(false, false);
	Button eightButton = new Button(false, false);
	Button nineButton = new Button(false, false);

	String input = "";
	boolean open = false;

	float left, top, right, bot;

	float slide = 1;

	Keyboard() {
	}

	void show() {
		if (!open) {
			if (slide < 1) {
				slide += 0.1;
			}
		} else if (open) {
			if (slide > 0) {
				slide -= 0.1;
			}
		}
		constrain(slide, 0, 1);
		translate(0, height * slide);
		keyBG();
		buttonShow();
		buttonAction();
	}

	void buttonShow() {
		enterButton.show("ENTER", guiCenterAlign, row5Padding, plusMinusButtonWidth * 2, buttonHeight, mediumTextSize);

		clearButton.show("CLEAR", guiCenterAlign - plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 1.25, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		zeroButton.show("0", guiCenterAlign, row5Padding - buttonHeight * 1.25, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		dotButton.show(".", guiCenterAlign + plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 1.25, plusMinusButtonWidth, buttonHeight, mediumTextSize);

		oneButton.show("1", guiCenterAlign - plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 2.5, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		twoButton.show("2", guiCenterAlign, row5Padding - buttonHeight * 2.5, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		threeButton.show("3", guiCenterAlign + plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 2.5, plusMinusButtonWidth, buttonHeight, mediumTextSize);

		fourButton.show("4", guiCenterAlign - plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 3.75, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		fiveButton.show("5", guiCenterAlign, row5Padding - buttonHeight * 3.75, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		sixButton.show("6", guiCenterAlign + plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 3.75, plusMinusButtonWidth, buttonHeight, mediumTextSize);

		sevenButton.show("7", guiCenterAlign - plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 5, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		eightButton.show("8", guiCenterAlign, row5Padding - buttonHeight * 5, plusMinusButtonWidth, buttonHeight, mediumTextSize);
		nineButton.show("9", guiCenterAlign + plusMinusButtonWidth * 1.25, row5Padding - buttonHeight * 5, plusMinusButtonWidth, buttonHeight, mediumTextSize);
	}

	void buttonAction() {
		if (zeroButton.action) {
			input = "0";
			zeroButton.action = false;
		} else if (oneButton.action) {
			input = "1";
			oneButton.action = false;
		} else if (twoButton.action) {
			input = "2";
			twoButton.action = false;
		} else if (threeButton.action) {
			input = "3";
			threeButton.action = false;
		} else if (fourButton.action) {
			input = "4";
			fourButton.action = false;
		} else if (fiveButton.action) {
			input = "5";
			fiveButton.action = false;
		} else if (sixButton.action) {
			input = "6";
			sixButton.action = false;
		} else if (sevenButton.action) {
			input = "7";
			sevenButton.action = false;
		} else if (eightButton.action) {
			input = "8";
			eightButton.action = false;
		} else if (nineButton.action) {
			input = "9";
			nineButton.action = false;
		} else if (enterButton.action) {
			input = "ENTER";
			enterButton.action = false;
		} else if (clearButton.action) {
			input = "CLEAR";
			clearButton.action = false;
		} else if (dotButton.action) {
			input = ".";
			dotButton.action = false;
		}
		if (input != "") {
			if (settings.ipFieldClicked) {
				settings.ipFieldKeyPressed();
			} else if (settings.idFieldClicked) {
				settings.idFieldKeyPressed();
			} else if (gui.channelButton.clicked) {
				gui.activeChannelKeyPressed();
			} else if (page3.bankOne.held || page3.bankTwo.held) {
				page3.directSelectKeyPressed();
			}
		}
		input = "";
	}

	void keyBG() {
		left = (guiCenterAlign - plusMinusButtonWidth * 1.25) - plusMinusButtonWidth;
		top = (row5Padding - buttonHeight * 5) - buttonHeight;
		right = (guiCenterAlign + plusMinusButtonWidth * 1.25) + plusMinusButtonWidth;
		bot = row5Padding + buttonHeight;

		push();
		rectMode(CORNERS);
		fill(black, 200);
		rect(left, top, right, bot, buttonCorner * 5);
		pop();
	}

	void mousePressed() {
		if (open) {
			enterButton.mousePressed();
			clearButton.mousePressed();
			zeroButton.mousePressed();
			dotButton.mousePressed();
			oneButton.mousePressed();
			twoButton.mousePressed();
			threeButton.mousePressed();
			fourButton.mousePressed();
			fiveButton.mousePressed();
			sixButton.mousePressed();
			sevenButton.mousePressed();
			eightButton.mousePressed();
			nineButton.mousePressed();
		}
	}

	void mouseReleased() {
		if (open) {
			enterButton.mouseReleased();
			clearButton.mouseReleased();
			zeroButton.mouseReleased();
			dotButton.mouseReleased();
			oneButton.mouseReleased();
			twoButton.mouseReleased();
			threeButton.mouseReleased();
			fourButton.mouseReleased();
			fiveButton.mouseReleased();
			sixButton.mouseReleased();
			sevenButton.mouseReleased();
			eightButton.mouseReleased();
			nineButton.mouseReleased();
		}
	}
}