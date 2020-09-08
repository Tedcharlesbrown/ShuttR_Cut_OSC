//--------------------------------------------------------------
// D_bank.h && D_bank.mm
//--------------------------------------------------------------
class BANK {
	int ID;
	int totalSelects;
	float buttonSize, padding, align, oneAlign, twoAlign, middleAlign, threeAlign, fourAlign, fiveAlign;
	float directSelectSize;
	color colorSelect;
	String selected;
	float bankHeight;

	StringList bankText = new StringList();
	StringList bankNumber = new StringList();

	PVector dSelectVector = new PVector(0, 0, 0);
	boolean dSelectFlexi = false;
	boolean vectorEventTrigger = false;

	PVector dSelectPage = new PVector(0, 0);
	boolean pageEventTrigger = false;

	void sendOSC() {
		vectorEventTrigger = true;
	}

	void sendPage() {
		pageEventTrigger = true;
	}

	float totalPalettes;
	ArrayList<BUTTON> palette = new ArrayList<BUTTON>();
	ArrayList<BUTTON> directSelect = new ArrayList<BUTTON>();

	BUTTON button = new BUTTON();
	BUTTON quickButton = new BUTTON();
	BUTTON customButton = new BUTTON();
	BUTTON leftButton = new BUTTON();
	BUTTON rightButton = new BUTTON();

//--------------------------------------------------------------
	void setup(int _ID) {
		this.ID = _ID;
		buttonSize = smallButtonWidth / 1.1;
		directSelectSize = (((height - notchHeight) / 2) / 4) - ((buttonSize * 2) / 5);
		if (directSelectSize > buttonSize) {
			directSelectSize = buttonSize;
		}
		bankHeight = buttonSize * 1.1 + directSelectSize * 4;


		oneAlign = guiCenterAlign - buttonSize * 2.2;
		twoAlign = guiCenterAlign - buttonSize * 1.1;
		middleAlign = guiCenterAlign;
		fourAlign = guiCenterAlign + buttonSize * 1.1;
		fiveAlign = guiCenterAlign + buttonSize * 2.2;

		selected = "DIRECT";
		colorSelect = black;

		totalSelects = 20;
		for (int i = 0; i <= totalSelects; i++) {
			directSelect.add(new BUTTON());
			bankText.append("");
			bankNumber.append("");
		}
		totalPalettes = 12;
		for (int i = 0; i <= totalPalettes; i++) {
			palette.add(new BUTTON());
		}

		dSelectVector.x = ID; //SET BANK ID FOR EVENT LISTENER
	}

	//--------------------------------------------------------------
	void update() {
		if (leftButton.action) {
			dSelectPage.set(ID, -1);
			clearBank();
			sendPage();
			leftButton.action = false; quickButton.clicked = false;
		} else if (rightButton.action) {
			dSelectPage.set(ID, 1);
			clearBank();
			sendPage();
			rightButton.action = false; quickButton.clicked = false;
		}

		if (palette.get(12).action) { //FLEXI
			if (palette.get(12).clicked) {
				dSelectFlexi = true;
			} else {
				dSelectFlexi = false;
			}
			clearBank();
			sendOSC();
			palette.get(12).action = false;
		}

		for (int i = 0; i <= totalSelects; i++) {
			if (directSelect.get(i).action) {
				dSelectVector.y = 0; //RESET PARAMETER
				dSelectVector.z = i + 1;
				sendOSC();
				directSelect.get(i).action = false;
			}
		}

		quickSelectAction();
	}

	//--------------------------------------------------------------
	void draw(float _padding) {
		this.padding = _padding;
		leftButton.show("<", oneAlign, padding, buttonSize, buttonHeight, "MEDIUM");

		quickButton.show(selected, "SELECTS", middleAlign, padding, genericButtonWidth * 2, buttonHeight, "MEDIUM", colorSelect);

		rightButton.show(">", fiveAlign, padding, buttonSize, buttonHeight, "MEDIUM");

		int x = 0;
		float y = 0.9;
		for (int i = 0; i < totalSelects; i++) {
			x = i % 5;
			switch (x) {
			case 0: align = oneAlign; break;
			case 1: align = twoAlign; break;
			case 2: align = middleAlign; break;
			case 3: align = fourAlign; break;
			case 4: align = fiveAlign; break;
			}
			directSelect.get(i).showDS(bankText.get(i), bankNumber.get(i), align, padding + directSelectSize * (y + y * 0.1), buttonSize, directSelectSize, colorSelect);
			if (x == 4) {
				y++;
			}
		}

		if (quickButton.clicked) {
			push();
			fill(EOSBackground, 150);
			noStroke();
			rect(0, padding + buttonSize / 2 - buttonStrokeWeight, width, padding + (buttonSize * 3.3) + buttonSize / 2 + buttonStrokeWeight);
			pop();
		}
	}

//--------------------------------------------------------------

	void quickSelectsShow() {
		float DSRowOne = padding + buttonSize * 1.5;

		palette.get(0).show("CHAN", oneAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSChannel);
		palette.get(1).show("GROUP", twoAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSGroup);
		palette.get(2).show("INTENS.", "PALETTE", middleAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSIntensity);
		palette.get(3).show("FOCUS", "PALETTE", fourAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSFocus);
		palette.get(4).show("COLOR", "PALETTE", fiveAlign, DSRowOne, buttonSize, buttonSize, "SMALL", EOSColor);

		palette.get(5).show("BEAM", "PALETTE", oneAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSBeam);
		palette.get(6).show("PRESET", twoAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSPreset);
		palette.get(7).show("MACRO", middleAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSMacro);
		palette.get(8).show("EFFECTS", fourAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSfx);
		palette.get(9).show("SNAP", fiveAlign, DSRowOne + buttonSize * 1.1, buttonSize, buttonSize, "SMALL", EOSSnap);

		palette.get(10).show("MAGIC", "SHEET", oneAlign, DSRowOne + buttonSize * 2.2, buttonSize, buttonSize, "SMALL", EOSMagic);
		palette.get(11).show("SCENE", twoAlign, DSRowOne + buttonSize * 2.2, buttonSize, buttonSize, "SMALL", EOSScene);

		palette.get(12).show("FLEXI", fourAlign, DSRowOne + buttonSize * 2.2, buttonSize * 2, buttonSize, "MEDIUM");
	}

//--------------------------------------------------------------

	void quickSelectAction() {

		for (int i = 0; i <= totalPalettes - 1; i++) {
			if (palette.get(i).action) {
				clearBank();
				quickButton.clicked = false;
				palette.get(i).action = false;
				for (int j = i + 1; j <= totalPalettes - 1; j++) { //ITERATE FORWARDS AND CLICK OFF
					palette.get(j).clicked = false;
				}
				for (int j = i - 1; j >= 0; j--) { //ITERATE BACKWARDS AND CLICK OFF
					palette.get(j).clicked = false;
				}
				dSelectVector.z = 0; //RESET BUTTON ID
				switch (i) {
				case 0:
					dSelectVector.y = 1;
					selected = "CHANNEL"; colorSelect = EOSChannel; break;
				case 1:
					dSelectVector.y = 2;
					selected = "GROUP"; colorSelect = EOSGroup; break;
				case 2:
					dSelectVector.y = 3;
					selected = "INTENSITY"; colorSelect = EOSIntensity; break;
				case 3:
					dSelectVector.y = 4;
					selected = "FOCUS"; colorSelect = EOSFocus; break;
				case 4:
					dSelectVector.y = 5;
					selected = "COLOR"; colorSelect = EOSColor; break;
				case 5:
					dSelectVector.y = 6;
					selected = "BEAM"; colorSelect = EOSBeam; break;
				case 6:
					dSelectVector.y = 7;
					selected = "PRESET"; colorSelect = EOSPreset; break;
				case 7:
					dSelectVector.y = 8;
					selected = "MACRO"; colorSelect = EOSMacro;  break;
				case 8:
					dSelectVector.y = 9;
					selected = "EFFECT"; colorSelect = EOSfx;  break;
				case 9:
					dSelectVector.y = 10;
					selected = "SNAP"; colorSelect = EOSSnap; break;
				case 10:
					dSelectVector.y = 11;
					selected = "MAGIC SHEET"; colorSelect = EOSMagic; break;
				case 11:
					dSelectVector.y = 12;
					selected = "SCENE"; colorSelect = EOSScene; break;
				}
				sendOSC();
			}
		}

	}

	//--------------------------------------------------------------
	void touchDown() {
		leftButton.touchDown(); quickButton.touchDown(true); rightButton.touchDown();
		if (quickButton.clicked) {
			for (int i = 0; i <= totalPalettes - 1; i++) {
				palette.get(i).touchDown(false);
			}
			palette.get(12).touchDown(true); //FLEXI
		} else {
			for (int i = 0; i <= totalSelects; i++) {
				directSelect.get(i).touchDown();
			}
		}
	}

//--------------------------------------------------------------
	void touchMoved() {

	}

//--------------------------------------------------------------
	void touchUp() {
		leftButton.touchUp(); rightButton.touchUp();
		if (!quickButton.clicked) {
			for (int i = 0; i <= totalSelects; i++) {
				directSelect.get(i).touchUp();
			}
		}
	}

//--------------------------------------------------------------
	void touchDoubleTap() {

	}

//------------------------PROCESSING ONLY-----------------------------

	void clearBank() {
		for (int i = 0; i <= 20; i++) {
			bankText.set(i,"");
			bankNumber.set(i,"");
		}
	}


}