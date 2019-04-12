import 'package:flutter/material.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/canvas_handwriting/models/PointsData.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/canvas_handwriting/models/UndoPoints.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/canvas_handwriting/models/pen.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/canvas_handwriting/widgets/paper_painter.dart';

class PaperWidget extends StatefulWidget {
  final _state = PaperWidgetState();
  PaperWidgetState createState() => _state;

  void clear() {
    _state.clear();
  }

  void changePenColor(Color color) {
    _state.changePenColor(color);
  }

  void undo() {
    _state.undo();
  }
}

class PaperWidgetState extends State<PaperWidget> {
  List<PointsData> _points = <PointsData>[];
  List<UndoPoints> _undoPoints = <UndoPoints>[];
  UndoPoints undoPoint;

  Pen pen;

  @override
  void initState() {
    super.initState();
    pen = Pen(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
//    final prefs = UserPreferencesProvider.of(context).currentPen;
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        RenderBox referenceBox = context.findRenderObject();
        Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);
        setState(() {
          _points = List.from(_points)..add(PointsData(localPosition, pen));
          if (undoPoint == null) {
            undoPoint = UndoPoints();
            undoPoint.start = _points.length - 1;
          }
        });
      },
      onPanEnd: (DragEndDetails details) {
        if (undoPoint != null) {
          undoPoint.end = _points.length - 1;
          _undoPoints.add(undoPoint);
          undoPoint = null;
        }
        _points.add(null);
      },
      child: CustomPaint(
          painter: new PaperPainter(_points, pen?.color ), size: Size.infinite),
    );
  }

  void undo() {
    setState(() {
      if (_undoPoints != null && _undoPoints.length > 0) {
        _points.removeRange(_undoPoints[_undoPoints.length - 1].start,
            _undoPoints[_undoPoints.length - 1].end);
        _undoPoints.removeLast();
      }
    });
  }

  void clear() {
    setState(() {
      _points = List();
      _undoPoints = List();
    });
  }

  void changePenColor(Color color){
    setState(() {
      pen = Pen(color: color);
    });
  }
}
