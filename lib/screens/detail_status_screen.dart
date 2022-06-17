import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../models/StatusModel.dart';
import '../shared/connection.dart';

class DetailStatusScreen extends StatefulWidget {
  final int userNumber;
  final int count;

  DetailStatusScreen(this.userNumber, this.count);

  _DetailStatusScreenState createState() => _DetailStatusScreenState();
}

class _DetailStatusScreenState extends State<DetailStatusScreen> {
  late Future<List<StatusModel>> _fStatus;
  late List<double> _width;
  late bool imageAvailable;
  bool media = true;
  int index = 0;
  late List list;
  late int count;
  late String statusText;
  bool initialised = false;
  late ImageProvider _image;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _fStatus = fetchStatus().then((List<StatusModel> status) {
      setState(() {
        count = widget.count;
        // for (int i = 0; i < count; i++) {
        //   _width[i] = 0.0;
        // }
        print("THE WIDTH ARRAY LOOKS SOMETHING LIKE THIS");
        _width = new List.generate(count, (index) => 0.0);
        print(_width);

      });
      _playStatus();
      return status;
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    super.dispose();
    _controller.dispose();
  }

  Future<List<StatusModel>> fetchStatus() async {
    final response =
        await http.get(Uri.parse('$hostAndPort/status/${widget.userNumber}'));

    // print("The response body is:");
    // print(json.decode(response.body));
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    return parsed
        .map<StatusModel>((json) => StatusModel.fromMap(json))
        .toList();
  }

  _playStatus() async {
    list = await _fStatus;

    if (index < count) {

      setState(() {
        _width[index] =
            (MediaQuery.of(context).size.width - 4.0 - (count - 1) * 4.0) /
                count;
        if (list[index].statusImageUrl != null) {
          print(list[index].statusImageUrl);
          media = true;
          imageAvailable = true;
          _image = CachedNetworkImageProvider(list[index].statusImageUrl);
          index++;
          Future.delayed(Duration(seconds: 5), () {
            _playStatus();
          });
        } else if (list[index].statusVideoUrl != null) {
          print(list[index].statusVideoUrl);
          imageAvailable = false;
          media = true;
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
              setState(() {
                _controller.play();
                index++;
                Future.delayed(Duration(seconds: 26), () {
                  _playStatus();
                });
              });
            });
        } else {
          media = false;
          statusText = list[index].statusText;
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
  Widget build(BuildContext context) {
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


                          if (_image == null) {
                            return Container();
                          }

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
              Text("Caption"),
              Padding(
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
                        radius: 15.0,
                        backgroundImage:
                            NetworkImage('http://placekitten.com/g/150/150'),
                      ),
                    ],
                  ),
                ),
              ),
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
                        for (dynamic _ in counter) {
                          children.add(Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 4.0),
                            child: AnimatedContainer(
                              duration: Duration(
                                  seconds:
                                      list[i].statusVideoUrl != null ? int.parse(list[i].duration) : 5),
                              height: 2.5,
                              width: _width[i],
                              color: Colors.red,
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
