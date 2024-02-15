import 'dart:convert';

import 'package:flutter/material.dart';

import '../functions.dart';

class AdvancedListCheckbox extends StatefulWidget {
  const AdvancedListCheckbox({
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
  _AdvancedListCheckbox createState() => _AdvancedListCheckbox();
}

class _AdvancedListCheckbox extends State<AdvancedListCheckbox> {
  dynamic item;
  List<dynamic> selectItems = [];

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
    for (var i = 0; i < item['items'].length; i++) {
      if (item['items'][i]['value'] == true) {
        selectItems.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> checkboxes = [];
    if (Fun.labelHidden(item)) {
      checkboxes.add(Text(item['label'],
          style: Theme.of(context).textTheme.headlineSmall));
    }
    for (var i = 0; i < item['items'].length; i++) {
      checkboxes.add(
        Row(
          children: <Widget>[
            Expanded(child: Text(item['items'][i]['label'])),
            // Add TextField conditionally based on the checkbox state
            if (item['items'][i]['value'] == true)
              Expanded(
                child: TextFormField(
                  initialValue: item['items'][i]['textFieldValue'],
                  onChanged: (value) {
                    setState(() {
                      // Update the text field value
                      item['items'][i]['textFieldValue'] = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    hintText: "0.00",
                  ),
                ),
              ),
            Checkbox(
              value: item['items'][i]['value'],
              onChanged: (bool? value) {
                setState(
                  () {
                    item['items'][i]['value'] = value;
                    if (value!) {
                      selectItems.add(i);
                      // Add logic to add a TextField dynamically
                      item['items'][i]['textFieldValue'] =
                          ''; // Initialize text field value
                    } else {
                      selectItems.remove(i);
                      // Remove the text field value if the checkbox is unchecked
                      item['items'][i].remove('textFieldValue');
                    }
                    widget.onChange(widget.position, selectItems);
                    //_handleChanged();
                  },
                );
              },
            )
          ],
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: checkboxes,
      ),
    );
  }
}
