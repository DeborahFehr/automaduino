/// Pin Assignment contains the info of the component and the Arduino pin

class PinAssignment {
  int? pin;
  String? component;
  String? variableName;

  PinAssignment(this.pin, this.component, this.variableName);

  @override
  String toString() {
    String pinVal = pin == null ? "" : pin.toString();
    String compVal = component == null ? "" : component.toString();
    String varVal = variableName == null ? "" : variableName.toString();

    return "pin: " +
        pinVal +
        ", component: " +
        compVal +
        ", variableName: " +
        varVal;
  }
}
