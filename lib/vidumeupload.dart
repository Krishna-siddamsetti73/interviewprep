import 'package:aichatroom/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class VidumeUpload extends StatefulWidget {
  @override
  _VidumeUploadState createState() => _VidumeUploadState();
}

class _VidumeUploadState extends State<VidumeUpload> {
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _recordVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  void _uploadVideo() {
    if (_videoFile != null) {
      // Implement your upload logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select or record a video first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Resume Video'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_videoFile != null)
              Container(
                height: 200,
                child: Center(
                  child: Text('Video selected: ${_videoFile!.path}'),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Upload Video from Gallery'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recordVideo,
              child: Text('Record Video'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload Video'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController codeController =
                        TextEditingController();
                    return AlertDialog(
                      title: Text('Enter 4-digit Code'),
                      content: TextField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter code',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (codeController.text.length == 4) {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please enter a valid 4-digit code.')),
                              );
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Enter ai chat room'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VidumeUpload(),
  ));
}
