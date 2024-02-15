import 'package:flutter/material.dart';

import '../functions.dart';

class SimpleDate extends StatefulWidget {
  const SimpleDate({
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
  _SimpleDate createState() => _SimpleDate();
}

class _SimpleDate extends State<SimpleDate> {
  dynamic item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      //border: OutlineInputBorder(),
                      hintText: item['value'] ?? "",
                      //prefixIcon: Icon(Icons.date_range_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          selectDate();
                        },
                        icon: const Icon(Icons.calendar_today_rounded),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Future selectDate() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      initialDateRange: DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 1)),
          end: DateTime.now()),
    );

    if (picked != null) {
      String date =
          "${picked.start.year.toString()}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')} - "
          "${picked.end.year.toString()}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";
      setState(() {
        item['value'] = date;
        widget.onChange(widget.position, date);
      });
    }
  }
}
