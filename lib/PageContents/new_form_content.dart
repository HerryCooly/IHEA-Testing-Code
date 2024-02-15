import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:frontend/new_form.dart';
import 'package:json_to_form/json_schema.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:frontend/CommonCode/shared_pref_utils.dart';

class NewFormContent {
  dynamic response;

  static Map<String, dynamic> data = {};

  static Widget getContent(context, String path) {
    // I know this is deprecated by PopScope is by far worse.
    return WillPopScope(
        onWillPop: () async {
          // Show the confirmation dialog
          final bool? result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return _exitAlertDialog(context);
            },
          );

          // If the user confirms, allow back navigation
          return result ?? false;
        },
        child: SingleChildScrollView(
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(children: <Widget>[
              FutureBuilder<Map<String, dynamic>>(
                  future: _getForm("assets/temp_forms_dir/$path.json")
                      .then((result) {
                    data = result;
                    return data;
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: LayoutBuilder(
                          builder: (context, BoxConstraints constraints) {
                            if (constraints.maxWidth < 600) {
                              // Mobile layout
                              return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Card(
                                    child: buildForm(context, data),
                                  ));
                            } else {
                              double screenWidth =
                                  MediaQuery.of(context).size.width;
                              double containerWidth = screenWidth < 600
                                  ? screenWidth
                                  : (screenWidth * 2) / 3;
                              return Center(
                                child: SizedBox(
                                  width: containerWidth,
                                  child: Card(
                                    child: buildForm(context, data),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.white,
                                size:
                                    MediaQuery.of(context).size.width * 0.125),
                            const Text("Something went wrong!"),
                            const Text("Form could not load."),
                          ],
                        ),
                      );
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  })
            ]),
          ),
        ));
  }

  /// --------------------------------------------------------------------------
  /// Helper method to retrieve form from assets
  /// TODO make retrieve come from DB Server
  /// --------------------------------------------------------------------------
  static Future<Map<String, dynamic>> _getForm(String path) async {
    // Load JSON file
    String jsonString = await rootBundle.loadString(path);
    // Decode JSON data
    Map<String, dynamic> data = json.decode(jsonString);
    return data;
  }

  /// --------------------------------------------------------------------------
  /// Helper method to build the form from data.
  /// It uses the json_to_form library and also contains the code for submisision.
  /// TODO save to server
  /// --------------------------------------------------------------------------
  static JsonSchema buildForm(context, data) {
    return JsonSchema(
      formMap: data,
      onChanged: (dynamic response) {
        response = response;
      },
      actionSave: (data) {
        debugPrint(jsonEncode(data));
        // TODO navigate away
      },
      autovalidateMode: AutovalidateMode.disabled,
      buttonSave:
          const OutlinedButton(onPressed: null, child: Text("Submit Form")),
    );
  }

  /// --------------------------------------------------------------------------
  ///  Code that calls the exit dialog bubble
  ///  This is public because the parent calls it (new_form.dart)
  /// --------------------------------------------------------------------------
  static void showExitDialog(BuildContext context) async {
    final bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _exitAlertDialog(context);
      },
    );

    if (result == true) {
      // If the user confirms, pop the current route
      Navigator.of(context).pop(true);
    } else if (result == false) {
      // pop was not allowed to occur because it returned false, cancel and do nothing
      return;
    }
  }

  /// --------------------------------------------------------------------------
  ///  Code that calls the save dialog bubble
  /// --------------------------------------------------------------------------
  static void _showSaveDialog(BuildContext context) async {
    final bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _saveAlertDialog(context);
      },
    );
    if (result == true) {
      //result came as true, pop.
      // Can simplify this...
      return Navigator.of(context).pop(true);
    }
  }

  /// --------------------------------------------------------------------------
  ///  Code for the exit dialog bubble
  ///  This appears if the user tries to exit the screen
  /// --------------------------------------------------------------------------
  static AlertDialog _exitAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Exit'),
      content: const Text('Did you want to save the current form as a draft?'),
      actions: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                // Return true when Exit is pressed, allow exit
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "Discard",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const Expanded(
              child:
                  SizedBox(), // Empty widget to push the other buttons to the right
            ),
            TextButton(
              onPressed: () {
                _showSaveDialog(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                // Return false when Cancel is pressed, block exit
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }

  /// --------------------------------------------------------------------------
  ///  Code for the save dialog bubble
  ///  This appears if the user choose to save the current file while exiting.
  /// --------------------------------------------------------------------------
  static AlertDialog _saveAlertDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return AlertDialog(
      title: const Text('Save as Draft'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Attachments will not save as part of the form.'
              '\n\nCertain features may not be available offline.'),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                labelText: 'Draft Name',
                hintText: "Enter a name for the file",
                helperText: "File name to be displayed later."),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(true); // Return 0, allow to pop, effectively cancel.
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save draft with the provided name
            String draftName = nameController.text;
            if (draftName == "") draftName = "Unnamed Form";

            data.addAll({"dateSaved": DateTime.now().toString()});
            // debugPrint(jsonEncode(data));
            if (!kIsWeb) {
              // Mobile file save behavior
              _writeFile(data, draftName);
              debugPrint("File wrote!");
            } else if (kIsWeb) {
              // Web file save behavior
              //TODO web file save behaviour
            }

            SharedPrefUtils.incrementDraftCount();
            // Return 0, allow to pop, w/ saved data
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        )
      ],
    );
  }

  /// --------------------------------------------------------------------------
  /// File write code for saving on Mobile platforms.
  /// TODO May require dart.io to be conditionally imported for web
  /// --------------------------------------------------------------------------
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    debugPrint(path);
    return File('$path/$fileName.json');
  }

  static Future<File> _writeFile(Map data, String fileName) async {
    final file = await _localFile(fileName);

    // Write the file
    return file.writeAsString(jsonEncode(data));
  }
}
