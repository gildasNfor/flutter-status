import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:whatapp_clone_ui/redux/actions.dart';
import 'package:whatapp_clone_ui/shared/connection.dart';
import 'package:whatapp_clone_ui/widgets/_appBar.dart';
import '../redux/store.dart';
import 'DateTimePicker.dart';

import '../pages/status_page.dart';

class StatusMessage extends StatefulWidget {
  @override
  _StatusMessageState createState() => _StatusMessageState();
}

class _StatusMessageState extends State<StatusMessage> {
  String statusText = "";
  // const _StatusMessageState({Key? key}) : super(key: key);

  @override
  void initState() {
    super.initState();

    // print(DateTimePicker.getTime());

  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    String dateTime = DateFormat.yMd().format(DateTime.now().add(const Duration(hours: 24)));
    String _time = DateFormat('HH:mm').format(DateTime.now());
    store.dispatch(FetchTimeAndDateAction(dateTime, _time, false));
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(''),
          backgroundColor: Colors.purple[200],
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
        backgroundColor: Colors.purple[200],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.7,
                  width: screenWidth,
                  child: TextFormField(
                    maxLines: 8,
                    style: TextStyle(
                      fontSize: 40.0,
                      height: 1.2,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    cursorWidth: 3,
                    // cursorHeight: 50,
                    autofocus: true,
                    cursorColor: Colors.white,
                    decoration: InputDecoration.collapsed(
                        // prefixIcon:
                        // Icon(LineIcons.info, color: Colors.grey.withOpacity(0.8)),
                        filled: true,
                        // contentPadding: EdgeInsets.symmetric(vertical: 300),
                        border: InputBorder.none,
                        hintText: "Type a Status...",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 50)),
                    onChanged: (value) {
                      setState(() {
                        statusText = value;
                      });
                    },
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                height: screenHeight * 0.1,
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.4,
                        child: statusText != ""
                            ? GestureDetector(
                                onTap: () async {
                                  try {
                                    var request = MultipartRequest(
                                        "POST",
                                        Uri.parse(
                                            "$hostAndPort/status/672840255"));
                                    request.fields["statusText"] = statusText;
                                    request.fields["disappearTime"] = store.state.date.toString() + "T" + store.state.time.toString();
                                    request.fields["isPublicStatus"] = store.state.isPublicStatus.toString();
                                    var response = await request.send();

                                    var res =
                                        await Response.fromStream(response);
                                    if (res.statusCode == 201) {
                                      Map<String, dynamic> body =
                                          jsonDecode(res.body);
                                      print(body);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StatusPage()),
                                          (route) => false);
                                    } else {
                                      print('error status: ${res.statusCode}');
                                      print(
                                          'error body: ${jsonDecode(res.body)}');
                                      throw "Unable to save user: Server Error";
                                    }
                                  } catch (e) {
                                    print(e);
                                    throw "Unable to save user: Client error";
                                  }
                                },
                                child: Container(
                                  width: screenWidth * 0.3,
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
                            : null)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
