import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatapp_clone_ui/pages/status_page.dart';
import 'package:whatapp_clone_ui/screens/detail_status_screen.dart';

import 'dart:math';

import '../models/StatusModel.dart';
import '../screens/DisplayStatusText.dart';
import '../shared/connection.dart';

class StatusItem extends StatelessWidget {
  late final int userNumber;
  late final String lastPosted;
  late final String userName;
  late final int numberOfStatus;
  late final String lastImageThumb;

  StatusItem(this.userNumber, this.lastPosted, this.numberOfStatus, this.lastImageThumb, this.userName) {
    print(numberOfStatus);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailStatusScreen(userNumber, numberOfStatus, lastImageThumb, userName)),
              );
      },
      leading:
          _getThumbnail(true, numberOfStatus, lastImageThumb),
      title: Text(
        userName,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
         DateTime.now().hour >= DateTime.parse(lastPosted).hour ? "Today, " + DateTime.parse(lastPosted).hour.toString() + ":"  +DateTime.parse(lastPosted).minute.toString(): " Yesterday, " + DateTime.parse(lastPosted).hour.toString() + ":" + DateTime.parse(lastPosted).minute.toString(),
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _getThumbnail(bool isSeen, int statusNum, String image) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: CustomPaint(
        painter: StatusBorderPainter(statusNum: statusNum),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: CachedNetworkImageProvider(image),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
              border: new Border.all(
                color: Colors.black,
                width: 2.0,
              )),
        ),
      ),
    );
  }
}

degreeToRad(double degree) {
  return degree * pi / 180;
}

class StatusBorderPainter extends CustomPainter {

  // bool isSeen;
  int statusNum;

  StatusBorderPainter({required this.statusNum});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
    drawArc(canvas, paint, size, statusNum);
  }

  void drawArc(Canvas canvas, Paint paint, Size size, int count) {
    if(count == 1) {
      canvas.drawArc(
          new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          degreeToRad(0),
          degreeToRad(360),
          false,
          paint
      );
    }
    else {
      double degree = -90;
      double arc = 360 / count;
      for(int i = 0; i < count; i++) {
        canvas.drawArc(
            new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            degreeToRad(degree+4),
            degreeToRad(arc-8),
            false,
            paint
        );
        degree += arc;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
