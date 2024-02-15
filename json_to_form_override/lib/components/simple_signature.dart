import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../functions.dart';

// TODO: Add Required: True functionality to signature

class SimpleSignature extends StatefulWidget {
  const SimpleSignature({
    Key? key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
    required this.controller,
  }) : super(key: key);

  final dynamic item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;
  final SignatureController? controller;

  @override
  _SimpleSignature createState() => _SimpleSignature();
}

class _SimpleSignature extends State<SimpleSignature> {
  dynamic item;
  final GlobalKey _sizedBoxKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blueGrey,
  );

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget label = const SizedBox.shrink();
    if (Fun.labelHidden(item)) {
      label = Text(
        item['label'],
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      );
    }

    return Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                label,
                SizedBox(
                  key: _sizedBoxKey,
                  height: 150, // Default height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Signature(
                          controller: _getController(constraints.maxWidth, 150),
                          backgroundColor: Colors.blueGrey,
                          width: constraints.maxWidth,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _controller.disabled = false;
                        _controller.clear();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.undo_rounded),
                      onPressed: () {
                        _controller.disabled = false;
                        _controller.undo();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo_rounded),
                      onPressed: () {
                        _controller.disabled = false;
                        _controller.redo();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.save_rounded),
                      onPressed: () {
                        _controller.disabled = true;
                        item['value'] = _controller.points;
                        item['width'] = _controller.widgetWidth;
                        item['height'] = _controller.widgetHeight;
                      },
                    ),
                  ],
                ),
              ]);
        }));
  }

  _getController(width, height) {
    _controller.setDimensions(width*1.0, height*1.0);
    _controller.points = _getPoints();
    return _controller;
  }

  /// This one method has made me go insane. Fair warning on this one - Dylan
  List<Point> _getPoints() {
    List<Point> decodedPoints = [];

    if (item['value'] != null && item['value'] != []) {
      if (item['value'].runtimeType.toString() != "List<Point>") {
        // Version of dart needs toString, cant do direct comps.
        List<dynamic> rawPoints = item['value'];
        decodedPoints = rawPoints.map((rawPoint) {
          Offset offset = Offset(rawPoint['offset'][0]*1.0, rawPoint['offset'][1]*1.0);
          PointType type = _parsePointType(rawPoint['type']);
          double pressure = rawPoint['pressure']*1.0;
          return Point(offset, type, pressure);
        }).toList();
      } else {
        // Good chance that the item['value'] already happened to be a list of points.
        decodedPoints = item['value'];
      }

      // Get the original signature field size
      var originalWidth = item['width'];
      var originalHeight = item['height'];

      var newWidth = _controller.widgetWidth;
      var newHeight = _controller.widgetHeight;

      // Scale the points to the new size of widget
      decodedPoints = decodedPoints.map((point) {
        double scaledX = (point.offset.dx / originalWidth) * newWidth;
        double scaledY = (point.offset.dy / originalHeight) * newHeight;

        // Ensure the scaled coordinates stay within the boundaries
        scaledX = scaledX.clamp(0.0, newWidth);
        scaledY = scaledY.clamp(0.0, newHeight);

        return Point(Offset(scaledX, scaledY), point.type, point.pressure);
      }).toList();
    }

    return decodedPoints;
  }

  // Helper method to parse string to PointType enum
  PointType _parsePointType(String typeString) {
    switch (typeString) {
      case 'PointType.tap':
        return PointType.tap;
      case 'PointType.move':
        return PointType.move;
      default:
        return PointType.tap; // Default value
    }
  }
}
