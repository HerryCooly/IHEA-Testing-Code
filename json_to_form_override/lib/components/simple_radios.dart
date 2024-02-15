import 'package:flutter/material.dart';
import '../functions.dart';

class SimpleRadios extends StatefulWidget {
  const SimpleRadios({
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
  _SimpleRadios createState() => _SimpleRadios();
}

class _SimpleRadios extends State<SimpleRadios> {
  dynamic item;
  late int radioValue;

  String? isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages[item['key']] ?? 'Please enter some text';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> radios = [];

    if (Fun.labelHidden(item)) {
      radios.add(Text(item['label'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)));
    }
    radioValue = item['value'];
    for (var i = 0; i < item['items'].length; i++) {
      radios.add(
        Row(
          children: <Widget>[
            Expanded(child: Text(item['items'][i]['label'])),
            Radio<dynamic>(
                value: item['items'][i]['value'],
                groupValue: radioValue,
                onChanged: (dynamic value) {
                  setState(() {
                    radioValue = value;
                    item['value'] = value;
                    widget.onChange(widget.position, value);
                  });
                })
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: radios,
      ),
    );
  }
}
