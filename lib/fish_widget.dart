import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hungry_fish/graphic_config.dart';

class FishWidget extends StatelessWidget {
  const FishWidget(
      {Key? key,
      required this.config,
      required this.multiplier,
      required this.jumping})
      : super(key: key);

  final GraphicConfig config;
  final double multiplier;
  final bool jumping;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (config.drawPlaceholderOnly) {
      widget = Container(color: Colors.deepOrange);
    } else {
      widget = CustomPaint(painter: _FishPainter(config: config));
    }
    if (jumping) {
      return widget;
    }
    return Transform.rotate(
      angle: _degreesToRadian(90 * (1 - multiplier)),
      child: widget,
    );
  }
}

double _degreesToRadian(double degrees) {
  return degrees * math.pi / 180;
}

class _FishPainter extends CustomPainter {
  _FishPainter({required this.config});

  final GraphicConfig config;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint debugStrongStrokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;
    final Paint debugStrongFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey;
    final Paint debugLightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[300]!;

    final Paint bodyFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.deepOrange;
    final Paint eyeFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    final Paint pupilFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 2;

    const int horizontalQuadrantsCount = 10;
    const int verticalQuadrantsCount = 20;
    final double quadrantWidth = size.width / horizontalQuadrantsCount;
    final double quadrantHeight = size.height / verticalQuadrantsCount;

    final Offset mouthLeftP1 = Offset(2 * quadrantWidth, quadrantHeight);
    final Offset mouthLeftP2 = Offset(2 * quadrantWidth, 3 * quadrantHeight);
    const Offset mouthLeftControl1 = Offset.zero;
    final Offset mouthLeftControl2 = Offset(0, 2 * quadrantHeight);
    final Offset mouthLeftDetailP1 =
        Offset(4 * quadrantWidth, 3 * quadrantHeight);
    final Offset mouthLeftDetailP2 =
        Offset(3 * quadrantWidth, 3 * quadrantHeight + quadrantHeight / 2);
    final Offset mouthRightDetailP1 =
        Offset(6 * quadrantWidth, 3 * quadrantHeight);
    final Offset mouthRightDetailP2 =
        Offset(7 * quadrantWidth, 3 * quadrantHeight + quadrantHeight / 2);

    final Offset mouthRightP1 = Offset(8 * quadrantWidth, quadrantHeight);
    final Offset mouthRightP2 = Offset(8 * quadrantWidth, 3 * quadrantHeight);
    final Offset mouthRightControl1 = Offset(size.width, 0);
    final Offset mouthRightControl2 = Offset(size.width, 2 * quadrantHeight);

    final Offset monthCenter = Offset(5 * quadrantWidth, 2 * quadrantHeight);

    final Offset finalBody = Offset(5 * quadrantWidth, 17 * quadrantHeight);
    final Offset finalBodyControl1 = Offset(0, 12 * quadrantHeight);
    final Offset finalBodyControl2 = Offset(size.width, 12 * quadrantHeight);

    final Offset eyeCenter = Offset(2 * quadrantWidth, 6 * quadrantHeight);

    final Offset tailLeftP1 = Offset(4 * quadrantWidth, 16 * quadrantHeight);
    final Offset tailLeftP2 = Offset(2 * quadrantWidth, size.height);
    final Offset tailLeftControl =
        Offset(2 * quadrantWidth, 18 * quadrantHeight);

    final Offset tailRightP1 = Offset(6 * quadrantWidth, 16 * quadrantHeight);
    final Offset tailRightP2 = Offset(8 * quadrantWidth, size.height);
    final Offset tailRightControl =
        Offset(8 * quadrantWidth, 18 * quadrantHeight);

    final Offset topFinP1 = Offset(2 * quadrantWidth, 9 * quadrantHeight);
    final Offset topFinP2 = Offset(0, 13 * quadrantHeight);
    final Offset topFinP3 = Offset(3 * quadrantWidth, 12 * quadrantHeight);
    final Offset topFinControl1 = Offset(0, 10 * quadrantHeight);
    final Offset topFinControl2 = Offset(quadrantWidth, 11 * quadrantHeight);

    final Offset centerFinP1 = Offset(4 * quadrantWidth, 8 * quadrantHeight);
    final Offset centerFinP2 = Offset(6 * quadrantWidth, 8 * quadrantHeight);
    final Offset centerFinControl1 =
        Offset(2 * quadrantWidth, 13 * quadrantHeight);
    final Offset centerFinControl2 =
        Offset(8 * quadrantWidth, 11 * quadrantHeight);

    final Offset bottomFin1P1 = Offset(8 * quadrantWidth, 5 * quadrantHeight);
    final Offset bottomFin1Control1 = Offset(size.width, 5 * quadrantHeight);
    final Offset bottomFin1Control2 =
        Offset(9 * quadrantWidth, 7 * quadrantHeight);
    final Offset bottomFin1P2 = Offset(size.width, 9 * quadrantHeight);
    final Offset bottomFin1Control3 =
        Offset(8 * quadrantWidth, 9 * quadrantHeight);
    final Offset bottomFin1P3 = Offset(8 * quadrantWidth, 7 * quadrantHeight);

    final double finTranslation = 3 * quadrantHeight;
    final Offset bottomFin2P1 = bottomFin1P1.translate(0, finTranslation);
    final Offset bottomFin2Control1 =
        bottomFin1Control1.translate(0, finTranslation);
    final Offset bottomFin2Control2 =
        bottomFin1Control2.translate(0, finTranslation);
    final Offset bottomFin2P2 = bottomFin1P2.translate(0, finTranslation);
    final Offset bottomFin2Control3 =
        bottomFin1Control3.translate(0, finTranslation);
    final Offset bottomFin2P3 = bottomFin1P3.translate(0, finTranslation);

    Path topFinPath = Path();
    topFinPath.moveTo(topFinP1.dx, topFinP1.dy);
    topFinPath.quadraticBezierTo(
        topFinControl1.dx, topFinControl1.dy, topFinP2.dx, topFinP2.dy);
    topFinPath.quadraticBezierTo(
        topFinControl2.dx, topFinControl2.dy, topFinP3.dx, topFinP3.dy);
    canvas.drawPath(topFinPath, bodyFillPaint);
    canvas.drawPath(topFinPath, strokePaint);

    Path bottomFin1Path = Path();
    bottomFin1Path.moveTo(bottomFin1P1.dx, bottomFin1P1.dy);
    bottomFin1Path.cubicTo(
        bottomFin1Control1.dx,
        bottomFin1Control1.dy,
        bottomFin1Control2.dx,
        bottomFin1Control2.dy,
        bottomFin1P2.dx,
        bottomFin1P2.dy);
    bottomFin1Path.quadraticBezierTo(bottomFin1Control3.dx,
        bottomFin1Control3.dy, bottomFin1P3.dx, bottomFin1P3.dy);
    canvas.drawPath(bottomFin1Path, bodyFillPaint);
    canvas.drawPath(bottomFin1Path, strokePaint);

    Path tailPath = Path();
    tailPath.moveTo(tailLeftP1.dx, tailLeftP1.dy);
    tailPath.quadraticBezierTo(
        tailLeftControl.dx, tailLeftControl.dy, tailLeftP2.dx, tailLeftP2.dy);
    tailPath.quadraticBezierTo(
        finalBody.dx, finalBody.dy, tailRightP2.dx, tailRightP2.dy);
    tailPath.quadraticBezierTo(tailRightControl.dx, tailRightControl.dy,
        tailRightP1.dx, tailRightP1.dy);
    canvas.drawPath(tailPath, bodyFillPaint);
    canvas.drawPath(tailPath, strokePaint);

    Path bodyPath = Path();
    bodyPath.moveTo(mouthLeftP2.dx, mouthLeftP2.dy);
    bodyPath.cubicTo(
        mouthLeftControl2.dx,
        mouthLeftControl2.dy,
        mouthLeftControl1.dx,
        mouthLeftControl1.dy,
        mouthLeftP1.dx,
        mouthLeftP1.dy);
    bodyPath.quadraticBezierTo(
        monthCenter.dx, monthCenter.dy, mouthRightP1.dx, mouthRightP1.dy);
    bodyPath.cubicTo(
        mouthRightControl1.dx,
        mouthRightControl1.dy,
        mouthRightControl2.dx,
        mouthRightControl2.dy,
        mouthRightP2.dx,
        mouthRightP2.dy);
    bodyPath.quadraticBezierTo(
        finalBodyControl2.dx, finalBodyControl2.dy, finalBody.dx, finalBody.dy);
    bodyPath.quadraticBezierTo(finalBodyControl1.dx, finalBodyControl1.dy,
        mouthLeftP2.dx, mouthLeftP2.dy);
    canvas.drawPath(bodyPath, bodyFillPaint);
    canvas.drawPath(bodyPath, strokePaint);

    Path bottomFin2Path = Path();
    bottomFin2Path.moveTo(bottomFin2P1.dx, bottomFin2P1.dy);
    bottomFin2Path.cubicTo(
        bottomFin2Control1.dx,
        bottomFin2Control1.dy,
        bottomFin2Control2.dx,
        bottomFin2Control2.dy,
        bottomFin2P2.dx,
        bottomFin2P2.dy);
    bottomFin2Path.quadraticBezierTo(bottomFin2Control3.dx,
        bottomFin2Control3.dy, bottomFin2P3.dx, bottomFin2P3.dy);
    canvas.drawPath(bottomFin2Path, bodyFillPaint);
    canvas.drawPath(bottomFin2Path, strokePaint);

    Path monthDetails = Path();
    monthDetails.moveTo(mouthLeftP2.dx, mouthLeftP2.dy);
    monthDetails.quadraticBezierTo(mouthLeftDetailP2.dx, mouthLeftDetailP2.dy,
        mouthLeftDetailP1.dx, mouthLeftDetailP1.dy);
    monthDetails.moveTo(mouthRightP2.dx, mouthRightP2.dy);
    monthDetails.quadraticBezierTo(mouthRightDetailP2.dx, mouthRightDetailP2.dy,
        mouthRightDetailP1.dx, mouthRightDetailP1.dy);
    canvas.drawPath(monthDetails, strokePaint);

    Rect eyeRect =
        Rect.fromCircle(center: eyeCenter, radius: 2 * quadrantWidth);
    canvas.drawOval(eyeRect, bodyFillPaint);
    canvas.drawArc(eyeRect, _degreesToRadian(45), _degreesToRadian(270), false,
        strokePaint);
    eyeRect = Rect.fromCircle(
        center: eyeCenter, radius: quadrantWidth + quadrantWidth / 2);
    canvas.drawOval(eyeRect, eyeFillPaint);
    canvas.drawOval(eyeRect, strokePaint);
    eyeRect = Rect.fromCircle(center: eyeCenter, radius: quadrantWidth / 2);
    canvas.drawOval(eyeRect, pupilFillPaint);

    Path centerFinPath = Path();
    centerFinPath.moveTo(centerFinP1.dx, centerFinP1.dy);
    centerFinPath.cubicTo(
        centerFinControl1.dx,
        centerFinControl1.dy,
        centerFinControl2.dx,
        centerFinControl2.dy,
        centerFinP2.dx,
        centerFinP2.dy);
    canvas.drawPath(centerFinPath, strokePaint);

    if (config.debugEnabled) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), debugStrongStrokePaint);

      canvas.drawCircle(mouthLeftP1, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthLeftP2, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthLeftControl1, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthLeftControl2, 3, debugStrongFillPaint);

      canvas.drawCircle(monthCenter, 3, debugStrongFillPaint);

      canvas.drawCircle(mouthRightP1, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthRightP2, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthRightControl1, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthRightControl2, 3, debugStrongFillPaint);

      canvas.drawCircle(finalBody, 3, debugStrongFillPaint);
      canvas.drawCircle(finalBodyControl1, 3, debugStrongFillPaint);
      canvas.drawCircle(finalBodyControl2, 3, debugStrongFillPaint);

      canvas.drawCircle(mouthLeftDetailP1, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthLeftDetailP2, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthRightDetailP1, 3, debugStrongFillPaint);
      canvas.drawCircle(mouthRightDetailP2, 3, debugStrongFillPaint);

      canvas.drawCircle(eyeCenter, 3, debugStrongFillPaint);

      canvas.drawCircle(tailLeftP1, 3, debugStrongFillPaint);
      canvas.drawCircle(tailLeftP2, 3, debugStrongFillPaint);
      canvas.drawCircle(tailLeftControl, 3, debugStrongFillPaint);

      canvas.drawCircle(tailRightP1, 3, debugStrongFillPaint);
      canvas.drawCircle(tailRightP2, 3, debugStrongFillPaint);
      canvas.drawCircle(tailRightControl, 3, debugStrongFillPaint);

      canvas.drawCircle(topFinP1, 3, debugStrongFillPaint);
      canvas.drawCircle(topFinP2, 3, debugStrongFillPaint);
      canvas.drawCircle(topFinP3, 3, debugStrongFillPaint);
      canvas.drawCircle(topFinControl1, 3, debugStrongFillPaint);
      canvas.drawCircle(topFinControl2, 3, debugStrongFillPaint);

      canvas.drawCircle(bottomFin1P1, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin1Control1, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin1Control2, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin1P2, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin1Control3, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin1P3, 3, debugStrongFillPaint);

      canvas.drawCircle(bottomFin2P1, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin2Control1, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin2Control2, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin2P2, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin2Control3, 3, debugStrongFillPaint);
      canvas.drawCircle(bottomFin2P3, 3, debugStrongFillPaint);

      canvas.drawCircle(centerFinP1, 3, debugStrongFillPaint);
      canvas.drawCircle(centerFinP2, 3, debugStrongFillPaint);
      canvas.drawCircle(centerFinControl1, 3, debugStrongFillPaint);
      canvas.drawCircle(centerFinControl2, 3, debugStrongFillPaint);
    }

    if (config.debugEnabled) {
      for (int i = 0; i < horizontalQuadrantsCount; i++) {
        canvas.drawLine(Offset(i * quadrantWidth, 0),
            Offset(i * quadrantWidth, size.height), debugLightPaint);
      }
      for (int i = 0; i < verticalQuadrantsCount; i++) {
        canvas.drawLine(Offset(0, i * quadrantHeight),
            Offset(size.width, i * quadrantHeight), debugLightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
