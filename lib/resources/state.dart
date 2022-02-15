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

  StateSettings added(String name) {
    return StateSettings(name, this.selectedOption, this.pin, false, false,
        false, false, this.key, this.variableName);
  }

  Map toJson() => {
        'name': name,
        'selectedOption': selectedOption,
        'pin': pin == null ? "" : pin.toString(),
        'newBlock': newBlock,
        'newConnection': newConnection,
        'additionalConnection': additionalConnection,
        'startConnection': startConnection,
        'key': key == null ? "" : key.toString(),
        'variableName': variableName,
      };

  StateSettings.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        selectedOption = json['selectedOption'],
        pin = json['pin'].isEmpty ? null : int.parse(json['pin']),
        newBlock = json['newBlock'],
        newConnection = json['newConnection'],
        additionalConnection = json['additionalConnection'],
        startConnection = json['startConnection'],
        key = json['key'].isEmpty ? null : Key(json['key']),
        variableName = json['variableName'];
}

/// State Data contains the general data of the state
class StateData {
  final String type;
  final String component;
  final String imagePath;
  final String link;
  final String option;

  StateData(this.type, this.component, this.imagePath, this.link, this.option);

  Map toJson() => {
        'type': type,
        'component': component,
        'imagePath': imagePath,
        'link': link,
        'option': option,
      };

  StateData.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        component = json['component'],
        imagePath = json['imagePath'],
        link = json['link'],
        option = json['option'];
}

/// startData contains information regarding the startPoint
class StartData {
  bool connected;
  final Key key;
  Offset position;

  StartData(this.connected, this.key, this.position);

  Map toJson() => {
        'connected': connected,
        'position_dx': position.dx,
        'position_dy': position.dy,
      };
}

/// endData contains information regarding the endPoint
class EndData {
  bool available;
  final Key key;
  Offset position;

  EndData(this.available, this.key, this.position);

  Map toJson() => {
        'available': available,
        'position_dx': position.dx,
        'position_dy': position.dy,
      };
}
