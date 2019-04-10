import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/image_filter/photofilters.dart';
import 'package:image_filter_cropper_sketch/image_editor_page.dart';
import 'package:image_filter_cropper_sketch/image_picker_handler.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  String fileName;
  List<Filter> filters = presetFiltersList;
  List<File> imageFileList = [];

  Future getImage(context) async {
    fileName = basename(_image.path);
    var image = imageLib.decodeImage(_image.readAsBytesSync());
    image = imageLib.copyResize(image, 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
              title: Text("Photo Filter Example"),
              image: image,
              filters: presetFiltersList,
              filename: fileName,
              loader: Center(child: CircularProgressIndicator()),
              fit: BoxFit.contain,
            ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        _image = imagefile['image_filtered'];
        imageFileList.add(_image);
      });
      print(_image.path);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          (imageFileList.length > 1) ?IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                print('file legth ' + imageFileList.length.toString());
                if (imageFileList.length > 1) {
                  setState(() {
                    imageFileList.removeLast();
                    _image = imageFileList[imageFileList.length - 1];
                  });
                }
              }): Container(),
        ],
        title: new Text(
          widget.title,
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: new GestureDetector(
        onTap: () => imagePicker.showDialog(context),
        child: new Center(
          child: _image == null
              ? new Stack(
                  children: <Widget>[
                    new Center(
                      child: new CircleAvatar(
                        radius: 80.0,
                        backgroundColor: const Color(0xFF778899),
                      ),
                    ),
                    new Center(
                      child: new Image.asset("assets/photo_camera.png"),
                    ),
                  ],
                )
              : Stack(
                  children: <Widget>[
                    Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(10.0),
                                decoration: new BoxDecoration(
                                  color: Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1.0,
                                        offset: Offset(1.0, 0.0),
                                        blurRadius: 8.0)
                                  ],
                                  image: new DecorationImage(
                                    image: new ExactAssetImage(_image.path),
                                    fit: BoxFit.contain,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(10.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () {
                                  getImage(context);
                                },
                                fillColor: Colors.black,
                                shape: CircleBorder(),
                                elevation: 10.0,
                                splashColor: Colors.yellowAccent,
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.filter,
                                  color: Colors.yellow,
                                ),
                              ),
                              RawMaterialButton(
                                onPressed: () {},
                                fillColor: Colors.black,
                                shape: CircleBorder(),
                                elevation: 10.0,
                                splashColor: Colors.yellowAccent,
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.format_paint,
                                  color: Colors.yellow,
                                ),
                              ),
                              RawMaterialButton(
                                onPressed: () {},
                                fillColor: Colors.black,
                                shape: CircleBorder(),
                                elevation: 10.0,
                                splashColor: Colors.yellowAccent,
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.tag_faces,
                                  color: Colors.yellow,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
      imageFileList.add(_image);
      Navigator.push(
        this.context,
        new MaterialPageRoute(
          builder: (context) => ImageEditor(imageFile: _image,),
        ),
      );
    });
  }
}
