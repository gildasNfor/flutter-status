// A screen that allows users to take a picture using a given camera.
// import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_clone_ui/screens/MediaToBePosted.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
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
                    child: CameraPreview(_controller)
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
                  final image = await _controller.takePicture();

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
          // new Align(
          //   alignment: Alignment.bottomRight,
          //
          //   child: FloatingActionButton(
          //     heroTag: "switch",
          //     // Provide an onPressed callback.
          //     onPressed: () async {
          //       final cameras = await availableCameras();
          //       Navigator.pop(context);
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => TakePictureScreen(camera: cameras.last,)),
          //       );
          //     },
          //     child: const Icon(Icons.wifi_protected_setup_outlined),
          //   ),
          // )
        ],
      )
    );
  }
}