import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whatapp_clone_ui/pages/root_app.dart';
import 'package:whatapp_clone_ui/redux/store.dart';
import 'package:whatapp_clone_ui/redux/reducers.dart';

Future<void> main() async {
  Store<AppState> _store =
      Store<AppState>(reducer, initialState: AppState.initialState());
  WidgetsFlutterBinding.ensureInitialized();

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
