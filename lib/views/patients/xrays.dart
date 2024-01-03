import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Image Collage'),
      ),
      body: XRayUploadScreen(),
    ),
  ));
}

class XRayUploadScreen extends StatelessWidget {
  final images = [
    'assets/xrays/image1.jpg',
    'assets/xrays/image2.jpg',
    'assets/xrays/image3.jpg',
    'assets/xrays/image4.jpg',
    'assets/xrays/image1.jpg',
    'assets/xrays/image2.jpg',
    'assets/xrays/image3.jpg',
    'assets/xrays/image4.jpg',
    // Add more image paths
  ];

  XRayUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Adjust number of images per row
        crossAxisSpacing: 10.0, // Adjust horizontal spacing
        mainAxisSpacing: 10.0, // Adjust vertical spacing
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ImageViewer(images: images, initialIndex: index),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Image.asset(images[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}

class ImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  ImageViewer({super.key, required this.images, required this.initialIndex});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Viewer'),
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                boundaryMargin: EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 2.0,
                child: Image.asset(widget.images[index]),
              );
            },
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                controller.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                controller.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
