import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'full_image_screen.dart';


// Stateful app. It has AppBar button → dialog for camera/gallery → adds to grid list → tap image for zoom screen

class FavGalleryScreen extends StatefulWidget {
    const FavGalleryScreen({super.key});
  @override
  State<FavGalleryScreen> createState() => _FavGalleryScreenState();
}

class _FavGalleryScreenState extends State<FavGalleryScreen> {
  final List<XFile> _images = []; // List to hold image paths

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _images.add(image); // Add to list
      });

      // Custom success message - stays 2 seconds!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Image added! 📸', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2),  
          behavior: SnackBarBehavior.floating, 
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showPickerOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image from:', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD7537F),
        title: Text('Favorite Images', style: GoogleFonts.shrikhand(fontSize: 26, color: Colors.blueGrey)),
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            color: Colors.blueGrey,
            onPressed: _showPickerOptions, // Tap to show options
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gallery_bg.jpg'), 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.darken), 
          ),
        ),
        child: _images.isEmpty
          ? Center(child: Text('No images selected', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)))
          : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                childAspectRatio: 1, // Square tiles
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullImageScreen(imageFile: XFile(_images[index].path)),
                  ),
                ),
                child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_images[index].path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      // Delete icon overlay (top-right, always visible)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showDeleteDialog(index),  
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(61, 0, 0, 0), 
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_forever,  
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
        )
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image?'),
        content: const Text('This image will be removed from your Favorite Images.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _images.removeAt(index);  // Remove from list!
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}