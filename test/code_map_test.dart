import 'package:test/test.dart';
import 'package:arduino_statemachines/resources/code_map.dart';

void main() {
  group('Code Map', () {
    test('Default Code', () {
      expect(CodeMap({}, {}, {}, {}, {}).getCode("functions"),
          "//Imports:\n\n//Pins:\n\nvoid setup() { \n}\n\nvoid loop() {\n\n}\n\n\n");
    });
    test('No Highlight', () {
      expect(CodeMap({}, {}, {}, {}, {}).returnHighlightString("", "", ""), "");
    });

    // Start
    test('Highlight Start', () {
      expect(
          CodeMap({}, {}, {}, {
            "start": "function_0_motionSensor();",
          }, {
            "function_0_motionSensor": StateMap("function_0_motionSensor",
                "value = digitalRead();", "function_0_motionSensor();")
          }).returnHighlightString("loop", "start", "functions"),
          "function_0_motionSensor();");
    });
    test('Empty Start', () {
      expect(
          CodeMap({}, {}, {}, {}, {
            "function_0_motionSensor": StateMap("function_0_motionSensor",
                "value = digitalRead();", "function_0_motionSensor();")
          }).returnHighlightString("loop", "start", "functions"),
          "");
    });

    // End
    test('Highlight End', () {
      expect(
          CodeMap({}, {}, {
            "end": "bool end = false;"
          }, {
            "start": "function_0_motionSensor();",
            "end": "if(!end){\nfunction_0_motionSensor();\n}",
            "endActivated": "end = true;"
          }, {
            "function_0_motionSensor": StateMap("function_0_motionSensor",
                "value = digitalRead();", "end = true;\nloop();")
          }).returnHighlightString("loop", "endActivated", "functions"),
          "end = true;");
    });
    test('Empty End', () {
      expect(
          CodeMap({}, {}, {}, {}, {})
              .returnHighlightString("loop", "endActivated", "functions"),
          "");
    });

    // Pins
    test('Pin Assignment', () {
      expect(
          CodeMap({}, {
            "pin_0_motionSensor": "int pin_0_motionSensor = 7;"
          }, {
            "pin_0_motionSensor": "pinMode(pin_0_motionSensor, INPUT);"
          }, {}, {
            "function_0_motionSensor": StateMap("function_0_motionSensor",
                "value = digitalRead();", "function_0_motionSensor();")
          }).returnHighlightString("pins", "pin_0_motionSensor", "functions"),
          "int pin_0_motionSensor = 7;");
    });

    // Functions Code
    test('Functions State', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start": "function_0_led();"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "function_1_led();"),
            "function_1_led": StateMap("function_1_led",
                "digitalWrite(pin_0_led, LOW);", "function_0_led();")
          }).returnHighlightString("states", "function_0_led", "functions",
              type: "state"),
          "void function_0_led(){\ndigitalWrite(pin_0_led, HIGH);\nfunction_1_led();\n}\n");
    });
    test('Functions Action', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start": "function_0_led();"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "function_1_led();"),
            "function_1_led": StateMap("function_1_led",
                "digitalWrite(pin_0_led, LOW);", "function_0_led();")
          }).returnHighlightString("states", "function_0_led", "functions",
              type: "action"),
          "digitalWrite(pin_0_led, HIGH);");
    });
    test('Functions Transition', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start": "function_0_led();"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "function_1_led();"),
            "function_1_led": StateMap("function_1_led",
                "digitalWrite(pin_0_led, LOW);", "function_0_led();")
          }).returnHighlightString("states", "function_0_led", "functions",
              type: "transition"),
          "function_1_led();");
    });

    // Abridged Code
    test('Abridged State', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start":
                "while(true){\ndigitalWrite(pin_0_led, HIGH);\ndigitalWrite(pin_0_led, LOW);\n}"
          }, {
            "function_0_led": StateMap(
                "function_0_led",
                "digitalWrite(pin_0_led, HIGH);",
                "digitalWrite(pin_0_led, LOW);\n}\n"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "}\n")
          }).returnHighlightString("states", "function_0_led", "abridged",
              type: "state"),
          "digitalWrite(pin_0_led, HIGH);\ndigitalWrite(pin_0_led, LOW);\n}\n");
    });
    test('Abridged Action', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start":
                "while(true){\ndigitalWrite(pin_0_led, HIGH);\ndigitalWrite(pin_0_led, LOW);\n}"
          }, {
            "function_0_led": StateMap(
                "function_0_led",
                "digitalWrite(pin_0_led, HIGH);",
                "digitalWrite(pin_0_led, LOW);\n}\n"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "}\n")
          }).returnHighlightString("states", "function_0_led", "abridged",
              type: "action"),
          "digitalWrite(pin_0_led, HIGH);");
    });
    test('Abridged Transition', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);"
          }, {
            "start":
                "while(true){\ndigitalWrite(pin_0_led, HIGH);\ndigitalWrite(pin_0_led, LOW);\n}"
          }, {
            "function_0_led": StateMap(
                "function_0_led",
                "digitalWrite(pin_0_led, HIGH);",
                "digitalWrite(pin_0_led, LOW);\n}\n"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "}\n")
          }).returnHighlightString("states", "function_0_led", "abridged",
              type: "transition"),
          "digitalWrite(pin_0_led, LOW);\n}\n");
    });

    // Switch Code
    test('Switch State', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);",
            "switch": "int state = 0;\n"
          }, {
            "start":
                "switch(state){\ncase 0:\nfunction_0_led();\nbreak;\ncase 1:\nfunction_1_led();\nbreak;\ndefault:\n break;\n}"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "state = 1;"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "state = 0;")
          }).returnHighlightString("states", "function_0_led", "switch",
              type: "state"),
          "void function_0_led(){\ndigitalWrite(pin_0_led, HIGH);\nstate = 1;\n}\n");
    });
    test('Switch Action', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);",
            "switch": "int state = 0;\n"
          }, {
            "start":
                "switch(state){\ncase 0:\nfunction_0_led();\nbreak;\ncase 1:\nfunction_1_led();\nbreak;\ndefault:\n break;\n}"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "state = 1;"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "state = 0;")
          }).returnHighlightString("states", "function_0_led", "switch",
              type: "action"),
          "digitalWrite(pin_0_led, HIGH);");
    });
    test('Switch Transition', () {
      expect(
          CodeMap({}, {
            "pin_0_led": "int pin_0_led = 7;"
          }, {
            "pin_0_led": "pinMode(pin_0_led, OUTPUT);",
            "switch": "int state = 0;\n"
          }, {
            "start":
                "switch(state){\ncase 0:\nfunction_0_led();\nbreak;\ncase 1:\nfunction_1_led();\nbreak;\ndefault:\n break;\n}"
          }, {
            "function_0_led": StateMap("function_0_led",
                "digitalWrite(pin_0_led, HIGH);", "state = 1;"),
            "function_1_led": StateMap(
                "function_1_led", "digitalWrite(pin_0_led, LOW);", "state = 0;")
          }).returnHighlightString("states", "function_0_led", "switch",
              type: "transition"),
          "state = 1;");
    });
  });
}
