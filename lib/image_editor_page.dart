import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageEditor extends StatefulWidget {
  final imageFile;

  const ImageEditor({Key key, this.imageFile}) : super(key: key);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.yellow[200], Colors.grey[300]],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: PhotoView.customChild(
                          child: Image.file(
                            widget.imageFile,
                            fit: BoxFit.contain,
                          ),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.transparent),
                          childSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.width)),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
//                          child: ,
                            ),
                      ],
                    ),
                  ],
                ),
                ControlLayer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlLayer extends StatefulWidget {
  @override
  _ControlLayerState createState() => _ControlLayerState();
}

class _ControlLayerState extends State<ControlLayer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
