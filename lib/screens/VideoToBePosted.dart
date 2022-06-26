

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:whatapp_clone_ui/shared/connection.dart';

import '../pages/status_page.dart';
import '../redux/actions.dart';
import '../redux/store.dart';
import '../theme/colors.dart';
import 'DateTimePicker.dart';

class VideoToBePosted extends StatefulWidget {
  late final String mediaUrl;
  VideoToBePosted(this.mediaUrl);
  @override
  _MediaToBePostedState createState() => _MediaToBePostedState();
}

class _MediaToBePostedState extends State<VideoToBePosted> {


  late VideoPlayerController _controller;
  String statusCaption = "";
  late String duration;
  bool sent = false;
  String? server;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.mediaUrl))
      ..initialize().then((value) {
        _controller.addListener(() {
          if (!_controller.value.isPlaying &&_controller.value.isInitialized &&
              (_controller.value.duration ==_controller.value.position)) {
            _controller.play();
          }
          //Video Completed//
        });
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          print("THE SIZE OF THIS VIDEO IS");
          duration = _controller.value.duration.inSeconds.toString();
          _controller.play();
          // _controller!.setVolume(0.0);
        });
      });
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
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    String dateTime = DateFormat.yMd().format(DateTime.now().add(const Duration(hours: 24)));
    String _time = DateFormat('HH:mm').format(DateTime.now());
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
        body:SingleChildScrollView(
          child: Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // height: screenHeight * 0.8,
                    // padding: EdgeInsets.symmetric(vertical: 250),
                      child: AspectRatio(

                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
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
                                  .add(MultipartFile.fromBytes("statusVideo",File(widget.mediaUrl).readAsBytesSync(),filename: widget.mediaUrl.toString().split("/").last));
                              statusCaption != "" ? request.fields["statusCaption"] = statusCaption : print("No caption");
                              request.fields["duration"] = duration;
                              request.fields["disappearTime"] = store.state.date + "T" + store.state.time;
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
        ) ) : Center(child: CircularProgressIndicator());
  }
}
