import 'package:flutter/material.dart';

/// Connection describes the relationship between a block and a condition
class Transition {
  final Key start;
  final Condition condition;
  List<Key> end;
  Offset position;

  Transition(this.start, this.condition, this.end, this.position);

  @override
  String toString() {
    return "start: " +
        start.toString() +
        ", connection: " +
        condition.toString() +
        ", end[s]: " +
        end.toString();
  }
}

List<String> conditionTypes = ["then", "if", "ifelse", "cond", "time"];

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
}
