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

  Map toJson() => {
        'pin': pin == null ? "" : pin.toString(),
        'component': component == null ? "" : component.toString(),
        'variableName': variableName == null ? "" : variableName.toString(),
      };

  PinAssignment.fromJson(Map<String, dynamic> json)
      : pin = json['pin'].isEmpty ? null : int.parse(json['pin']),
        component = json['component'].isEmpty ? null : json['component'],
        variableName =
            json['variableName'].isEmpty ? null : json['variableName'];
}
