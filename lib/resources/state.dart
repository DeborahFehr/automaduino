import 'package:flutter/material.dart';

/// State Settings describes the data structure of the draggable state
class StateSettings {
  String name;
  String selectedOption;
  int? pin;
  String variableName;

  StateSettings(
      this.name,
      this.selectedOption,
      this.pin,
      this.variableName);

  Map toJson() => {
        'name': name,
        'selectedOption': selectedOption,
        'pin': pin == null ? "" : pin.toString(),
        'variableName': variableName,
      };

  StateSettings.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        selectedOption = json['selectedOption'],
        pin = json['pin'].isEmpty ? null : int.parse(json['pin']),
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
