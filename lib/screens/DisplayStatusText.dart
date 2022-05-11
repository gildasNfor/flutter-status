import 'package:flutter/material.dart';

class DisplayStatusText extends StatelessWidget {
  late String statusText;
  DisplayStatusText(this.statusText);
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(''),
          backgroundColor: Colors.purple[200],
        ),
        backgroundColor: Colors.purple[200],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                alignment: Alignment.center,
                height: screenHeight * 0.7,
                width: screenWidth,
                child: Text(statusText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    height: 1.2,
                    color: Colors.white,
                  ),
                )
            ),
          ],
        )
    );
  }
}

