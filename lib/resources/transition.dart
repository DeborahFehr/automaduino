import 'package:flutter/material.dart';

/// Connection describes the relationship between a block and a condition
class Transition {
  final Key start;
  final Condition condition;
  List<Key> end;
  Offset position;
  final bool startPoint;
  final bool endPoint;

  Transition(this.start, this.condition, this.end, this.position,
      this.startPoint, this.endPoint);

  @override
  String toString() {
    return "start: " +
        start.toString() +
        ", connection: " +
        condition.toString() +
        ", end[s]: " +
        end.toString();
  }

  Map toJson() => {
        'start': start.toString(),
        'condition': condition.toJson(),
        'end': end.map((e) => e.toString()).toList(),
        'position_dx': position.dx,
        'position_dy': position.dy,
        'startPoint': startPoint,
        'endPoint': endPoint,
      };

  Transition.fromJson(Map<String, dynamic> json)
      : start = Key(json['start']),
        condition = Condition.fromJson(json['condition']),
        end = (json['end'] as List).map((e) => Key(e)).toList(),
        position = Offset(
            json['position_dx'] as double, json['position_dy'] as double),
        startPoint = json['startPoint'],
        endPoint = json['endPoint'];
}

List<String> conditionTypes = ["then", "if", "ifelse", "cond", "after"];

List<String> restrictedConditionTypes = ["then", "after"];

/// Condition describes the connection
class Condition {
  final Key key;
  String type;
  List<String> values;

  Condition(this.key, this.type, this.values);

  @override
  String toString() {
    return "type: " + type.toString() + ", with values: " + values.toString();
  }

  Map toJson() => {
        'key': key.toString(),
        'type': type,
        'values': values,
      };

  Condition.fromJson(Map<String, dynamic> json)
      : key = Key(json['key']),
        type = json['type'],
        values = (json['values'] as List).map((e) => e.toString()).toList();
}
