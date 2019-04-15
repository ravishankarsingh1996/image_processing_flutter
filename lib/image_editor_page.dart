import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_filter_cropper_sketch/custom_libraries/canvas_handwriting/widgets/paper_widget.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/image_filter/photofilters.dart';
import 'package:path/path.dart';

class ImageEditor extends StatefulWidget {
  final imageFile;

  const ImageEditor({Key key, this.imageFile}) : super(key: key);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  String _fileName;
  File _image;
  List<File> _imageFileList = [];
  bool _isImageFilterApplied = false;
  final _paper = PaperWidget();
  bool _isDrawTextOn = false;
  var pickerColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _image = widget.imageFile;
    _imageFileList.add(_image);
  }

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
                Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Image.file(
                              _image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          IgnorePointer(
                            child: _paper,
                            ignoring: !_isDrawTextOn,
                          ),
                          //Todo add other layers here.....
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  child: ControlLayerTop(
                    isImageFilterApplied: _isImageFilterApplied,
                    onImageFilterUndo: _onUndoImageFilter,
                    onChangePenColor: (){
                      _onShowColorPallet(context);
                    },
                    onClearDrawingSheet: _clearDrawingSheet,
                    onUndoDrawing: _undoDrawing,
                    onDrawingFinish: _drawingFinish,
                    isDrawTextOn: _isDrawTextOn,
                  ),
                  alignment: Alignment.topCenter,
                ),
               !_isDrawTextOn? Align(
                  child: ControlLayerBottom(
                    onGetImageForFilter: () {
                      getImage(context);
                    },
                    onStartDrawingOnCanvas: _onStartDrawing,
                  ),
                  alignment: Alignment.bottomCenter,
                ):Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<imageLib.Image> getDecodedImage(List<int> bytesSync)async {
    return await imageLib.decodeImage(bytesSync);
  }

  Future getImage(context) async {
    _fileName = basename(_image.path);
    var image = imageLib.decodeImage(_image.readAsBytesSync());
    image = imageLib.copyResize(image, 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
              title: Text("Photo Filter Example"),
              image: image,
              filters: presetFiltersList,
              filename: _fileName,
              loader: Center(child: CircularProgressIndicator()),
              fit: BoxFit.contain,
            ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        _image = imagefile['image_filtered'];
        _isImageFilterApplied = true;
        _imageFileList.add(_image);
      });
      print(_image.path);
    }
  }

  void _onUndoImageFilter() {
    if (_imageFileList.length > 1) {
      setState(() {
        _imageFileList.removeLast();
        _image = _imageFileList[_imageFileList.length - 1];
        if (_imageFileList.length <= 1)
          _isImageFilterApplied = false;
      });
    }
  }

  _clearDrawingSheet() {
    if (_paper != null) {
      _paper.clear();
    }
  }

  _undoDrawing() {
    if (_paper != null) {
      _paper.undo();
    }
  }

  _drawingFinish() {
    setState(() {
      _isDrawTextOn = false;
    });
  }

  _onStartDrawing() {
    setState(() {
      _isDrawTextOn = true;
    });
  }

  _onShowColorPallet(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: pickerColor,
            onColorChanged: (color){
              pickerColor = color;
              _paper.changePenColor(color);
            },
            enableLabel: true, // only on portrait mode
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Got it'),
            onPressed: () {
                setState(() =>  _paper.changePenColor(pickerColor));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ControlLayerTop extends StatefulWidget {
  final bool isImageFilterApplied, isDrawTextOn;
  final Function onImageFilterUndo;
  final Function onUndoDrawing;
  final Function onClearDrawingSheet;
  final Function onChangePenColor;
  final Function onDrawingFinish;

  const ControlLayerTop(
      {Key key,
      this.isImageFilterApplied,
      this.onImageFilterUndo,
      this.onUndoDrawing,
      this.onClearDrawingSheet,
      this.onChangePenColor,
      this.onDrawingFinish,
      this.isDrawTextOn})
      : super(key: key);

  @override
  _ControlLayerTopState createState() => _ControlLayerTopState();
}

class _ControlLayerTopState extends State<ControlLayerTop> {
  @override
  Widget build(BuildContext context) {
//    final prefs = UserPreferencesProvider.of(context);
    return Container(
      width: double.maxFinite,
      height: 100.0,
      child: !widget.isDrawTextOn
          ? widget.isImageFilterApplied? Stack(
              children: <Widget>[
                Positioned(
                  child: RawMaterialButton(
                    onPressed: () {
                      widget.onImageFilterUndo();
                    },
                    fillColor: Colors.black,
                    shape: CircleBorder(),
                    elevation: 10.0,
                    splashColor: Colors.yellowAccent,
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.undo,
                      color: Colors.yellow,
                    ),
                  ),
                  right: 10,
                  top: 10,
                )
              ],
            ): Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    widget.onClearDrawingSheet();
                  },
                  fillColor: Colors.black,
                  shape: CircleBorder(),
                  elevation: 10.0,
                  splashColor: Colors.yellowAccent,
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.clear,
                    color: Colors.yellow,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    widget.onUndoDrawing();
                  },
                  fillColor: Colors.black,
                  shape: CircleBorder(),
                  elevation: 10.0,
                  splashColor: Colors.yellowAccent,
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.undo,
                    color: Colors.yellow,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    widget.onChangePenColor();
                  },
                  fillColor: Colors.black,
                  shape: CircleBorder(),
                  elevation: 10.0,
                  splashColor: Colors.yellowAccent,
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.color_lens,
                    color: Colors.yellow,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    widget.onDrawingFinish();
                  },
                  fillColor: Colors.black,
                  shape: StadiumBorder(),
                  elevation: 10.0,
                  highlightElevation: 5.0,
                  splashColor: Colors.yellowAccent,
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ],
            ),
    );
  }
}

class ControlLayerBottom extends StatefulWidget {
  final Function onGetImageForFilter;
  final Function onStartDrawingOnCanvas;

  const ControlLayerBottom(
      {Key key, this.onGetImageForFilter, this.onStartDrawingOnCanvas})
      : super(key: key);

  @override
  _ControlLayerBottomState createState() => _ControlLayerBottomState();
}

class _ControlLayerBottomState extends State<ControlLayerBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              widget.onGetImageForFilter();
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
            onPressed: () {
              widget.onStartDrawingOnCanvas();
            },
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
          RawMaterialButton(
            onPressed: () {},
            fillColor: Colors.black,
            shape: StadiumBorder(),
            elevation: 10.0,
            highlightElevation: 5.0,
            splashColor: Colors.yellowAccent,
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Done',
              style: TextStyle(color: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }
}
