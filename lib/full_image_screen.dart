import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FullImageScreen extends StatelessWidget {
  final XFile imageFile;

  const FullImageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zoom Image')),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Drag to move
          boundaryMargin: EdgeInsets.all(20), // Extra space for pan
          minScale: 0.5, // Zoom out max
          maxScale: 4.0, // Zoom in max
          child: Image.file(
            File(imageFile.path),
            fit: BoxFit.contain, // Full image visible
          ),
        ),
      ),
    );
  }
}
