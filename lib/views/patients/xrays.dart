import 'package:flutter/material.dart';

void main() => runApp(XRayUploadScreen());

class XRayUploadScreen extends StatelessWidget {
  final opgImages = [
    'assets/xrays/opg1.jpg',
    'assets/xrays/opg2.jpg',
    'assets/xrays/opg3.jpg',
    'assets/xrays/opg4.jpg',
  ];

  final periapicalImages = [
    'assets/xrays/peri1.jpg',
    'assets/xrays/peri2.jpg',
    'assets/xrays/peri3.jpg',
    'assets/xrays/peri4.jpg',
  ];

  final _3DImages = [
    'assets/xrays/3D1.png',
    'assets/xrays/3D2.jpg',
    'assets/xrays/3D3.jpg',
    'assets/xrays/3D4.jpg',
  ];

  XRayUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('X-Ray Categories'),
            leading: IconButton(
                splashRadius: 30.0,
                onPressed: () => Navigator.pop(context),
                icon: const BackButtonIcon()),
            actions: [
              IconButton(
                  splashRadius: 30.0,
                  onPressed: () {},
                  icon: const Icon(Icons.add_photo_alternate_outlined)),
              const SizedBox(width: 15.0)
            ],
            backgroundColor: Colors.blue,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Material(
                color: Colors.white70,
                child: TabBar(
                  unselectedLabelColor: Colors.blue,
                  labelColor: Colors.green,
                  indicatorColor: Colors.green,
                  tabs: [
                    Tab(
                      text: 'Periapical ',
                    ),
                    Tab(
                      text: 'Orthopantomagram (OPG)',
                    ),
                    Tab(
                      text: '3D',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _ImageThumbNail(xrayType: periapicalImages),
              _ImageThumbNail(xrayType: opgImages),
              _ImageThumbNail(xrayType: _3DImages)
            ],
          ),
        ),
      ),
    );
  }
}

// Create this class to separate the the repeated widget
class _ImageThumbNail extends StatefulWidget {
  List<String> xrayType = [];
  _ImageThumbNail({Key? key, required this.xrayType}) : super(key: key);

  @override
  State<_ImageThumbNail> createState() => __ImageThumbNailState();
}

class __ImageThumbNailState extends State<_ImageThumbNail> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.xrayType.length,
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
                    builder: (context) => ImageViewer(
                        images: widget.xrayType, initialIndex: index),
                  ),
                );
              },
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Image.asset(widget.xrayType[index], fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  ImageViewer({Key? key, required this.images, required this.initialIndex})
      : super(key: key);

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
        title: const Text('Image Viewer'),
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 2.0,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 4.0,
                    child:
                        Image.asset(widget.images[index], fit: BoxFit.contain),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              margin: const EdgeInsets.only(left: 30.0),
              child: IconButton(
                splashRadius: 30.0,
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.grey),
                onPressed: () {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                splashRadius: 30.0,
                icon: const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.grey),
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
