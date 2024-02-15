import 'package:flutter/material.dart';

import '../functions.dart';

class SimpleHeader extends StatefulWidget {
  const SimpleHeader({
    Key? key,
    required this.item,
    required this.onChange,
    required this.position,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
  }) : super(key: key);
  final dynamic item;
  final Function onChange;
  final int position;
  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;

  @override
  _SimpleHeader createState() => _SimpleHeader();
}

class _SimpleHeader extends State<SimpleHeader> {
  dynamic item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    Widget label = const SizedBox.shrink();
    if (Fun.labelHidden(item)) {
      label = Text(
        item['label'],
        style: Theme.of(context).textTheme.headlineMedium,
      );
    }
    return Container(
      //TODO fix the authors stupid padding to be material3 compatible (not 5.0)
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label
        ],
      ),
    );
  }
}