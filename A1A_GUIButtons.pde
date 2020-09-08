class GUIClass {
	boolean plusChannelClicked, minusChannelClicked, fineClicked, highClicked, flashClicked = false;
	boolean settingsMenu, page1Menu, page2Menu, page3Menu = false;

	Button plusButton = new Button(false, false);
	Button minusButton = new Button(false, false);
	Button fineButton = new Button(true, false);
	Button highButton = new Button(true, false);
	Button flashButton = new Button(false, false);

	Button channelButton = new Button(true, false);

	String userInputChannel = "";
	String inputChannel = "";

	boolean userTyping = false;

	GUIClass() {

	}

	void show() {
		gui.settingsButton();
		gui.page1Button();
		gui.page2Button();
		gui.page3Button();
		gui.oscSendLight();
		gui.oscRecieveLight();
	}

	//--------------------------------------------ROW 0---------------------------------------------------

	void settingsButton() {
		push();
		if (gui.settingsMenu) {
			fill(white);
		} else {
			fill(black);
		}
		stroke(shutterOutsideStroke);
		strokeWeight(buttonStrokeWeight);
		rect(width - smallButtonWidth, 0, smallButtonWidth, settingsBarHeight, buttonCorner);
		fill(shutterOutsideStroke);
		circle(width - smallButtonWidth / 2, settingsBarHeight  / 2, width / 28.8);
		pop();
	}

	void settingsButtonClicked() {
		if (mouseX > width - smallButtonWidth && mouseY < settingsBarHeight) {
			gui.settingsMenu = !gui.settingsMenu;
		}
	}

	void settingsButtonReleased() {
		//settingsMenu = false;
	}

	//--------------------------------------------PAGE 1---------------------------------------------------

	void page1Button() {
		push();
		rectMode(CENTER);
		if (gui.page1Menu && !gui.settingsMenu) {
			fill(buttonActive);
		} else {
			fill(black);
		}
		stroke(shutterOutsideStroke);
		strokeWeight(buttonStrokeWeight);
		rect(centerX - genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonCorner);
		pop();
	}

	void page1ButtonClicked() {
		if (mouseX > centerX - genericButtonWidth * 1.5 && mouseX - genericButtonWidth / 2 < centerX && mouseY < settingsBarHeight) {
			gui.page1Menu = true;
			gui.page2Menu = false;
			gui.page3Menu = false;
			gui.settingsMenu = false;
		}
	}

	//--------------------------------------------PAGE 2--------------------------------------------------

	void page2Button() {
		push();
		rectMode(CENTER);
		if (gui.page2Menu && !gui.settingsMenu) {
			fill(buttonActive);
		} else {
			fill(black);
		}
		stroke(shutterOutsideStroke);
		strokeWeight(buttonStrokeWeight);
		rect(centerX, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonCorner);
		pop();
	}

	void page2ButtonClicked() {
		if (mouseX > centerX - genericButtonWidth / 2 && mouseX < centerX + genericButtonWidth / 2 && mouseY < settingsBarHeight) {
			gui.page1Menu = false;
			gui.page2Menu = true;
			gui.page3Menu = false;
			gui.settingsMenu = false;
		}
	}


	//--------------------------------------------PAGE 3---------------------------------------------------

	void page3Button() {
		push();
		rectMode(CENTER);
		if (gui.page3Menu && !gui.settingsMenu) {
			fill(buttonActive);
		} else {
			fill(black);
		}
		stroke(shutterOutsideStroke);
		strokeWeight(buttonStrokeWeight);
		rect(centerX + genericButtonWidth, settingsBarHeight / 2, genericButtonWidth, settingsBarHeight, buttonCorner);
		pop();
	}

	void page3ButtonClicked() {
		if (mouseX > centerX + genericButtonWidth / 2 && mouseX < centerX + genericButtonWidth * 1.5 && mouseY < settingsBarHeight) {
			gui.page1Menu = false;
			gui.page2Menu = false;
			gui.page3Menu = true;
			gui.settingsMenu = false;
		}
	}


	//--------------------------------------------SEND RECIEVE LIGHTS---------------------------------------------------

	void oscSendLight() {
		push();
		stroke(black);
		if (oscPackageSendLight) {
			fill(EOSLightGreen);
		} else {
			fill(EOSGreen);
		}
		rect(0, 0, smallButtonWidth, settingsBarHeight / 2, buttonCorner);
		pop();
	}

	void oscRecieveLight() {
		push();
		stroke(black);
		if (oscPackageReceiveLight) {
			fill(EOSLightRed);
		} else {
			fill(EOSRed);
		}
		rect(0, settingsBarHeight / 2, smallButtonWidth, settingsBarHeight / 2, buttonCorner);
		pop();
	}

	//--------------------------------------------ROW 1---------------------------------------------------
	//----------------------------------------ACTIVE CHANNEL----------------------------------------------

	void activeChannel() {
		if (!channelButton.clicked) {
			userInputChannel = handleOSC.channelNumberString();
		}
		channelButton.show(userInputChannel, centerX, row1Padding, activeChannelWidth, buttonHeight, largeTextSize);
		push();
		fill(white);
		textAlign(CENTER, CENTER);
		textSize(tinyTextSize);
		text("SELECTED CHANNEL:", centerX, row1Padding - (buttonHeight / 2) - tinyTextSize);
		pop();
		if (channelButton.clicked) {
			keyboard.open = true;
		}
	}

	void activeChannelKeyPressed() {
		if (!userTyping) {
			userInputChannel = "";
			userTyping = true;
		}
		if (keyboard.input == "CLEAR" || key == BACKSPACE || key == DELETE) {
			if (userInputChannel.length() == 0) {
				return;
			} else {
				userInputChannel = userInputChannel.substring(0, userInputChannel.length() - 1);
			}
		} else if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '.') {
			if (userInputChannel.length() <= 15) {
				userInputChannel += key;
			}
		} else if (keyboard.input == "0" || keyboard.input == "1" || keyboard.input == "2" || keyboard.input == "3" || keyboard.input == "4" || keyboard.input == "5" || keyboard.input == "6" || keyboard.input == "7" || keyboard.input == "8" || keyboard.input == "9" || keyboard.input == ".") {
			if (userInputChannel.length() <= 15) {
				userInputChannel += keyboard.input;
			}
		}
		if (keyboard.input == "ENTER" || key == ENTER || key == RETURN) {
			inputChannel = trim(userInputChannel);
			handleOSC.sendChannelNumber(inputChannel);
			handleOSC.sendEnter();
			channelButton.clicked = false;
			keyboard.open = false;
			userTyping = false;
		} else {
			return;
		}
	}

	//----------------------------------------PLUS CHANNEL----------------------------------------------

	void buttonShow() {
		plusButton.show("+", guiRightAlign, row1Padding, plusMinusButtonWidth, buttonHeight, largeTextSize);
		minusButton.show("-", guiLeftAlign, row1Padding, plusMinusButtonWidth, buttonHeight, largeTextSize);
		fineButton.show("FINE", guiLeftAlign, row2Padding, genericButtonWidth, buttonHeight, largeTextSize);
		highButton.show("HIGH", guiCenterAlign, row2Padding, genericButtonWidth, buttonHeight, largeTextSize);
		flashButton.show("FLASH", guiRightAlign, row2Padding, genericButtonWidth, buttonHeight, largeTextSize);
		buttonAction();
	}

	void buttonAction() {
		if (plusButton.action) {
			handleOSC.sendChannel("NEXT");
			plusButton.action = false;
		}
		if (minusButton.action) {
			handleOSC.sendChannel("LAST");
			minusButton.action = false;
		}
		if (fineButton.clicked) {
			fineClicked = !fineClicked;
		}
		if (highButton.action) {
			handleOSC.sendHigh();
			highButton.action = false;
		}
		if (flashButton.action) {
			if (channelFlashIntensity >= 90) {
				handleOSC.sendFlash("FLASH_OFF");
			} else {
				handleOSC.sendFlash("FLASH_ON");
			}
			flashButton.action = false;
		}
		if (flashButton.released) {
			handleOSC.sendFlash("OFF");
			flashButton.released = false;
		}

	}

//----------------------------------------EVENTS----------------------------------------------

	void mousePressed() {
		if ((gui.page1Menu || gui.page2Menu) && !gui.settingsMenu) {
			channelButton.mousePressed();
			plusButton.mousePressed();
			minusButton.mousePressed();
			fineButton.mousePressed();
			highButton.mousePressed();
			flashButton.mousePressed();
		}
		if (keyboard.open && (mouseX < keyboard.left || mouseX > keyboard.right || mouseY < keyboard.top || mouseY > keyboard.bot)) {
			keyboard.open = false;
			userTyping = false;
			channelButton.clicked = false;
		}
		page1.mousePressed();
		page2.mousePressed();
		//page3.mousePressed();

		page1ButtonClicked();
		page2ButtonClicked();
		page3ButtonClicked();
		settingsButtonClicked();
	}

	void mouseReleased() {
		if ((gui.page1Menu || gui.page2Menu) && !gui.settingsMenu) {
			channelButton.mouseReleased();
			plusButton.mouseReleased();
			minusButton.mouseReleased();
			fineButton.mouseReleased();
			highButton.mouseReleased();
			flashButton.mouseReleased();
		}
		page1.mouseReleased();
		page2.mouseReleased();
		settingsButtonReleased();
	}

	void keyPressed() {
		activeChannelKeyPressed();
	}

}