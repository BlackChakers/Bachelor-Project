import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen();

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {}); //Refreshes the widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
          body: Stack(
        children: [
          CameraPreview(cameraController),
          GestureDetector(
              onTap: () {},
              child: button(
                  Icons.flip_camera_android_outlined, Alignment.bottomLeft)),
          GestureDetector(
              onTap: () {
                cameraController.takePicture().then((XFile? file) {
                  if (mounted) {
                    if (file != null) {
                      print('Picture saved til ${file.path}');
                    }
                  }
                });
              },
              child: button(Icons.camera_alt_outlined, Alignment.bottomCenter)),
        ],
      ));
    } else {
      return SizedBox();
    }
  }

  Widget button(IconData icon, Alignment alignment) {
    return Align(
        alignment: alignment,
        child: Container(
            margin: const EdgeInsets.only(
              left: 20,
              bottom: 20,
            ),
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.black54,
              ),
            )));
  }
}