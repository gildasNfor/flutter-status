import 'dart:convert';
// import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:line_icons/line_icons.dart';
import 'package:whatapp_clone_ui/json/chat_json.dart';
import 'package:whatapp_clone_ui/models/StatusModel.dart';
import 'package:whatapp_clone_ui/models/StatusPreviewModel.dart';
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



class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {

  late Future<List<StatusPreviewModel>> statusList;



  @override
  void initState()  {
    super.initState();
    statusList = fetchStatusPreview();
    print(statusList);
  }


  Future<List<StatusPreviewModel>> fetchStatusPreview() async {
    final response =
    await http.get(Uri.parse('$hostAndPort/status_preview'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      print("No error");

      return parsed.map<StatusPreviewModel>((json) => StatusPreviewModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load album');
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
      backgroundColor: bgColor,
      title: Row(
        children: [
          Text(
            "Privacy",
            style: TextStyle(
                fontSize: 16, color: primary, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
  Widget preview (AsyncSnapshot<List<StatusPreviewModel>>  snapshot, int index) {
    return GestureDetector(
      onTap: () async {
        final response =
        await http.get(Uri.parse('$hostAndPort/status/${snapshot.data![index].userNumber}'));

        print(json.decode(response.body)[0]);
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

        final res = parsed.map<StatusModel>((json) => StatusModel.fromMap(json)).toList()[0];
        print(res);

        if(res.statusImageUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Photo(res.statusImageUrl, res.statusCaption)),
          );
        } else if (res.statusVideoUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoApp(res.statusVideoUrl, res.statusCaption)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DisplayStatusText(res.statusText)),
          );
        }
      },

        child: Container(
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
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage('$hostAndPort/status/view_image/672840255?postTime=2022-04-02T02:01:34.128214'),
                                fit: BoxFit.cover)),
                      ),

                    ],
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${snapshot.data![index].userNumber}",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${snapshot.data![index].lastStatusTime}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: white.withOpacity(0.5)),
                    )
                  ],
                )
              ],
            ),

          ],
        ),
      ),
    ));
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
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(profile[0]['img']),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            right: 5,
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: primary),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: white,
                                  size: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
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
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {

                        // final ImagePicker _picker = ImagePicker();
                        // final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        //
                        // if (pickedFile != null) {
                        //   String imageFile = pickedFile.path;
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => MediaToBePosted(imageFile)),
                        //   );
                        // }
                        final cameras = await availableCameras();
                        Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TakePictureScreen(camera: cameras.first,)),
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

                          final ImagePicker _picker = ImagePicker();
                          final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

                          // if (pickedFile != null) {
                          String videoFile = pickedFile!.path;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VideoToBePosted(videoFile)),
                          );
                          // }

                          print("The button has been clicked");
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
                            MaterialPageRoute(builder: (context) => StatusMessage()),
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
                itemBuilder: (_, index) => preview(snapshot, index)
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      ],
    );
  }
}


class Photo extends StatelessWidget {
  // const Photo({Key? key}) : super(key: key);

  final String imageUrl;
  late String statusCaption = "";

  Photo (this.imageUrl, this.statusCaption);

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
        body:
        Column(
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
                )
            ),
            Container(
              color: Colors.black,
              width: screenWidth,
              child: Text(statusCaption != null ? statusCaption : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: white
                ),
              ),
            )
          ],
        )
       );
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
    print("Atleast I tried");
    _controller = VideoPlayerController.network(widget.videoUrl,
      // closedCaptionFile: _loadCaptions(),
      // videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..initialize().then((value) {
        _controller.addListener(() {
          if (!_controller.value.isPlaying &&_controller.value.isInitialized &&
              (_controller.value.duration ==_controller.value.position)) {
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
                        )
                      ))
              ),
              Container(
                color: Colors.black,
                width: screenWidth,
                child: Text(widget.statusCaption,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: white
                  ),
                ),
              )
            ],
          ),
        )

        );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}



