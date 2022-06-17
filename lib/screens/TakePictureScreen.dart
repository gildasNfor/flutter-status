// A screen that allows users to take a picture using a given camera.
// import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_clone_ui/screens/MediaToBePosted.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    // required this.camera,
  }) : super(key: key);


  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {

  bool _isLoading = true;
  bool _clicked = false;
  late CameraDescription side;
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async {
    //Request all available cameras from the camera plugin
    final cameras = await availableCameras();
    //Selecting the front-facing camera.
     side = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);

    if (_clicked) {
      side = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
    } /*else {
      side = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    }*/

    /*Create an instance of CameraController. We are using the CameraDescription
  of the front camera and setting the resolution of the video to the maximum.*/
    _cameraController = CameraController(side, ResolutionPreset.max);
    //Initialize the controller with the set parameters.
    _initializeControllerFuture = _cameraController.initialize();
    setState(() => _isLoading = false);
  }


  _changeCamera() async {
    if (_clicked) {
      setState(() => {_clicked = false, _isLoading = true});
      _initCamera();
    } else {
      setState(() => {_clicked = true, _isLoading = true});
      _initCamera();
    }
  }


  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(title: const Text('Take a picture'), backgroundColor: Colors.black,),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: new Stack(

        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Container(
                  height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: CameraPreview(_cameraController)
                );
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          new Align(
            alignment: Alignment.bottomCenter,

            child: FloatingActionButton(
              heroTag: "capture",

              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _cameraController.takePicture();

                  // If the picture was taken, display it on a new screen.
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MediaToBePosted(
                        // Pass the automatically generated path to
                        // the DisplayPictureScreen widget.
                        image.path,
                      ),
                    ),
                  );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),
          new Align(
            alignment: Alignment.bottomRight,

            child:  FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.wifi_protected_setup_outlined),
                onPressed: () => _changeCamera()),
          )
        ],
      )
    );
  }
}