import 'dart:convert';
// import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:line_icons/line_icons.dart';
import 'package:whatapp_clone_ui/json/chat_json.dart';
import 'package:whatapp_clone_ui/models/StatusModel.dart';
import 'package:whatapp_clone_ui/models/StatusPreviewModel.dart';
import 'package:whatapp_clone_ui/pages/status_item.dart';
import 'package:whatapp_clone_ui/pages/video_page.dart';
import 'package:whatapp_clone_ui/screens/SetServerAddress.dart';
import 'package:whatapp_clone_ui/screens/TakePictureScreen.dart';
import 'package:whatapp_clone_ui/shared/connection.dart';
import 'package:whatapp_clone_ui/theme/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../screens/DisplayStatusText.dart';
import '../screens/MediaToBePosted.dart';
import '../screens/StatusMessage.dart';
import '../screens/VideoToBePosted.dart';
import '../screens/detail_status_screen.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  late Future<List<StatusPreviewModel>> statusList;
  late Future<List<StatusPreviewModel>> myStatus;
  String? server;


  @override
  void initState() {
    super.initState();
    getServerAddress().then((String value) {
      setState(()  {
        server = value;
      });
    });
    statusList = fetchStatusPreview();
    myStatus = fetchMyStatusPreview();
  }

  Future<List<StatusPreviewModel>> fetchStatusPreview() async {
    await Future.delayed(Duration(seconds: 3));
    final response = await http.get(Uri.parse('$server/status_preview'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<StatusPreviewModel>((json) => StatusPreviewModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  }

    Future<List<StatusPreviewModel>> fetchMyStatusPreview() async {
    String number = userNumber.toString();
    await Future.delayed(Duration(seconds: 3));
    final response = await http.get(Uri.parse('$server/status_preview/$number'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<StatusPreviewModel>((json) => StatusPreviewModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServerPage()));
            },
            icon: Icon(Icons.more_vert)),
      ],
      backgroundColor: bgColor,

    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Status",
                style: TextStyle(
                    fontSize: 23, color: white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 38,
                decoration: BoxDecoration(
                    color: textfieldColor,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  style: TextStyle(color: white),
                  cursorColor: primary,
                  decoration: InputDecoration(
                      prefixIcon:
                          Icon(LineIcons.search, color: white.withOpacity(0.3)),
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: white.withOpacity(0.3), fontSize: 17)),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(color: textfieldColor),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          FutureBuilder<List<StatusPreviewModel>>(
                              future: myStatus,
                              builder: (context,AsyncSnapshot<List<StatusPreviewModel>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Container();
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Container();
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      print("A HUGE ERROR OCCURED");
                                      print(snapshot.error);
                                      String num = userNumber.toString();
                                      return _getThumbnail(true, 0, 'http://localhost:8080/user/view/$num');

                                    }
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailStatusScreen(snapshot.data![0].userNumber, snapshot.data![0].numberOfStatus, snapshot.data![0].lastImageThumb, "You")),
                                        );
                                      },
                                      child: _getThumbnail(true, snapshot.data![0].numberOfStatus, snapshot.data![0].lastImageThumb),
                                    );
                                }
                              }),
            // Container(
                          //   width: 70,
                          //   height: 70,
                          //   decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       image: DecorationImage(
                          //           image: NetworkImage(profile[0]['img']),
                          //           fit: BoxFit.cover)),
                          // ),
                          // Positioned(
                          //   right: 5,
                          //   bottom: 0,
                          //   child: Container(
                          //     width: 20,
                          //     height: 20,
                          //     decoration: BoxDecoration(
                          //         shape: BoxShape.circle, color: primary),
                          //     child: Center(
                          //       child: Icon(
                          //         Icons.add,
                          //         color: white,
                          //         size: 18,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My Status",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: white),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Add to my status",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: white.withOpacity(0.5)),
                          )
                        ],
                      )
                        )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        // key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Take with Camera"),
                                                onPressed: () async {

                                                  final cameras = await availableCameras();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => TakePictureScreen()),
                                                  );
                                                },
                                              )
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Pick from Gallery"),
                                                onPressed: () async {
                                                  final ImagePicker _picker = ImagePicker();
                                                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

                                                  if (pickedFile != null) {
                                                    String imageFile = pickedFile.path;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => MediaToBePosted(imageFile)),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: white.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: primary,
                              size: 20,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        // key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                  child: Text("Take with Camera"),
                                                  onPressed: () async {

                                                    final cameras = await availableCameras();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => CameraPage()),
                                                    );
                                                  },
                                                )
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Pick from Gallery"),
                                                onPressed: () async {

                                                  final ImagePicker _picker = ImagePicker();
                                                  final XFile? pickedFile = await _picker.pickVideo(
                                                      source: ImageSource.gallery);

                                                  // if (pickedFile != null) {
                                                  String videoFile = pickedFile!.path;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoToBePosted(videoFile)),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: white.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.video_camera_back,
                              color: primary,
                              size: 20,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatusMessage()),
                          );
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              color: white.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Icon(
                              Icons.edit,
                              color: primary,
                              size: 20,
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(color: textfieldColor),
          child: Center(
            child: Text(
              "Recent updates",
              style: TextStyle(
                  fontSize: 14,
                  color: white.withOpacity(0.5),
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder<List<StatusPreviewModel>>(
          future: statusList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => snapshot.data![index].userNumber != userNumber ? StatusItem(snapshot.data![index].userNumber,snapshot.data![index].lastStatusTime,snapshot.data![index].numberOfStatus, snapshot.data![index].lastImageThumb, snapshot.data![index].userName) : Container()) ;
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }

  Widget _getThumbnail(bool isSeen, int statusNum, String imageUrl) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: CustomPaint(
        painter: StatusBorderPainter(statusNum: statusNum),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
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

class Photo extends StatelessWidget {
  // const Photo({Key? key}) : super(key: key);

  final String imageUrl;
  late String statusCaption = "";

  Photo(this.imageUrl, this.statusCaption);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(''),
          backgroundColor: Colors.black,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                color: Colors.black,
                width: screenWidth,
                height: screenHeight * 0.8,
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(top: 50),
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                )),
            Container(
              color: Colors.black,
              width: screenWidth,
              child: Text(
                statusCaption != null ? statusCaption : "",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: white),
              ),
            )
          ],
        ));
  }
}

class VideoApp extends StatefulWidget {
  late final String videoUrl;
  late final String statusCaption;

  VideoApp(this.videoUrl, this.statusCaption);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.videoUrl,
      // closedCaptionFile: _loadCaptions(),
      // videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((value) {
        _controller.addListener(() {
          if (!_controller.value.isPlaying &&
              _controller.value.isInitialized &&
              (_controller.value.duration == _controller.value.position)) {
            Navigator.pop(context);
          }
          //Video Completed//
        });
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(''),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _controller.pause();
                        });
                      },
                      onLongPressUp: () {
                        setState(() {
                          _controller.play();
                        });
                      },
                      child: Container(
                          color: Colors.black,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )))),
              Container(
                color: Colors.black,
                width: screenWidth,
                child: Text(
                  widget.statusCaption,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: white),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
