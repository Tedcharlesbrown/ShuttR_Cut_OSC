class thrustSlider {
  float position = 1; // The position of the slider between 0 and 1
  float sliderX, sliderY;
  String ID;
  float offset;
  boolean clicked;

  thrustSlider(String tempID) {
    this.ID = tempID;
  }

  void display(float tempSliderX, float tempSliderY) {
    this.sliderX = tempSliderX;
    this.sliderY = tempSliderY;
    displayButton();
    displayText();
  }

  void displayButton() {
    stroke(thrustStroke);
    strokeWeight(thrustWeight);
    fill(thrustFill);
    circle(0, 0, clickDiameter);
  }

  void displayText() {
    rotate(-rotation);
    fill(thrustText);
    textSize(clickRadius);
    textAlign(CENTER, CENTER);
    text(this.ID, -1, -3);
  }

  void addOffset(float tempOffset) { // Add an offset to the position of the slider  ///BOT,TOP
    float topLimit = clickDiameter / assemblyRadius;
    this.clicked = true;
    this.offset = tempOffset;
    this.position = constrain(position + this.offset, topLimit, 1); // Constrain it between [0, 1]
    //float angleOffset = abs(map(angleA.output(),-50,50,topLimit * 1.6,-topLimit * 1.6));
    //this.position = constrain(position + this.offset, topLimit + angleOffset, 1 - angleOffset); // Constrain it between [0, 1]
    handleOSC.send(this.ID, true, output());
  }

  void doubleClicked() {
    if (dist(mouseX, mouseY, this.sliderX, this.sliderY) < clickRadius) {
      this.position = 1;
      handleOSC.send(this.ID, true, output());
    }
  }

  void home() {
    this.position = 1;
    handleOSC.send(this.ID, true, output());
  }

  void incomingOSC(float value) {
    if (!clicked) {
      value = map(value, 0, 100, 1, (clickDiameter / assemblyRadius));
      this.position = value;
    }
  }

  float output() {
    return map(this.position, (clickDiameter / assemblyRadius), 1, 100, 0);
  }
  float outputBinary() {
    return map(this.position, (clickDiameter / assemblyRadius), 1, 1, 0);
  }
}