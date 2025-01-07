import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> questions = [];
  CameraController? _cameraController;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    // Simulate fetching questions from backend
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      questions = [
        "Introduce yourself",
        "Why should we hire you?",
        "What makes you suitable for this role"
      ];
    });
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print("No cameras available");
        return;
      }
      _cameraController =
          CameraController(cameras.first, ResolutionPreset.high);
      await _cameraController?.initialize();
      setState(() {}); // Update the UI after initializing the camera
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void startRecording() async {
    if (_cameraController != null && !_isRecording) {
      await _cameraController?.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  void stopRecording() async {
    if (_cameraController != null && _isRecording) {
      await _cameraController?.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.isEmpty ? 3 : questions.length,
              itemBuilder: (context, index) {
                if (questions.isEmpty) {
                  return ListTile(
                    title: Text(index == 0
                        ? "Introduce yourself"
                        : index == 1
                            ? "Why should we hire you?"
                            : "What makes you suitable for this role"),
                  );
                } else {
                  return ListTile(
                    title: Text(questions[index]),
                  );
                }
              },
            ),
          ),
          if (_isRecording)
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(child: CircularProgressIndicator()),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_isRecording) {
                  stopRecording();
                  setState(
                      () {}); // Update the UI to show the preview and upload button
                } else {
                  await initializeCamera();
                  startRecording();
                }
              },
              icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
              label: Text(_isRecording ? 'Stop Recording' : 'Record Video'),
            ),
          ),
          if (!_isRecording &&
              _cameraController != null &&
              _cameraController!.value.isInitialized)
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: CameraPreview(_cameraController!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Implement your upload functionality here
                      print("Upload video");
                    },
                    icon: Icon(Icons.upload),
                    label: Text('Upload Video'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
