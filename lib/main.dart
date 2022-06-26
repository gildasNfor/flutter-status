import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import 'package:whatapp_clone_ui/pages/root_app.dart';
import 'package:whatapp_clone_ui/redux/store.dart';
import 'package:whatapp_clone_ui/redux/reducers.dart';

Future<void> main() async {
  Store<AppState> _store =
      Store<AppState>(reducer, initialState: AppState.initialState());
  WidgetsFlutterBinding.ensureInitialized();

  // final prefs = await SharedPreferences.getInstance();
  // prefs.setString("key", "TIME TO SIT UP BRO. Your excuse the first time was not even available anyways");
  // print(prefs.getString('key'));
  // prefs.setString("key", "There is a senior in the boys camp discriminating");
  // print(prefs.getString('key'));

  // Obtain a list of the available cameras on the device.
  // final cameras = await availableCameras();
  // print(cameras);

  runApp(StoreProvider<AppState>(
    store: _store,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootApp(),
    ),
  ));
}
