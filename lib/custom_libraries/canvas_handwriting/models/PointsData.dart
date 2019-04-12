import 'package:flutter/material.dart';
import 'package:image_filter_cropper_sketch/custom_libraries/canvas_handwriting/models/pen.dart';

class PointsData {
  final Offset offset ;
  final Pen pen ;

  PointsData(this.offset, this.pen);
}