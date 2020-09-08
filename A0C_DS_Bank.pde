class Bank {
	int totalSelects = 20;

	Button quickButton = new Button(true, false);
	Button customButton = new Button(true, false);
	Button leftButton = new Button(false, false);
	Button rightButton = new Button(false, false);

	ArrayList<DirectSelect> directSelect = new ArrayList<DirectSelect>();
	ArrayList<Button> paletteButton = new ArrayList<Button>();

	float buttonSize, padding, align, topRow;

	color colour;

	String[] bankText, bankNumber;

	String flexi, ID, select, ds;

	boolean held = false;

	Bank() {
		bankText = new String[20];
		bankNumber = new String[20];
		for (int i = 0; i < totalSelects; i++) {
			directSelect.add(new DirectSelect(i));
		}
		for (int i = 0; i < 12; i++) {
			paletteButton.add(new Button(true, true));
		}
		paletteButton.add(new Button(true, false));
	}

	void show(String tempID, float tempPadding, float tempSize) {
		this.ID = tempID;
		this.topRow = tempPadding;
		this.padding = topRow + height / 11.84;
		this.buttonSize = tempSize;
		directSelectShow();

		leftButton.show("<", page3.oneAlign, this.topRow, this.buttonSize, buttonHeight, mediumTextSize);
		if (select != null) {
			quickButton.show(select, "SELECTS", page3.middleAlign, this.topRow, genericButtonWidth * 2, buttonHeight, mediumTextSize, this.colour);
		} else {
			quickButton.show("DIRECT", "SELECTS", page3.middleAlign, this.topRow, genericButtonWidth * 2, buttonHeight, mediumTextSize);
		}
		//customButton.show("CUSTOM", "SELECTS", page3.fourAlign - genericButtonWidth / 4, this.topRow, genericButtonWidth, buttonHeight, mediumTextSize);
		rightButton.show(">", page3.fiveAlign, this.topRow, this.buttonSize, buttonHeight, mediumTextSize);

		quickCustomButtonAction();
	}

	void selectHide() {
		push();
		rectMode(CORNERS);
		fill(EOSBackground, 150);
		noStroke();
		rect(0, this.padding - buttonStrokeWeight - page3.buttonSize / 2, width, this.padding + (this.buttonSize * 3.3) + this.buttonSize / 2 + buttonStrokeWeight);
		pop();
	}

	void quickCustomButtonAction() {
		if (quickButton.toggled && quickButton.clicked) {
			quickButton.action = true;
			quickButton.toggled = false;
			customButton.clicked = false;
		} else if (!quickButton.clicked) {
			quickButton.action = false;
		}
		if (customButton.toggled && customButton.clicked) {
			customButton.action = true;
			customButton.toggled = false;
			quickButton.clicked = false;
			for (int i = 0; i < totalSelects; i++) {
				bankText[i] = "";
				bankNumber[i] = "";
				this.colour = black;
			}
		} else if (!customButton.clicked) {

		}
	}

	void quickSelectShow() {
		selectHide();
		paletteButton.get(0).show("CHANNEL", page3.oneAlign, this.padding + this.buttonSize / 2, this.buttonSize, this.buttonSize, smallTextSize, EOSChannel);
		paletteButton.get(1).show("GROUP", page3.twoAlign, this.padding + this.buttonSize / 2, this.buttonSize, this.buttonSize, smallTextSize, EOSGroup);
		paletteButton.get(2).show("INTENS.", "PALETTE", page3.middleAlign, this.padding + this.buttonSize / 2, this.buttonSize, this.buttonSize, smallTextSize, EOSIntensity);
		paletteButton.get(3).show("FOCUS", "PALETTE", page3.fourAlign, this.padding + this.buttonSize / 2, this.buttonSize, this.buttonSize, smallTextSize, EOSFocus);
		paletteButton.get(4).show("COLOR", "PALETTE", page3.fiveAlign, this.padding + this.buttonSize / 2, this.buttonSize, this.buttonSize, smallTextSize, EOSColor);

		paletteButton.get(5).show("BEAM", "PALETTE", page3.oneAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 1.1, this.buttonSize, this.buttonSize, smallTextSize, EOSBeam);
		paletteButton.get(6).show("PRESET", page3.twoAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 1.1, this.buttonSize, this.buttonSize, smallTextSize, EOSPreset);
		paletteButton.get(7).show("MACRO", page3.middleAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 1.1, this.buttonSize, this.buttonSize, smallTextSize, EOSMacro);
		paletteButton.get(8).show("EFFECTS", page3.fourAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 1.1, this.buttonSize, this.buttonSize, smallTextSize, EOSfx);
		paletteButton.get(9).show("SNAP", page3.fiveAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 1.1, this.buttonSize, this.buttonSize, smallTextSize, EOSSnap);

		paletteButton.get(10).show("MAGIC", "SHEET", page3.oneAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 2.2, this.buttonSize, buttonSize, smallTextSize, EOSMagic);
		paletteButton.get(11).show("SCENE", page3.twoAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 2.2, this.buttonSize, this.buttonSize, smallTextSize, EOSScene);

		paletteButton.get(12).show("FLEXI", page3.fourAlign, (this.padding + this.buttonSize / 2) + this.buttonSize * 2.2, this.buttonSize * 2, this.buttonSize, mediumTextSize);

		quickSelectAction();
	}

	void quickSelectAction() {
		for (int i = 0; i < 12; i++) {
			if (paletteButton.get(i).toggled && paletteButton.get(i).clicked) {
				if (paletteButton.get(12).clicked) {
					flexi = "/flexi";
				} else {
					flexi = "";
				}
				paletteButton.get(i).clicked = true;
				paletteButton.get(i).toggled = false;
				for (int j = i + 1; j < 12; j++) {
					paletteButton.get(j).clicked = false;
				}
				for (int j = i - 1; j >= 0; j--) {
					paletteButton.get(j).clicked = false;
				}
				switch (i) {
				case 0:
					handleOSC.directSelectRequest(this.ID, "chan" + flexi, "20");
					this.colour = EOSChannel;
					this.select = "CHANNEL";
					break;
				case 1:
					handleOSC.directSelectRequest(this.ID, "group"  + flexi, "20");
					this.colour = EOSGroup;
					this.select = "GROUP";
					break;
				case 2:
					handleOSC.directSelectRequest(this.ID, "ip"  + flexi, "20");
					this.colour = EOSIntensity;
					this.select = "INTENSITY";
					break;
				case 3:
					handleOSC.directSelectRequest(this.ID, "fp"  + flexi, "20");
					this.colour = EOSFocus;
					this.select = "FOCUS";
					break;
				case 4:
					handleOSC.directSelectRequest(this.ID, "cp"  + flexi, "20");
					this.colour = EOSColor;
					this.select = "COLOR";
					break;
				case 5:
					handleOSC.directSelectRequest(this.ID, "bp"  + flexi, "20");
					this.colour = EOSBeam;
					this.select = "BEAM";
					break;
				case 6:
					handleOSC.directSelectRequest(this.ID, "preset"  + flexi, "20");
					this.colour = EOSPreset;
					this.select = "PRESET";
					break;
				case 7:
					handleOSC.directSelectRequest(this.ID, "macro"  + flexi, "20");
					this.colour = EOSMacro;
					this.select = "MACRO";
					break;
				case 8:
					handleOSC.directSelectRequest(this.ID, "fx"  + flexi, "20");
					this.colour = EOSfx;
					this.select = "EFFECTS";
					break;
				case 9:
					handleOSC.directSelectRequest(this.ID, "snap"  + flexi, "20");
					this.colour = EOSSnap;
					this.select = "SNAPSHOT";
					break;
				case 10:
					handleOSC.directSelectRequest(this.ID, "ms"  + flexi, "20");
					this.colour = EOSMagic;
					this.select = "MAGIC SHEET";
					break;
				case 11:
					handleOSC.directSelectRequest(this.ID, "scene"  + flexi, "20");
					this.colour = EOSScene;
					this.select = "SCENE";
					break;
				}
				quickButton.action = false;
				quickButton.clicked = false;
			}
		}
	}


	void directSelectShow() {
		int x = 0;
		float y = 0;
		for (int i = 0; i < totalSelects; i++) {
			x = i % 5;
			switch(x) {
			case 0:
				align = page3.oneAlign;
				break;
			case 1:
				align = page3.twoAlign;
				break;
			case 2:
				align = page3.middleAlign;
				break;
			case 3:
				align = page3.fourAlign;
				break;
			case 4:
				align = page3.fiveAlign;
				break;
			}
			if (bankText[i] != null) {
				directSelect.get(i).show(bankText[i], bankNumber[i], align, this.padding + (this.buttonSize * (y + y * 0.1)), this.buttonSize, this.buttonSize, smallTextSize, this.colour);
			} else {
				directSelect.get(i).show("", "", align, this.padding + (this.buttonSize * (y + y * 0.1)), this.buttonSize, this.buttonSize, smallTextSize, this.colour);
			}
			if (x == 4) {
				y++;
			}
		}
	}

	void directSelectAction() {
		if (customButton.clicked) {
			for (int i = 0; i < totalSelects; i++) {
				if (directSelect.get(i).released) { //ON RELEASE SEND ACTION
					handleOSC.sendDirectSelect(str(i + int(this.ID)), str(i + 1));
				}
			}
			return;
		}
		for (int i = 0; i < totalSelects; i++) {
			if (directSelect.get(i).released) { //ON RELEASE SEND ACTION
				handleOSC.sendDirectSelect(this.ID, str(i + 1));
			}
		}
	}

	void directSelectRequest(String tempSelect) {
		this.ds = tempSelect;
		for (int i = 0; i < totalSelects; i++) {
			if (directSelect.get(i).held) {	//ON HOLD, POP UP MENU
				bankText[i] = "";
				//handleOSC.directSelectRequest(str(i + int(this.ID)), "macro", str(i + 1));
				handleOSC.directSelectRequest(str(i + int(this.ID)), "macro", this.ds);
			}
		}
	}

	void mousePressed() {
		if (!keyboard.open) {
			if (!quickButton.clicked) {
				for (int i = 0; i < totalSelects; i++) {
					directSelect.get(i).mousePressed();
				}
			} else if (quickButton.clicked || customButton.clicked) {
				for (int i = 0; i < 12; i++) {
					paletteButton.get(i).mousePressed();
				}
			}
			leftButton.mousePressed();
			rightButton.mousePressed();
			paletteButton.get(12).mousePressed();
			quickButton.mousePressed();
			customButton.mousePressed();
		}
	}

	void mouseReleased() {
		if (!keyboard.open) {
			if (!quickButton.clicked) {
				for (int i = 0; i < totalSelects; i++) {
					directSelect.get(i).mouseReleased();
				}
			} else if (quickButton.clicked || customButton.clicked) {
				for (int i = 0; i < 12; i++) {
					paletteButton.get(i).mouseReleased();
				}
			}
			leftButton.mouseReleased();
			rightButton.mouseReleased();
			paletteButton.get(12).mouseReleased();
			quickButton.mouseReleased();
			customButton.mouseReleased();

			if (!this.held) {
				directSelectAction();
			}
			this.held = false;
		}
	}

	void mouseHeld() {
		if (customButton.clicked) {
			if (!this.held) { //PREVENT MULTIPLE SENDS
				for (int i = 0; i < totalSelects; i++) {
					directSelect.get(i).mouseHeld();
				}
				this.held = true;
				//directSelectRequest("");
			}
		}
	}
}