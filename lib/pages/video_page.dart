import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:status_module/video_page.dart';
import 'package:whatapp_clone_ui/screens/VideoToBePosted.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  bool _clicked = false;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    //Request all available cameras from the camera plugin
    final cameras = await availableCameras();
    //Selecting the front-facing camera.
    CameraDescription side = cameras.firstWhere(
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
    await _cameraController.initialize();
    //After the initialization, set the _isLoading state to false.
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoToBePosted( file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(_isRecording ? Icons.stop : Icons.circle),
                    onPressed: () => _recordVideo(),
                  ),
                  FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.wifi_protected_setup_outlined),
                      onPressed: () => _changeCamera()),
                  /*child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_clicked ? Icons.emoji_people : Icons.email),
                onPressed: () => _changeCamera(),*/
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
