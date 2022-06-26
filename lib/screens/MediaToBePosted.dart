
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:whatapp_clone_ui/shared/connection.dart';

import '../pages/status_page.dart';
import '../redux/actions.dart';
import '../redux/store.dart';
import '../theme/colors.dart';
import 'DateTimePicker.dart';

class MediaToBePosted extends StatefulWidget {
  late final String mediaUrl;
  MediaToBePosted(this.mediaUrl);
  @override
  _MediaToBePostedState createState() => _MediaToBePostedState();
}

class _MediaToBePostedState extends State<MediaToBePosted> {
  // const Photo({Key? key}) : super(key: key);

  // late final File mediaUrl;

  late FocusNode myFocusNode;

   String statusCaption = "";
   bool sent = false;
   String? server;

  @override
  void initState() {
    super.initState();

    getServerAddress().then((String value) {
      setState(()  {
        server = value;
      });
    });


  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    String dateTime = DateFormat.yMd().format(DateTime.now().add(const Duration(hours: 24)));
    print(dateTime);
    String _time = DateFormat('HH:mm').format(DateTime.now());
    print(_time);
    store.dispatch(FetchTimeAndDateAction(dateTime, _time, false));
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return !sent ? Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(''),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DateTimePicker()));
                },
                icon: Icon(Icons.more_vert)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.8,
                    child: PhotoView(
                      imageProvider: FileImage(File(widget.mediaUrl)),
                    ),
                  ),
                  // SizedBox(width: 5),
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                statusCaption = value;
                              });
                            },
                            // keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            cursorColor: primary,
                            decoration: InputDecoration(
                                filled: true,
                                prefixIcon:
                                Icon(LineIcons.info, color: Colors.grey.withOpacity(0.8)),
                                border: InputBorder.none,
                                hintText: "Add a Caption...",
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.8), fontSize: 17)),
                          )
                      ),
                      GestureDetector(
                          onTap:() async {
                            setState(() {
                              sent = true;
                            });
                            try {
                              var request = MultipartRequest("POST", Uri.parse("$server/status/$userNumber"));
                              print(widget.mediaUrl);
                              request.files
                                  .add(MultipartFile.fromBytes("statusImage",File(widget.mediaUrl).readAsBytesSync(),filename: widget.mediaUrl.toString().split("/").last));
                              statusCaption != "" ? request.fields["statusCaption"] = statusCaption : print("No caption");
                              request.fields["disappearTime"] = store.state.date.toString() + "T" + store.state.time.toString();
                              request.fields["isPublicStatus"] = store.state.isPublicStatus.toString();
                              var response = await request.send();

                              var res = await Response.fromStream(response);
                              if (res.statusCode == 201) {
                                Map<String, dynamic> body = jsonDecode(res.body);
                                print(body);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => StatusPage()),
                                        (route) => false
                                );
                              } else {
                                print('error status: ${res.statusCode}');
                                print('error body: ${jsonDecode(res.body)}');
                                throw "Unable to save user: Server Error";
                              }
                            } catch (e) {
                              print(e);
                              throw "Unable to save user: Client error";
                            }

                          },

                          child: Container(
                            width: screenWidth * 0.1,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              )
          ),
        )) : Center(child: CircularProgressIndicator());
  }
}

