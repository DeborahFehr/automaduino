import 'package:flutter/material.dart';

/// State Settings describes the data structure of the draggable state
class StateSettings {
  String name;
  String selectedOption;
  int? pin;
  final bool newBlock;
  final bool newConnection;
  final bool additionalConnection;
  final bool startConnection;
  final Key? key;
  String variableName;

  StateSettings(
      this.name,
      this.selectedOption,
      this.pin,
      this.newBlock,
      this.newConnection,
      this.additionalConnection,
      this.startConnection,
      this.key,
      this.variableName);

  StateSettings added() {
    return StateSettings(this.name, this.selectedOption, this.pin, false, false,
        false, false, this.key, this.variableName);
  }
}

/// State Data contains the general data of the state
class StateData {
  final String type;
  final String component;
  final String imagePath;
  final String link;
  final String option;

  StateData(this.type, this.component, this.imagePath, this.link, this.option);
}

/// startData contains information regarding the startPoint
class StartData {
  bool connected;
  final Key key;
  Offset position;

  StartData(this.connected, this.key, this.position);
}

/// endData contains information regarding the endPoint
class EndData {
  bool available;
  final Key key;
  Offset position;

  EndData(this.available, this.key, this.position);
}
