import 'package:flutter/material.dart';
import 'package:image_filter_cropper_sketch/home_screen.dart';
import 'package:image_filter_cropper_sketch/image_editor_page.dart';
import 'package:palette_generator/palette_generator.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image picker',
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFF167F67),
      ),
//      home: ImageEditor(),
      home: new HomeScreen(title: 'Flutter Image picker'),
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
