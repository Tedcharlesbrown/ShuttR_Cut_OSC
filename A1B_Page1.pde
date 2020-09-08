thrustHandle thrustA, thrustB, thrustC, thrustD;
angleHandle angleA, angleB, angleC, angleD;
assemblyAngle frameAssembly;
PImage IMGbgAssembly;
float shutterStrokeWeight, outsideWeight, thrustWeight, angleWeight, crosshairWeight, assemblyButtonWeight, assemblyLineWeight;

class page1Class {
	boolean thrustClicked, angleClicked, shutterClicked = false;

	Button thrustHomeButton = new Button(false, false);
	Button angleHomeButton = new Button(false, false);
	Button shutterHomeButton = new Button(false, false);

	page1Class() {

	}

	void show() {
		frameAssemblyDraw();
		gui.activeChannel();
		gui.buttonShow();
		buttonShow();
		buttonAction();
	}

	//--------------------------------------------ROW 3---------------------------------------------------
	//----------------------------------------THRUST BUTTON----------------------------------------------


	void buttonShow() {
		thrustHomeButton.show("THRUST", "HOME", guiLeftAlign, row3Padding, genericButtonWidth, buttonHeight, mediumTextSize);
		angleHomeButton.show("ANGLE", "HOME", guiCenterAlign, row3Padding, genericButtonWidth, buttonHeight, mediumTextSize);
		shutterHomeButton.show("SHUTTER", "HOME", guiRightAlign, row3Padding, genericButtonWidth, buttonHeight, mediumTextSize);
	}

	void buttonAction() {
		if (thrustHomeButton.clicked) {
			thrustA.thrustSliderA.home();
			thrustB.thrustSliderB.home();
			thrustC.thrustSliderC.home();
			thrustD.thrustSliderD.home();
		}
		if (angleHomeButton.clicked) {
			angleA.home();
			angleB.home();
			angleC.home();
			angleD.home();
		}
		if (shutterHomeButton.clicked) {
			angleA.home();
			angleB.home();
			angleC.home();
			angleD.home();

			thrustA.thrustSliderA.home();
			thrustB.thrustSliderB.home();
			thrustC.thrustSliderC.home();
			thrustD.thrustSliderD.home();

			frameAssembly.home();
		}

	}


	void frameAssemblyInit() {
		thrustA = new thrustHandle("A"); thrustB = new thrustHandle("B"); thrustC = new thrustHandle("C"); thrustD = new thrustHandle("D");
		angleA = new angleHandle("A"); angleB = new angleHandle("B"); angleC = new angleHandle("C"); angleD = new angleHandle("D");
		frameAssembly = new assemblyAngle();

		IMGbgAssembly = loadImage("IMG_bgAssembly.png");
		IMGbgAssembly.resize(assemblyDiameter * 2, assemblyDiameter * 2);

		shutterStrokeWeight = width / 72; //20
		outsideWeight = width / 96; //15
		thrustWeight = width / 288; //5
		angleWeight = width / 288; //5
		crosshairWeight = width / 144;
		assemblyButtonWeight = width / 288; //5
		assemblyLineWeight = width / 144; //10
	}

	void frameAssemblyDraw() {
		push();
		pushMatrix();

		translate(centerX, centerY);     // Translate to its location and rotate
		rotate(rotation);
		// Display inner circle
		noStroke();
		fill(BGFill);
		circle(0, 0, assemblyDiameter);

		angleA.displayFrame(); angleC.displayFrame(); angleD.displayFrame(); angleB.displayFrame();

		popMatrix();

		bgAssembly();

		pushMatrix();

		translate(centerX, centerY);
		rotate(rotation);

		angleA.displaySlider(); angleB.displaySlider(); angleC.displaySlider(); angleD.displaySlider();

		thrustA.display(); thrustB.display(); thrustC.display(); thrustD.display();

		popMatrix();

		frameAssembly.display();
		appBackground();
		pop();
	}

	void bgAssembly() {
		pushMatrix();
		translate(centerX, centerY);
		tint(EOSBackground);
		image(IMGbgAssembly, 0, 0);
		//Crosshairs
		rotate(rotation);
		stroke(crosshairColor);
		strokeWeight(crosshairWeight);
		line(- assemblyRadius, 0, assemblyRadius, 0);
		line(0, - assemblyRadius, 0, assemblyRadius);
		// Display outer circle
		push();
		stroke(outsideStroke);
		strokeWeight(outsideWeight);
		noFill();
		circle(0, 0, assemblyDiameter);
		pop();
		popMatrix();
	}

	void appBackground() {
		push();
		noStroke();
		fill(EOSBackground);
		rect(0, 0, width * 2, height / 1.8);
		pop();
	}

	void mousePressed() {
		if (gui.page1Menu && !gui.settingsMenu && !keyboard.open) {
			thrustHomeButton.mousePressed();
			angleHomeButton.mousePressed();
			shutterHomeButton.mousePressed();
		}
	}

	void mouseReleased() {
		if (gui.page1Menu && !gui.settingsMenu && !keyboard.open) {
			thrustHomeButton.mouseReleased();
			angleHomeButton.mouseReleased();
			shutterHomeButton.mouseReleased();
		}
	}

}