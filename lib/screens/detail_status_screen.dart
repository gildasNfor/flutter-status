import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../models/StatusModel.dart';
import '../shared/connection.dart';
import '../theme/colors.dart';

class DetailStatusScreen extends StatefulWidget {
  final int userNumber;
  final int count;
  final String lastImageThumb;
  final String userName;

  DetailStatusScreen(this.userNumber, this.count, this.lastImageThumb, this.userName);

  _DetailStatusScreenState createState() => _DetailStatusScreenState();
}

class _DetailStatusScreenState extends State<DetailStatusScreen> {
  late Future<List<StatusModel>> _fStatus;
  late List<double> _width;
  late bool imageAvailable;
  late bool media = true;
  int index = 0;
  late List list;
  late int count;
  late String statusText;
  String? caption;
  String? postTime;
  bool initialised = false;
  late ImageProvider _image;
  late VideoPlayerController _controller;
  String? server;


  @override
  void initState() {
    super.initState();
    getServerAddress().then((String value) {
      setState(()  {
        server = value;
      });
    });
    _fStatus = fetchStatus().then((List<StatusModel> status) async {
      setState(() {
        list = status.reversed.toList();
        // list = status;
        count = widget.count;
        print("THE WIDTH ARRAY LOOKS SOMETHING LIKE THIS");
        _width = new List.generate(count, (index) => 0.0);
        print(_width);
      });
      Future.delayed(Duration(milliseconds: 100), () {
        _playStatus();
      });
      return status;
    });
  }

  Future<List<StatusModel>> fetchStatus() async {
    await Future.delayed(Duration(seconds: 2));
    final response =
    await http.get(Uri.parse('$server/status/${widget.userNumber}'));

    // print("The response body is:");
    // print(json.decode(response.body));
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();


    return parsed
        .map<StatusModel>((json) => StatusModel.fromMap(json))
        .toList();
  }

  _playStatus() async {
    if (index < count) {

      setState(() {
        initialised = false;
        _width[index] =
            (MediaQuery.of(context).size.width - 4.0 - (count - 1) * 4.0) /
                count;
        if (list[index].statusImageUrl != null) {
          _image = CachedNetworkImageProvider(list[index].statusImageUrl);
          print(list[index].statusImageUrl);
          media = true;
          imageAvailable = true;
          initialised = true;
          caption = list[index].statusCaption;
          postTime = list[index].postTime;
          index++;
          Future.delayed(Duration(seconds: 5), () {
            _playStatus();
          });
        } else if (list[index].statusVideoUrl != null) {
          _controller = VideoPlayerController.network(
            list[index].statusVideoUrl,
          )..initialize().then((value) {
            _controller.addListener(() {
              if (!_controller.value.isPlaying &&
                  _controller.value.isInitialized &&
                  (_controller.value.duration ==
                      _controller.value.position)) {

              }
              //Video Completed//
            });
            imageAvailable = false;
            media = true;
            postTime = list[index].postTime;
            caption = list[index].statusCaption;
            initialised = true;
            setState(() {
              _controller.play();
              var videoLength = int.parse(list[index].duration);
              index++;
              Future.delayed(Duration(seconds: videoLength), () {
                _playStatus();
              });
            });
          });
        } else {
          media = false;
          statusText = list[index].statusText;
          caption = list[index].statusCaption;
          postTime = list[index].postTime;
          initialised = true;

          index++;
          Future.delayed(Duration(seconds: 5), () {
            _playStatus();
          });
        }
      });

      print(_width);
    } else Navigator.of(context).pop();

  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context)  {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: media ? Colors.black : Colors.purple[200],
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: FutureBuilder(
                    future: _fStatus,
                    builder: (context,AsyncSnapshot<List<StatusModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.grey),
                            ),
                          );
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.grey),
                            ),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}',
                                  style: TextStyle(color: Colors.white)),
                            );
                          }

                          if(initialised == false) {
                            return Container();
                          };

                          if (media) {
                            if (imageAvailable) {
                              return Image(image: _image);
                            } else {
                              return VideoPlayer(_controller);
                            }
                          } else {
                            return Text(
                              statusText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40.0,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            );
                          }
                      }
                    }),
              ),
             caption != null ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                            width: mediaWidth,
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 100),
                            child: Text(
                              caption!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          )
              ): Container(),
              Row(
                  children: [
               initialised ? Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage:
                          NetworkImage(widget.lastImageThumb),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
                  initialised ?  Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.userName,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: white),
                            ),
                            Text(
                                DateTime.now().hour >= DateTime.parse(postTime!).hour ? " Today, " + DateTime.parse(postTime!).hour.toString() + ":"  +DateTime.parse(postTime!).minute.toString(): " Yesterday, " + DateTime.parse(postTime!).hour.toString() + ":" + DateTime.parse(postTime!).minute.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: white.withOpacity(0.5)),
                            )
                          ],
                        ),
                      ),
                    ) : Container(),
              ]),
              FutureBuilder(
                  future: _fStatus,
                  builder: (context,AsyncSnapshot<List<StatusModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        }
                        List<Widget> children = List.empty(growable: true);
                        List<int> counter =
                        new List.generate(count, (index) => index);
                        for (dynamic _ in counter) {
                          children.add(Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 4.0),
                            child: Container(
                              height: 2.5,
                              width: (mediaWidth - 4.0 - (count - 1) * 4.0) /
                                  count,
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                            ),
                          ));
                        }
                        return Row(
                          children: children,
                        );
                    }
                  }),
              FutureBuilder(
                  future: _fStatus,
                  builder: (context,AsyncSnapshot<List<StatusModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return Container();
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        }
                        List<Widget> children = List.empty(growable: true);
                        List<int> counter =
                        List.generate(count, (index) => index);
                        int i = 0;
                        for (dynamic _ in snapshot.data!) {
                          children.add(Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 4.0),
                            child: AnimatedContainer(
                              duration: Duration(
                                  seconds:
                                  list[i].statusVideoUrl != null ? int.parse(list[i].duration) : 5),
                              height: 2.5,
                              width: _width[i],
                              color: Colors.white,
                            ),
                          ));
                          i++;
                        }
                        return Row(
                          children: children,
                        );
                    }
                  }),
            ],
          ),
        ));
  }
}