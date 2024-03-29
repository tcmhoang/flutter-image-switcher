import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imgswitcher/components/image_thumbnail.dart';
import 'package:imgswitcher/screens/home.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final List<ImageThumbnail> galleryItems;
  final Axis scrollDirection;
  final BoxDecoration backgroundDecoration;

  ImageView(
    this.galleryItems, {
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int currIdx;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    currIdx = widget.initialIndex;
    _controller = PageController(initialPage: currIdx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$currIdx'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            url: widget.galleryItems[currIdx].resource,
                          )),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Select',
                  style: TextStyle(
                    color: Colors.black,
                  )))
        ],
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: _buildItem,
          itemCount: widget.galleryItems.length,
          backgroundDecoration: widget.backgroundDecoration,
          onPageChanged: onPageChanged,
          scrollDirection: widget.scrollDirection,
          gaplessPlayback: true,
          pageController: _controller,
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      currIdx = index;
    });
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ImageThumbnail item = widget.galleryItems[index];
    print(index);
    print(item.resource);
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * 0.5,
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes:
          PhotoViewHeroAttributes(tag: index, transitionOnUserGestures: true),
    );
  }
}
