import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_whatsapp/src/helpers/text_helpers.dart';
// import 'package:flutter_whatsapp/src/models/status.dart';
// import 'package:flutter_whatsapp/src/values/colors.dart';
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
  late final int numberOfStatus;
  // final String subtitle;
  // final String thumbnail;
  // final Function onTap;
  // final String searchKeyword;
  //
  // StatusItem({
  //   // this.status,
  //   // this.title,
  //   // this.subtitle,
  //   // this.thumbnail,
  //   // this.onTap,
  //   // this.searchKeyword,
  // });

  StatusItem(this.userNumber, this.lastPosted, this.numberOfStatus) {
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
                        DetailStatusScreen(userNumber, numberOfStatus)),
              );
        // final response = await http.get(Uri.parse(
        //     '$hostAndPort/status/$userNumber'));
        //
        // print(json.decode(response.body)[0]);
        // final parsed =
        // json.decode(response.body).cast<Map<String, dynamic>>();
        //
        // final res = parsed
        //     .map<StatusModel>((json) => StatusModel.fromMap(json))
        //     .toList()[0];
        // print(res);
        //
        // if (res.statusImageUrl != null) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             Photo(res.statusImageUrl, res.statusCaption)),
        //   );
        // } else if (res.statusVideoUrl != null) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             VideoApp(res.statusVideoUrl, res.statusCaption)),
        //   );
        // } else {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DisplayStatusText(res.statusText)),
        //   );
        // }
      },
      // tileColor: Colors.white,
      // onTap: onTap,
      leading:
          _getThumbnail(true, numberOfStatus),
      //     : Stack(
      //   children: <Widget>[
      //     CircleAvatar(
      //       radius: 28.0,
      //       backgroundImage: CachedNetworkImageProvider("https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg"),
      //     ),
      //     Positioned(
      //       bottom: 0.0,
      //       right: 0.0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.all(Radius.circular(10))
      //         ),
      //         child: Icon(
      //           Icons.add,
      //           size: 20.0,
      //           color: Colors.white,
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      title:  Text(
        userNumber.toString(),
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
             lastPosted,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _getThumbnail(bool isSeen, int statusNum) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: CustomPaint(
        painter: StatusBorderPainter(statusNum: statusNum),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: CachedNetworkImageProvider("https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg"),
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
