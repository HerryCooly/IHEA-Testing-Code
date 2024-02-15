import 'package:flutter/material.dart';
import '../functions.dart';

class AdvancedSelect extends StatefulWidget {
  const AdvancedSelect({
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
  _AdvancedSelect createState() => _AdvancedSelect();
}

class _AdvancedSelect extends State<AdvancedSelect> {
  dynamic item;
  late TextEditingController textFieldController;

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
    textFieldController = TextEditingController();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget label = SizedBox.shrink();
    if (Fun.labelHidden(item)) {
      label = Text(
        item['label'],
        style: Theme.of(context).textTheme.headlineSmall,
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label,
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: item['value'],
                  onChanged: (String? newValue) {
                    setState(() {
                      item['value'] = newValue;
                      widget.onChange(widget.position, newValue);
                    });
                  },
                  items: item['items'].map<DropdownMenuItem<String>>(
                    (dynamic data) {
                      return DropdownMenuItem<String>(
                        value: data['value'],
                        child: Text(
                          data['label'],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              if (item['value'] != item['items'].first['value']) ...[
                const SizedBox(width: 10),
                // Add spacing between the dropdown and text field
                Expanded(
                  child: TextFormField(
                    controller: textFieldController,
                    onChanged: (value) {
                      setState(() {
                        // Update the text field value
                        item['textFieldValue'] = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "amount",
                      hintText: "0.00",
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
