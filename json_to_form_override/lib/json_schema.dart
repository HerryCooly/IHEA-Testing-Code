library json_to_form;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'components/index.dart';

class JsonSchema extends StatefulWidget {
  const JsonSchema({
    this.form,
    required this.onChanged,
    this.padding,
    this.formMap,
    this.autovalidateMode,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.keyboardTypes = const {},
    this.buttonSave,
    this.actionSave,
  });

  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final Map keyboardTypes;
  final String? form;
  final Map? formMap;
  final double? padding;
  final Widget? buttonSave;
  final Function? actionSave;
  final ValueChanged<dynamic> onChanged;
  final AutovalidateMode? autovalidateMode;
  @override
  _CoreFormState createState() =>
      _CoreFormState(formMap ?? json.decode(form!));
}

class _CoreFormState extends State<JsonSchema> {
  final dynamic formGeneral;

  late int radioValue;
  _CoreFormState(this.formGeneral);

  List<Widget> jsonToForm() {
    List<Widget> listWidget = [];
    if (formGeneral['title'] != null) {
      listWidget.add(Text(
        formGeneral['title'],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ));
    }
    if (formGeneral['description'] != null) {
      listWidget.add(Text(
        formGeneral['description'],
        style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
      ));
    }

    for (var count = 0; count < formGeneral['fields'].length; count++) {
      Map item = formGeneral['fields'][count];

      if (item['type'] == "Input" ||
          item['type'] == "Password" ||
          item['type'] == "Email" ||
          item['type'] == "TextArea" ||
          item['type'] == "TextInput") {
        listWidget.add(SimpleText(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "RadioButton") {
        listWidget.add(SimpleRadios(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
        ));
      }

      if (item['type'] == "Header") {
        listWidget.add(SimpleHeader(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "Switch") {
        listWidget.add(SimpleSwitch(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "Checkbox") {
        listWidget.add(SimpleListCheckbox(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "AdvancedCheckbox") {
        listWidget.add(AdvancedListCheckbox(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "Signature") {
        listWidget.add(SimpleSignature(
          controller: null,
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }
      if (item['type'] == "ImagePicker") {
        listWidget.add(SimpleImagePicker(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "Select") {
        listWidget.add(SimpleSelect(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "AdvancedSelect") {
        listWidget.add(AdvancedSelect(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }

      if (item['type'] == "Date") {
        listWidget.add(SimpleDate(
          item: item,
          onChange: onChange,
          position: count,
          decorations: widget.decorations,
          errorMessages: widget.errorMessages,
          validations: widget.validations,
          keyboardTypes: widget.keyboardTypes,
        ));
      }
    }

    if (widget.buttonSave != null && widget.actionSave != null) {
      listWidget.add(Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              widget.actionSave!(formGeneral);
            }
          },
          child: widget.buttonSave,
        ),
      ));
    }

    return listWidget;
  }

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  void onChange(int position, dynamic value) {
    setState(() {
      formGeneral['fields'][position]['value'] = value;
      _handleChanged();
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode:
          formGeneral['autoValidated'] ?? AutovalidateMode.disabled,
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(widget.padding ?? 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: jsonToForm(),
        ),
      ),
    );
  }
}
