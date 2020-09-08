class assemblyAngle {
	float frameX = centerX;
	float frameY = centerY + assemblyRadius + clickDiameter * 1.5;
	float defaultX = frameX;
	boolean clicked = false;
	float botLimit = centerX - assemblyRadius;
	float topLimit = centerX + assemblyRadius;
	assemblyAngle() {
	}
	void display() {
		lineDisplay();
		buttonDisplay();
	}
	void buttonDisplay() {
		fill(assemblyButtonFill);
		stroke(assemblyButtonStroke);
		strokeWeight(assemblyButtonWeight);
		circle(frameX, frameY, clickDiameter);
	}

	void lineDisplay() {
		push();
		strokeWeight(assemblyLineWeight);
		stroke(assemblyLine);
		line(botLimit, frameY, topLimit, frameY);
		pop();
	}

	void mousePressed() {
		if (dist(mouseX, mouseY, frameX, frameY) < clickRadius) {
			this.clicked = true;
		}
	}

	void mouseReleased() {
		this.clicked = false;
	}

	void mouseDragged(boolean fromOSC) {
		if (clicked) {
			if (gui.fineClicked) {
				frameX += ((mouseX - pmouseX) / 3);
			} else {
				frameX += ((mouseX - pmouseX));
			}
			frameX = constrain(frameX, botLimit, topLimit);
			float temp = map(frameX, botLimit, topLimit, radians(45), radians(-45));
			rotation = temp;// - (temp % 0.01);
			handleOSC.send("FRAME", false, output());
		} else if (fromOSC) {
			frameX += (mouseX - pmouseX);
			frameX = constrain(frameX, botLimit, topLimit);
			rotation = map(frameX, botLimit, topLimit, radians(45), radians(-45));
		}
	}

	void doubleClicked() {
		if (dist(mouseX, mouseY, frameX, frameY) < clickRadius) {
			frameX = defaultX;
			clicked = true;
			frameAssembly.mouseDragged(false);
			clicked = false;
		}
	}

	void home() {
		frameX = defaultX;
		rotation = map(frameX, botLimit, topLimit, radians(45), radians(-45));
		handleOSC.send("FRAME", false, output());
	}

	void incomingOSC(float value) {
		if (!clicked) {
			value = map(value, -45, 45, botLimit, topLimit);
			frameX = value;
			frameAssembly.mouseDragged(true);
		}
	}

	float output() {
		return map(frameX, botLimit, topLimit, -50, 50);
	}
}