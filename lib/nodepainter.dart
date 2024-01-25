import 'package:flutter/material.dart';
import 'dart:math';

import 'common.dart';

class NodePainter {
  static const strokeWidth = 4.0;
  static const textStyle = TextStyle(color: Colors.white, fontSize: 18);

  static Radius getNodeRadius(NodeType nodeType) {
    return nodeType == NodeType.entryExit ? const Radius.circular(2) : const Radius.circular(24);
  }

  static final paintStyle = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = Colors.lime;

  static void drawNode(Canvas canvas, Node node, {bool snapToGrid = false}) {
    var (x, y) = (node.position.x as double, node.position.y as double);

    if (snapToGrid) {
      x = Utils.snapToGrid(x, gridSize);
      y = Utils.snapToGrid(y, gridSize);
    }

    final (boxWidth, boxHeight) = calculateNodeBoxSize(node.id);

    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, boxWidth, boxHeight), getNodeRadius(node.type)), paintStyle);

    drawText(canvas, x, y, node.id, node);
  }

  static TextPainter getNodeTextPainter(String nodeId) {
    TextSpan span = TextSpan(style: textStyle, text: nodeId);
    if (nodeId.length > 15) {
      span = TextSpan(style: textStyle, text: nodeId.substring(0, 12) + '...');
    }

    final textPainter = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter;
  }

  static (double width, double height) calculateNodeBoxSize(String nodeId, {bool snapToGrid = false}) {
    final boxWidth = min(getNodeTextPainter(nodeId).width, 100) + 50 as double;
    final boxHeight = 75 as double;
    return (boxWidth, boxHeight);
  }

  static void drawText(Canvas canvas, double x, double y, String text, Node node) {
    final (boxWidth, boxHeight) = calculateNodeBoxSize(node.id);

    final textPainter = getNodeTextPainter(node.id);

    textPainter.paint(
        canvas, Offset(x + boxWidth / 2 - textPainter.width * 0.5, y + boxHeight / 2 - textPainter.height * 0.5));
  }
}