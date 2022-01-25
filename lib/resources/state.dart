import 'package:flutter/material.dart';

/// State Settings describes the data structure of the draggable state
class StateSettings {
  String name;
  String selectedOption;
  final bool newBlock;
  final bool newConnection;
  final Key? key;

  StateSettings(this.name, this.selectedOption, this.newBlock,
      this.newConnection, this.key);

  StateSettings added() {
    return StateSettings(
        this.name, this.selectedOption, false, false, this.key);
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
