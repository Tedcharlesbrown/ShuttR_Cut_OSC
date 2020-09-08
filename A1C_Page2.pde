class page2Class {
	boolean irisClicked, edgeClicked, zoomClicked, frostClicked, minusClicked, homeClicked, plusClicked, encoderClicked = false;
	float encoderPosition, lastPosition, output;
	int fineAdjust;

	String irisPercent, edgePercent, zoomPercent, frostPercent, parameter = "";

	Button irisButton = new Button(true, true);
	Button edgeButton = new Button(true, true);
	Button zoomButton = new Button(true, true);
	Button frostButton = new Button(true, true);
	Button minusButton = new Button(false, false);
	Button homeButton = new Button(false, false);
	Button plusButton = new Button(false, false);

	page2Class() {

	}

	void show() {
		buttonShow();
		buttonAction();
		percentShow();

		gui.activeChannel();
		gui.buttonShow();
		encoderDraw();
		updateAngle();
	}


	void buttonShow() {
		irisButton.show("IRIS", guiLeftAlign, row3Padding, plusMinusButtonWidth, buttonHeight, mediumTextSize, true);
		edgeButton.show("EDGE", guiCenterAlign - genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, mediumTextSize, true);
		zoomButton.show("ZOOM", guiCenterAlign + genericButtonWidth / 2, row3Padding, plusMinusButtonWidth, buttonHeight, mediumTextSize, true);
		frostButton.show("FROST", guiRightAlign, row3Padding, plusMinusButtonWidth, buttonHeight, mediumTextSize, true);

		minusButton.show("-%", guiLeftAlign, row5Padding, genericButtonWidth, buttonHeight, largeTextSize);
		homeButton.show("HOME", guiCenterAlign, row5Padding, genericButtonWidth, buttonHeight, largeTextSize);
		plusButton.show("+%", guiRightAlign, row5Padding, genericButtonWidth, buttonHeight, largeTextSize);
	}

	void buttonAction() {
		if (irisButton.toggled && irisButton.clicked) {
			irisButton.clicked = true; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = false;
			irisButton.toggled = false;
			parameter = "iris";
			if (irisButton.doubleClicked) {
				handleOSC.sendEncoderPercent(parameter, 0);
				irisButton.doubleClicked = false;
			}
		} else if (edgeButton.toggled && edgeButton.clicked) {
			irisButton.clicked = false; edgeButton.clicked = true; zoomButton.clicked = false; frostButton.clicked = false;
			edgeButton.toggled = false;
			parameter = "edge";
			if (edgeButton.doubleClicked) {
				handleOSC.sendEncoderPercent(parameter, 0);
				edgeButton.doubleClicked = false;
			}
		} else if (zoomButton.toggled && zoomButton.clicked) {
			irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = true; frostButton.clicked = false;
			zoomButton.toggled = false;
			parameter = "zoom";
			if (zoomButton.doubleClicked) {
				handleOSC.sendEncoderPercent(parameter, 0);
				zoomButton.doubleClicked = false;
			}
		} else if (frostButton.toggled && frostButton.clicked) {
			irisButton.clicked = false; edgeButton.clicked = false; zoomButton.clicked = false; frostButton.clicked = true;
			frostButton.toggled = false;
			parameter = "diffusion";
			if (frostButton.doubleClicked) {
				handleOSC.sendEncoderPercent(parameter, 0);
				frostButton.doubleClicked = false;
			}
		}
		if (minusButton.action) {
			handleOSC.sendEncoderPercent(parameter, -1);
			minusButton.action = false;
		} else if (homeButton.action) {
			handleOSC.sendEncoderPercent(parameter, 0);
			homeButton.action = false;
		} else if (plusButton.action) {
			handleOSC.sendEncoderPercent(parameter, 1);
			plusButton.action = false;
		}
	}

	void percentShow() {
		if (irisPercent != null) {
			irisButton.readoutText(irisPercent);
			edgeButton.readoutText(edgePercent);
			zoomButton.readoutText(zoomPercent);
			frostButton.readoutText(frostPercent);
		}
	}

//----------------------------------------ENCODER----------------------------------------------

	void encoderDraw() {
		pushMatrix();
		//ENCODER //TWO_PI/NUMBER OF DIALS
		translate(centerX, centerY);
		rotate(encoderPosition - radians(90));
		image(IMGEncoder, 0, 0, assemblyDiameter / 1.25, assemblyDiameter / 1.25);
		popMatrix();
	}

	void updateAngle() {
		if (encoderClicked) {
			lastPosition = encoderPosition;
			encoderPosition = atan2(mouseY - centerY, mouseX - centerX);
			encoderPosition = radians(map(encoderPosition, -PI, PI, 0, 360));
			if (gui.fineClicked) {
				fineAdjust = 1;
			} else {
				fineAdjust = 2;
			}
			if (lastPosition < encoderPosition) {
				handleOSC.sendEncoder(parameter, fineAdjust);
			} else if (lastPosition > encoderPosition) {
				handleOSC.sendEncoder(parameter, -fineAdjust);
			}
		}
	}

//----------------------------------------EVENTS----------------------------------------------

	void mousePressed() {
		if (gui.page2Menu && !gui.settingsMenu && !keyboard.open) {
			irisButton.mousePressed();
			edgeButton.mousePressed();
			zoomButton.mousePressed();
			frostButton.mousePressed();
			minusButton.mousePressed();
			homeButton.mousePressed();
			plusButton.mousePressed();
		}
	}

	void mouseReleased() {
		if (gui.page2Menu && !gui.settingsMenu && !keyboard.open) {
			minusButton.mouseReleased();
			homeButton.mouseReleased();
			plusButton.mouseReleased();
			encoderClicked = false;
		}
	}

	void mouseDragged() {
		if (dist(mouseX, mouseY, centerX, centerY) < assemblyRadius) {
			encoderClicked = true;
		}
	}

	void doubleClicked() {
		irisButton.doubleClicked();
		edgeButton.doubleClicked();
		zoomButton.doubleClicked();
		frostButton.doubleClicked();
	}
}