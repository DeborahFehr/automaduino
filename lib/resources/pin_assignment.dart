/// Pin Assignment contains the info of the component and the Arduino pin

class PinAssignment {
  int pin;
  String component;
  String variableName;

  PinAssignment(this.pin, this.component, this.variableName);
}
