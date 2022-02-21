import 'package:arduino_statemachines/resources/state.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:arduino_statemachines/resources/code_transpiler.dart';

void main() {
  group('Code Transpiler', () {
    test('Default Code', () {
      expect(
          CodeTranspiler([], [], [], StartData(true, UniqueKey(), Offset(0, 0)),
                  EndData(true, UniqueKey(), Offset(0, 0)), "functions")
              .getMap(),
          null);
    });
  });
}
