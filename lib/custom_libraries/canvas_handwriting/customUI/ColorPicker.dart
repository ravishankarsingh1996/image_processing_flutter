import 'package:flutter/material.dart';

const double baseHeight = 24.0;
const double baseSpacing = 15.0;
const double baseMargin = 15.0;

class ColorPicker extends StatefulWidget {
  
  final Function onSelected;
  final double boxesHeight;
  final double spacing;
  final double margin;
  final Color currentColor;

  ColorPicker({this.onSelected, this.boxesHeight, this.spacing, this.margin, this.currentColor});

  @override
  ColorPickerState createState() =>  ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
  Color _mainColorSelected;
  Color _subColorSelected;

  @override
  void initState() {
    super.initState();

    if (widget.currentColor != null) {
      _selectColor(null, widget.currentColor, false);
    }

    if (_subColorSelected == null) {
      _selectColor(null, Colors.black, false);
    }
  }

  bool _selectColor(BuildContext context, Color color, bool finalColor) {
    bool found = false;

    // try in the selected main color
    if (_mainColorSelected != null) {
      subColorList[_mainColorSelected].forEach((subColor) {
        if (subColor == color) {
          setState(() {
            _subColorSelected = color;
          });

          found = true;
          return;
        }
      });
    }

    if (!found) {
      // try other main colors
      subColorList.forEach((k, v) {
        if (k != _mainColorSelected) {
          v.forEach((subColor) {
            if (subColor == color) {
              setState(() {
                _mainColorSelected = k;
                _subColorSelected = color;
              });

              found = true;
              return;
            }
          });
        }
        if (found) return;
      });
    }

    if (finalColor) {
      if (widget.onSelected != null) {
        widget.onSelected(color);
      } else {
        if (context != null) {
          Navigator.pop<Color>(context, color);
        }
      }
    }

    return found;
  }

  @override
  Widget build(BuildContext context) {
    var column =
    // main colors
    new Column(children: <Widget>[
      new SizedBox(height: widget.boxesHeight ?? baseHeight, child:
      new Row(crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _mainColors(context),
      ),
      ),
      new SizedBox(height: widget.spacing ?? baseSpacing),
    ]);

    // two subcolors lines
    [1,2].forEach((line) {
      column.children.add(
          new SizedBox(height: widget.boxesHeight ?? baseHeight, child:
          new Row(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _subColors(context, line),
          ),
          )
      );
    });

    return new Container(
      padding: EdgeInsets.all(widget.margin ?? baseMargin),
      child: column,
    );
  }

  List<Widget> _mainColors(BuildContext context) {
    var children = <Widget>[];
    for (Color color in mainColors) {
      children.add(new Expanded(child: new Stack(children: _mainColorsStackChildren(context, color))));
    }
    return children;
  }

  List<Widget> _mainColorsStackChildren(BuildContext context, Color color) {
    var children = <Widget>[];

    if (_mainColorSelected == color) {
      children.add(
          new Container(decoration: BoxDecoration(
              boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 2.0)]
          ))
      );
    }

    children.add(
        new GestureDetector(child:
        new Container(color: color),
          onTapDown: (d) {
            _selectColor(context, color, false);
          },
        )
    );

    if (_mainColorSelected == color) {
      children.add(
          new Container(decoration: BoxDecoration(
            border: new Border.all(color: Colors.grey[200], width: 3.0),
          ))
      );
    }

    return children;
  }

  List<Widget> _subColors(BuildContext context, int line) {
    var children = <Widget>[];
    int offset = ((line-1)*4);
    for(int i = 0 + offset; i <= 3 + offset; i++) {
      children.add(new Expanded(child: new Stack(children: _subColorsStackChildren(context, i))));
    }
    return children;
  }

  List<Widget> _subColorsStackChildren(BuildContext context, int i) {
    var children = <Widget>[];
    Color color = subColorList[_mainColorSelected][i];

    children.add(
        new GestureDetector(child:
        new Container(color: color),
          onTapDown: (d) {
            _selectColor(context, color, true);
          },
        )
    );

    if (_subColorSelected == color) {
      Color highlightedColor = highlightColor(color);
      children.add(
          new GestureDetector(child:
          new Container(decoration: BoxDecoration(shape: BoxShape.circle,
              border: new Border.all(color: highlightedColor, width: 1.5)), child:
          new Center(child:
          new Icon(Icons.check, size: (baseHeight / 2.0), color: highlightedColor)
          ),
            margin: EdgeInsets.all(2.0),
          ),
              onTapDown: (d) {
                _selectColor(context, color, true);
              })
      );
    }

    return children;
  }

  Color highlightColor(Color c) {
    if (c.computeLuminance() < 0.3)
      return Colors.white;

    return Colors.black;
  }
}


const List<Color> mainColors = const <Color>[
  Colors.black,
  const Color(0xFF980000), const Color(0xFFFF0000), const Color(0xFFFF9900), const Color(0xFFFFFF00), const Color(0xFF00FF00),
  const Color(0xFF00FFFF), const Color(0xFF4A86E8), const Color(0xFF0000FF), const Color(0xFF9900FF), const Color(0xFFFF00FF),
];

Map<Color, List<Color>> subColorList = <Color, List<Color>>{
  Colors.black: const <Color>[
    Colors.black, const Color(0xFF434343), const Color(0xFF666666), const Color(0xFFB7B7B7),
    const Color(0xFFCCCCCC), const Color(0xFFD9D9D9), const Color(0xFFEFEFEF), Colors.white,
  ],
  const Color(0xFF980000): const <Color>[
    const Color(0xFF5B0F00), const Color(0xFF85200C), const Color(0xFFA61C00), const Color(0xFF980000),
    const Color(0xFFCC4125), const Color(0xFFDD7E6B), const Color(0xFFE6B8AF), Colors.white,
  ],
  const Color(0xFFFF0000): const <Color>[
    const Color(0xFF660000), const Color(0xFF990000), const Color(0xFFCC0000), const Color(0xFFFF0000),
    const Color(0xFFE06666), const Color(0xFFEA9999), const Color(0xFFF4CCCC), Colors.white,
  ],
  const Color(0xFFFF9900): const <Color>[
    const Color(0xFF783F04), const Color(0xFFB45F06), const Color(0xFFE69138), const Color(0xFFFF9900),
    const Color(0xFFF6B26B), const Color(0xFFF9CB9C), const Color(0xFFFCE5CD), Colors.white,
  ],
  const Color(0xFFFFFF00): const <Color>[
    const Color(0xFF7F6000), const Color(0xFFBF9000), const Color(0xFFF1C232), const Color(0xFFFFFF00),
    const Color(0xFFFFD966), const Color(0xFFFFE599), const Color(0xFFFFF2CC), Colors.white,
  ],
  const Color(0xFF00FF00): const <Color>[
    const Color(0xFF274E13), const Color(0xFF38761D), const Color(0xFF6AA84F), const Color(0xFF00FF00),
    const Color(0xFF93C47D), const Color(0xFFB6D7A8), const Color(0xFFD9EAD3), Colors.white,
  ],
  const Color(0xFF00FFFF): const <Color>[
    const Color(0xFF0C343D), const Color(0xFF134F5C), const Color(0xFF45818E), const Color(0xFF00FFFF),
    const Color(0xFF76A5AF), const Color(0xFFA2C4C9), const Color(0xFFD0E0E3), Colors.white,
  ],
  const Color(0xFF4A86E8): const <Color>[
    const Color(0xFF1C4587), const Color(0xFF1155CC), const Color(0xFF3C78D8), const Color(0xFF4A86E8),
    const Color(0xFF6D9EEB), const Color(0xFFA4C2F4), const Color(0xFFC9DAF8), Colors.white,
  ],
  const Color(0xFF0000FF): const <Color>[
    const Color(0xFF073763), const Color(0xFF0B5394), const Color(0xFF3D85C6), const Color(0xFF0000FF),
    const Color(0xFF6FA8DC), const Color(0xFF9FC5E8), const Color(0xFFCFE2F3), Colors.white,
  ],
  const Color(0xFF9900FF): const <Color>[
    const Color(0xFF20124D), const Color(0xFF351C75), const Color(0xFF674EA7), const Color(0xFF9900FF),
    const Color(0xFF8E7CC3), const Color(0xFFB4A7D6), const Color(0xFFD9D2E9), Colors.white,
  ],
  const Color(0xFFFF00FF): const <Color>[
    const Color(0xFF4C1130), const Color(0xFF741B47), const Color(0xFFA64D79), const Color(0xFFFF00FF),
    const Color(0xFFC27BA0), const Color(0xFFD5A6BD), const Color(0xFFEAD1DC), Colors.white,
  ],
};