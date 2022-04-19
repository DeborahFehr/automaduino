import 'package:flutter/material.dart';

String baseURL = "https://automaduino.com";

double canvasHeight = 2000;
double canvasWidth = 3000;

double blockSize = 100;

Offset keepInCanvas(Offset position) {
  Offset result = position;

  if (position.dx < 0) result = result.translate(-position.dx, 0);
  if (position.dx > canvasWidth)
    result = result.translate(-(position.dx + blockSize - canvasWidth), 0);
  if (position.dy < 0) result = result.translate(0, -position.dy);
  if (position.dy > canvasHeight)
    result = result.translate(0, -(position.dy + blockSize - canvasHeight));

  return result;
}

Color sensorColor = Colors.redAccent;
Color userInputColor = Colors.blueAccent;
Color outputColor = Colors.greenAccent;

Color getBlockColorByType(String type) {
  return type == "sensor"
      ? sensorColor
      : type == "userInput"
          ? userInputColor
          : outputColor;
}

Offset startPosition = Offset(40, 40);
Offset endPosition = Offset(240, 40);

String getDefaultCode() {
  return '''void setup() {
      // put your setup code here, to run once:

    }

    void loop() {
      // put your main code here, to run repeatedly:

    }''';
}

TextStyle codeEditorStyle = TextStyle(
  height: 1.2,
  fontSize: 14,
  fontFamily: 'Monaco',
);

// Syntax Highlighter
// https://github.com/arduino/Arduino/blob/master/build/shared/lib/theme/theme.txt
// https://github.com/arduino/Arduino/blob/master/build/shared/lib/keywords.txt
// for functions and methods
Color arduinoOrange = Color.fromRGBO(211, 84, 0, 1);
// for structures
Color arduinoGreen = Color.fromRGBO(114, 142, 0, 1);
// for variables and reserved words 2
Color arduinoBlue = Color.fromRGBO(0, 151, 156, 1);
// for other reserved words
Color arduinoReserved = Color.fromRGBO(94, 109, 3, 1);
Color arduinoSelection = Color.fromRGBO(255, 204, 0, 1);

Map<String, TextStyle> syntaxHighlighter = {
  'loop': TextStyle(color: arduinoGreen),
  'setup': TextStyle(color: arduinoGreen),
  'HIGH': TextStyle(color: arduinoGreen),
  'LOW': TextStyle(color: arduinoGreen),
  'INPUT': TextStyle(color: arduinoGreen),
  'OUTPUT': TextStyle(color: arduinoGreen),
  'bool': TextStyle(color: arduinoGreen),
  'boolean': TextStyle(color: arduinoGreen),
  'byte': TextStyle(color: arduinoGreen),
  'char': TextStyle(color: arduinoGreen),
  'false': TextStyle(color: arduinoGreen),
  'true': TextStyle(color: arduinoGreen),
  'float': TextStyle(color: arduinoGreen),
  'double': TextStyle(color: arduinoGreen),
  'int': TextStyle(color: arduinoGreen),
  'null': TextStyle(color: arduinoGreen),
  'NULL': TextStyle(color: arduinoGreen),
  'analogReference': TextStyle(color: arduinoOrange),
  'analogRead': TextStyle(color: arduinoOrange),
  'analogReadResolution': TextStyle(color: arduinoOrange),
  'analogWrite': TextStyle(color: arduinoOrange),
  'analogWriteResolution': TextStyle(color: arduinoOrange),
  'attachInterrupt': TextStyle(color: arduinoOrange),
  'detachInterrupt': TextStyle(color: arduinoOrange),
  'digitalPinToInterrupt': TextStyle(color: arduinoOrange),
  'delay': TextStyle(color: arduinoOrange),
  'delayMicroseconds': TextStyle(color: arduinoOrange),
  'digitalWrite': TextStyle(color: arduinoOrange),
  'digitalRead': TextStyle(color: arduinoOrange),
  'interrupts': TextStyle(color: arduinoOrange),
  'millis': TextStyle(color: arduinoOrange),
  'micros': TextStyle(color: arduinoOrange),
  'noInterrupts': TextStyle(color: arduinoOrange),
  'noTone': TextStyle(color: arduinoOrange),
  'pinMode': TextStyle(color: arduinoOrange),
  'pulseIn': TextStyle(color: arduinoOrange),
  'pulseInLong': TextStyle(color: arduinoOrange),
  'shiftIn': TextStyle(color: arduinoOrange),
  'shiftOut': TextStyle(color: arduinoOrange),
  'tone': TextStyle(color: arduinoOrange),
  'yield': TextStyle(color: arduinoOrange),
  'Serial': TextStyle(color: arduinoOrange),
  'begin': TextStyle(color: arduinoOrange),
  'end': TextStyle(color: arduinoOrange),
  'read': TextStyle(color: arduinoOrange),
  'print': TextStyle(color: arduinoOrange),
  'setTimeout': TextStyle(color: arduinoOrange),
  'length': TextStyle(color: arduinoOrange),
  'break': TextStyle(color: arduinoGreen),
  'case': TextStyle(color: arduinoGreen),
  'continue': TextStyle(color: arduinoGreen),
  'do': TextStyle(color: arduinoGreen),
  'default': TextStyle(color: arduinoGreen),
  'else': TextStyle(color: arduinoGreen),
  'for': TextStyle(color: arduinoGreen),
  'if': TextStyle(color: arduinoGreen),
  'return': TextStyle(color: arduinoGreen),
  'goto': TextStyle(color: arduinoGreen),
  'switch': TextStyle(color: arduinoGreen),
  'export': TextStyle(color: arduinoGreen),
  'void': TextStyle(color: arduinoBlue),
};
