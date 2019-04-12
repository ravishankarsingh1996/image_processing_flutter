import 'package:flutter/material.dart';
import 'package:image_filter_cropper_sketch/home_screen.dart';
import 'package:image_filter_cropper_sketch/image_editor_page.dart';
import 'package:palette_generator/palette_generator.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image picker',
      theme:  ThemeData(
        primaryColor:  Color(0xFF02BB9F),
        primaryColorDark:  Color(0xFF167F67),
        accentColor:  Color(0xFF167F67),
      ),
//      home: ImageEditor(),
      home:  HomeScreen(title: 'Flutter Image picker'),
    );
  }

/*Future<void> _updatePaletteGenerator(Rect newRegion) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      widget.image,
      size: widget.imageSize,
      region: newRegion,
      maximumColorCount: 20,
    );
    setState(() {});
  }*/
}
