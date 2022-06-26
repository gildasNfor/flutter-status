import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/status_page.dart';
import '../shared/connection.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({Key? key}) : super(key: key);
  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {


  Future<String> _server = getServerAddress();
  String? address = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        title: const Text("Server Address"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('Current Address',
                            style: TextStyle(
                              fontSize: 19,
                            )),
                        FutureBuilder<String>(
                            future: _server,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString() != "" ? snapshot.data.toString() : "No address set",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ));
                              }
                              return Text("No Address set");
                            }
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Enter New Server Address',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  address = value;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                  minimumSize: const Size.fromHeight(60)),
                              onPressed: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setString("server", address!);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => StatusPage()),
                                        (route) => false
                                );
                              },
                              child: const Text("Change Address"),
                            ),
                          ],
                        ),

                      ],
                    ),
                  )
              ),
            ),
          ],
        )
      )
    );
  }
}
