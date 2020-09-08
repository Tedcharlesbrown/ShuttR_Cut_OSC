class page3Class {


	Bank bankOne = new Bank();
	Bank bankTwo = new Bank();

	boolean quickSelect = false;

	float buttonSize, padding, align, oneAlign, twoAlign, middleAlign, fourAlign, fiveAlign;

	String userInputSelect = "";
	String inputSelect = "";

	page3Class() {

	}


	void show() {
		buttonSize = plusMinusButtonWidth;
		oneAlign = guiCenterAlign - buttonSize * 2.2;
		twoAlign = guiCenterAlign - buttonSize * 1.1;
		middleAlign = guiCenterAlign;
		fourAlign = guiCenterAlign + buttonSize * 1.1;
		fiveAlign = guiCenterAlign + buttonSize * 2.2;

		bankOne.show("1", row1Padding, buttonSize);
		bankTwo.show("21", row1Padding * 5.5, buttonSize);

		if (bankOne.quickButton.clicked) {
			bankOne.quickSelectShow();
		} else if (bankOne.leftButton.action) {
			handleOSC.directSelectPage("1", "-1");
			bankOne.leftButton.action = false;
		} else if (bankOne.rightButton.action) {
			handleOSC.directSelectPage("1", "1");
			bankOne.rightButton.action = false;
		}
		if (bankTwo.quickButton.clicked) {
			bankTwo.quickSelectShow();
		} else if (bankTwo.leftButton.action) {
			handleOSC.directSelectPage("21", "-1");
			bankTwo.leftButton.action = false;
		} else if (bankTwo.rightButton.action) {
			handleOSC.directSelectPage("21", "1");
			bankTwo.rightButton.action = false;
		}
	}

	void directSelectKeyPressed() {
		if (keyboard.input == "CLEAR" || key == BACKSPACE || key == DELETE) {
			if (userInputSelect.length() == 0) {
				return;
			} else {
				userInputSelect = userInputSelect.substring(0, userInputSelect.length() - 1);
			}
		} else if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '.') {
			if (userInputSelect.length() <= 15) {
				userInputSelect += key;
			}
		} else if (keyboard.input == "0" || keyboard.input == "1" || keyboard.input == "2" || keyboard.input == "3" || keyboard.input == "4" || keyboard.input == "5" || keyboard.input == "6" || keyboard.input == "7" || keyboard.input == "8" || keyboard.input == "9" || keyboard.input == ".") {
			if (userInputSelect.length() <= 15) {
				userInputSelect += keyboard.input;
			}
		}
		if (keyboard.input == "ENTER" || key == ENTER || key == RETURN) {
			inputSelect = userInputSelect;
			bankOne.directSelectRequest(inputSelect);
			keyboard.open = false;
		} else {
			return;
		}
	}

	void mousePressed() {
		bankOne.mousePressed();
		bankTwo.mousePressed();

	}

	void mouseReleased() {
		bankOne.mouseReleased();
		bankTwo.mouseReleased();

	}

	void mouseDragged() {
	}

	void keyPressed() {
		directSelectKeyPressed();
	}

	void mouseHeld() {
		bankOne.mouseHeld();
		bankTwo.mouseHeld();
	}

}