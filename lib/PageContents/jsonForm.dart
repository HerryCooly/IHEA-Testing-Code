import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_form/json_schema.dart';

class RegisterMap extends StatefulWidget {
  RegisterMap({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _RegisterMap createState() => _RegisterMap();
}

class _RegisterMap extends State<RegisterMap> {
  Map form = {
    'fields': [
      {
        'key': 'Employee Number',
        'type': 'Input',
        'label': 'Emp #',
        'placeholder': "Please enter your employee number",
        'required': true,
      },
      {
        'key': 'email',
        'type': 'Email',
        'label': 'Email',
        'required': true,
        'decoration': InputDecoration(
          hintText: 'Email',
        ),
      },
      {
        'key': 'Payable',
        'type': 'Input',
        'label': 'Payable to Vendor',
        'required': true,
      },
      {
        'key': 'date',
        'type': 'Date',
        'label': 'date',
        'required': true,
      },
      {
        'key': 'location',
        'type': 'Input',
        'label': 'Travel to / Reason for Travel',
        'required': true,
      }
    ]
  };
  dynamic response;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 750,
              child: Column(children: <Widget>[
                JsonSchema(
                  formMap: form,
                  onChanged: (dynamic response) {
                    this.response = response;
                  },
                  actionSave: (data) {
                    print("Data Output:");
                    print(data['fields']);
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  buttonSave: Container(
                    height: 40.0,
                    color: Colors.blueAccent,
                    child: const Center(
                      child: Text("Submit Form",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  form: null,
                ),
              ]),
            ),
          ),
        ));
  }
}
