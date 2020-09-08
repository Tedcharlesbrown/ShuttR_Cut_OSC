class angleHandle {
  angleSlider angleSliderA; angleSlider angleSliderB; angleSlider angleSliderC; angleSlider angleSliderD;

  float offset, rotateOffset, rotateAngle, sliderX, sliderY, diff, rotateAngleReal;
  float rotateAngleBot = radians(-45) + radians(clickRadius / (8.5));  //8.5 = 1000 / 100 (11.76) ||| 7 = 800 / 100 (7.14) ||| 7 = 800 / 50 (3.57)
  float rotateAngleTop = radians(45) - radians(clickRadius / (8.5));  //(clickRadius / 2) / (assdiameter / clickdiameter)
  String ID;
  boolean clicked = false;

  angleHandle(String tempID) {
    this.ID = tempID; // Assign frame ID
    switch (this.ID) {
    case "A":
      rotateOffset = radians(-90);
      break;
    case "B":
      rotateOffset = radians(0);
      break;
    case "C":
      rotateOffset = radians(90);
      break;
    case "D":
      rotateOffset = radians(180);
      break;
    default:
      break;
    }
    angleSliderA = new angleSlider("A"); angleSliderB = new angleSlider("B"); angleSliderC = new angleSlider("C"); angleSliderD = new angleSlider("D");
  }

  void displaySlider() {
    pushMatrix();
    switch (this.ID) {
    case "A":
      rotate(this.rotateAngle);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      translate(0, -assemblyRadius);
      angleSliderA.display();
      break;
    case "B":
      rotate(this.rotateAngle);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      translate(assemblyRadius, 0);
      angleSliderB.display();
      break;
    case "C":
      rotate(this.rotateAngle);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      translate(0, assemblyRadius);
      angleSliderC.display();
      break;
    case "D":
      rotate(this.rotateAngle);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngle) * assemblyRadius;
      translate(-assemblyRadius, 0);
      angleSliderD.display();
      break;
    default:
      break;
    }
    this.rotateAngle = constrain(rotateAngle, rotateAngleBot, rotateAngleTop);
    popMatrix();
  }

  void displayFrame() {
    this.rotateAngleReal = map(this.rotateAngle, this.rotateAngleBot, this.rotateAngleTop, radians(-45), radians(45));
    pushMatrix();
    switch (this.ID) {
    case "A":
      rotate(this.rotateAngleReal);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      translate(0, assemblyRadius);
      angleSliderA.displayFrame();
      break;
    case "B":
      rotate(this.rotateAngleReal);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      translate(-assemblyRadius, 0);
      angleSliderB.displayFrame();
      break;
    case "C":
      rotate(this.rotateAngleReal);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      translate(0, -assemblyRadius);
      angleSliderC.displayFrame();
      break;
    case "D":
      rotate(this.rotateAngleReal);
      this.sliderX = centerX + cos(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      this.sliderY = centerY + sin(rotation + rotateOffset + this.rotateAngleReal) * assemblyRadius;
      translate(assemblyRadius, 0);
      angleSliderD.displayFrame();
      break;
    default:
      break;
    }
    popMatrix();
  }

  void mousePressed() {
    if (dist(mouseX, mouseY, this.sliderX, this.sliderY) < clickRadius) {
      this.clicked = true;
    }
  }

  void mouseReleased() {
    this.clicked = false;
  }

  void mouseDragged() {
    if (this.clicked) {
      if (gui.fineClicked) {
        switch (this.ID) {
        case "A":
          this.rotateAngle += radians(cos(rotation) * (mouseX - pmouseX) + sin(rotation) * (mouseY - pmouseY)) / 25;
          break;
        case "B":
          this.rotateAngle += radians(cos(rotation) * (mouseY - pmouseY) + sin(rotation) * (pmouseX - mouseX)) / 25;
          break;
        case "C":
          this.rotateAngle -= radians(cos(rotation) * (mouseX - pmouseX) + sin(rotation) * (mouseY - pmouseY)) / 25;
          break;
        case "D":
          this.rotateAngle -= radians(cos(rotation) * (mouseY - pmouseY) + sin(rotation) * (pmouseX - mouseX)) / 25;
          break;
        default:
          break;
        }
      } else {
        switch (this.ID) {
        case "A":
          this.rotateAngle += radians(cos(rotation) * (mouseX - pmouseX) + sin(rotation) * (mouseY - pmouseY)) / 15;
          break;
        case "B":
          this.rotateAngle += radians(cos(rotation) * (mouseY - pmouseY) + sin(rotation) * (pmouseX - mouseX)) / 15;
          break;
        case "C":
          this.rotateAngle -= radians(cos(rotation) * (mouseX - pmouseX) + sin(rotation) * (mouseY - pmouseY)) / 15;
          break;
        case "D":
          this.rotateAngle -= radians(cos(rotation) * (mouseY - pmouseY) + sin(rotation) * (pmouseX - mouseX)) / 15;
          break;
        default:
          break;
        }
      }
      handleOSC.send(this.ID, false, output());
      this.rotateAngle = constrain(this.rotateAngle, rotateAngleBot, rotateAngleTop);
    }
  }
  void doubleClicked() {
    if (dist(mouseX, mouseY, this.sliderX, this.sliderY) < clickRadius) {
      this.rotateAngle = 0;
      handleOSC.send(this.ID, false, output());
    }
  }

  void home() {
    this.rotateAngle = 0;
    handleOSC.send(this.ID, false, output());
  }

  void incomingOSC(float value) {
    if (!clicked) {
      value = map(value, 50, -50, rotateAngleBot, rotateAngleTop);
      this.rotateAngle = value;
    }
  }

  float output() {
    return map(this.rotateAngle, rotateAngleBot, rotateAngleTop, 50, -50);
  }

  float absOutput() {
    return abs(output());
  }
}
