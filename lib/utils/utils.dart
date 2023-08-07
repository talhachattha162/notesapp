
import 'package:flutter/material.dart';

int getMaxLines(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  // Calculate the maximum lines based on a percentage of the screen height
  const percentageOfScreenHeight = 0.8; // 80% of the screen height
  final maxHeight = screenHeight * percentageOfScreenHeight;
  final maxLines = (maxHeight / 24).floor(); // Assuming an average line height of 24 pixels
  return maxLines;
}