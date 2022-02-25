import 'package:arduino_statemachines/resources/canvas_layout.dart';
import 'package:arduino_statemachines/resources/pin_assignment.dart';
import 'package:arduino_statemachines/resources/state.dart';
import 'package:arduino_statemachines/resources/transition.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:arduino_statemachines/resources/code_transpiler.dart';
import 'package:arduino_statemachines/resources/code_map.dart';

void main() {
  group('Code Transpiler', () {
    test('Default Code', () {
      expect(
          CodeTranspiler([], [], [], StartData(true, UniqueKey(), Offset(0, 0)),
                  EndData(true, UniqueKey(), Offset(0, 0)), "functions")
              .getMap(),
          null);
    });

    // Functions
    test('Functions Map', () {
      expect(
          CodeTranspiler([
            PositionedState(
                Key("#9fcf0"),
                StateSettings("LED", "on", 7, "function_0_led"),
                StateData("output", "led", "graphics/state_icons/led_on.png",
                    "/docs/components/output/led/", "on"),
                Offset(46, 150),
                true),
            PositionedState(
                Key("#77f05"),
                StateSettings("LED", "off", 7, "function_1_led"),
                StateData("output", "led", "graphics/state_icons/led_on.png",
                    "/docs/components/output/led/", "off"),
                Offset(340, 150),
                true)
          ], [
            Transition(Key("#f14c0"), Condition(Key("#1a61f"), "then", [""]),
                [Key("#9fcf0")], Offset(100, 100), true, false),
            Transition(Key("#9fcf0"), Condition(Key("#0590b"), "then", [""]),
                [Key("#77f05")], Offset(155, 130), false, false),
            Transition(Key("#77f05"), Condition(Key("#0590b"), "then", [""]),
                [Key("#9fcf0")], Offset(155, 290), false, false)
          ], [
            PinAssignment(7, "led", "pin_0_led")
          ], StartData(true, Key("#f14c0"), Offset(40, 40)),
                  EndData(false, UniqueKey(), Offset(240, 40)), "functions")
              .getMap(),
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start": "function_0_led();\n"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "function_1_led();"),
            "function_1_led": StateMap("function_1_led",
                "digitalWrite(pin_0_led, LOW);", "function_0_led();")
          }));
    });

    // Abridged
    test('Abridged Map', () {
      expect(
          CodeTranspiler([
            PositionedState(
                Key("#9fcf0"),
                StateSettings("LED", "on", 7, "function_0_led"),
                StateData("output", "led", "graphics/state_icons/led_on.png",
                    "/docs/components/output/led/", "on"),
                Offset(46, 150),
                true),
            PositionedState(
                Key("#77f05"),
                StateSettings("LED", "off", 7, "function_1_led"),
                StateData("output", "led", "graphics/state_icons/led_on.png",
                    "/docs/components/output/led/", "off"),
                Offset(340, 150),
                true)
          ], [
            Transition(Key("#f14c0"), Condition(Key("#1a61f"), "then", [""]),
                [Key("#9fcf0")], Offset(100, 100), true, false),
            Transition(Key("#9fcf0"), Condition(Key("#0590b"), "then", [""]),
                [Key("#77f05")], Offset(155, 130), false, false),
            Transition(Key("#77f05"), Condition(Key("#0590b"), "then", [""]),
                [Key("#9fcf0")], Offset(155, 290), false, false)
          ], [
            PinAssignment(7, "led", "pin_0_led")
          ], StartData(true, Key("#f14c0"), Offset(40, 40)),
                  EndData(false, UniqueKey(), Offset(240, 40)), "abridged")
              .getMap(),
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start":
                "while(true){\ndigitalWrite(pin_0_led, HIGH);\ndigitalWrite(pin_0_led, LOW);\n}\n"
          }, {
            "function_0_led": StateMap(
                "function_0_led",
                "digitalWrite(pin_0_led, HIGH);",
                "digitalWrite(pin_0_led, LOW);\n}\n"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "}\n")
          }));
    });

    // Switch
    test('Switch Map', () {
      expect(
          CodeTranspiler([
            PositionedState(
                Key("#9fcf0"),
                StateSettings("LED", "on", 7, "function_0_led"),
                StateData("output", "led", "graphics/state_icons/led_on.png",
                    "/docs/components/output/led/", "on"),
                Offset(46, 150),
                true),
            PositionedState(
                Key("#77f05"),
                StateSettings("LED", "off", 7, "function_1_led"),
                StateData("output", "led", "graphics/state_icons/led_on.png",
                    "/docs/components/output/led/", "off"),
                Offset(340, 150),
                true)
          ], [
            Transition(Key("#f14c0"), Condition(Key("#1a61f"), "then", [""]),
                [Key("#9fcf0")], Offset(100, 100), true, false),
            Transition(Key("#9fcf0"), Condition(Key("#0590b"), "then", [""]),
                [Key("#77f05")], Offset(155, 130), false, false),
            Transition(Key("#77f05"), Condition(Key("#0590b"), "then", [""]),
                [Key("#9fcf0")], Offset(155, 290), false, false)
          ], [
            PinAssignment(7, "led", "pin_0_led")
          ], StartData(true, Key("#f14c0"), Offset(40, 40)),
                  EndData(false, UniqueKey(), Offset(240, 40)), "switch")
              .getMap(),
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);",
            "switch": "int state = 0;\n"
          }, {
            "start":
                "switch(state){\ncase 0:\nfunction_0_led();\nbreak;\ncase 1:\nfunction_1_led();\nbreak;\ndefault:\n break;\n}\n"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "state = 1;"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "state = 0;")
          }));
    });
  });
}
