import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class FullImageScreen extends StatelessWidget {
  final XFile imageFile;

  const FullImageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD7537F),
        title: Text('Favorite Images', style: GoogleFonts.shrikhand(fontSize: 26, color: Colors.blueGrey)),        ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          constrained: true,
          clipBehavior: Clip.none,
          panEnabled: true, // Drag to move
          boundaryMargin: EdgeInsets.all(20), // Extra space for pan
          minScale: 0.5, // Zoom out max
          maxScale: 4.0, // Zoom in max
          child: Image.file(
            File(imageFile.path),
            fit: BoxFit.fitWidth, // Full image visible
          ),
        ),
      ),
    );
  }
}
