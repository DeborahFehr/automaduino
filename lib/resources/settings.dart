import 'package:flutter/material.dart';

String baseURL = "https://automaduino.com";

double canvasHeight = 1000;
double canvasWidth = 1000;

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

// Color setter

// Start and Endpoint initial Position
