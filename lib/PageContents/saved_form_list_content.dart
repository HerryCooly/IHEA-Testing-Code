import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/CommonCode/shared_pref_utils.dart';
import 'dart:convert';
import 'package:frontend/saved_form.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SavedFormListContent extends StatefulWidget {
  @override
  _SavedFormListContentState createState() => _SavedFormListContentState();
}

class _SavedFormListContentState extends State<SavedFormListContent> {
  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        // TODO Add a Search Bar
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return Padding(
                padding: const EdgeInsets.all(4),
                child: Card(child: buildListView()));
          } else {
            double screenWidth = MediaQuery.of(context).size.width;
            double containerWidth = screenWidth < 600
                ? screenWidth
                : (screenWidth * 2) / 3; // Two-thirds of the screen width

            return Center(
              child: SizedBox(
                width: containerWidth,
                child: Card(
                  child: buildListView(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildListView() {
    return FutureBuilder<List<dynamic>>(
        future: _getFormsList().then((result) {
          data = result;
          return data;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Map form = Map.from(data[index]);
                return ListTile(
                  title: Text(form["filename"]),
                  subtitle: Text(form["title"]),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        form["dateSaved"] ?? "No Date",
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_rounded, color: Colors.red),
                        onPressed: () {
                          _deleteForm(form['filename']);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle item click
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SavedFormPage(form: form['filename'], title: form['filename'],)),
                    ).then((value) => setState((){}));
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            // return const Text("Connection Error.\nWe might be experiencing difficulties.\n\nSorry for the inconvenience.");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.125),
                  const Text("Something went wrong!"),
                  Text(snapshot.error.toString()),
                ],
              ),
            );
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  static Future<List> _getFormsList() async {
    // Get the list of files on the system
    List<dynamic> data = [];

    if (!kIsWeb) {
      // Mobile Behavior
      try {
        final directory = await getApplicationDocumentsDirectory();
        List<FileSystemEntity> files = directory.listSync(recursive: false);
        for (var file in files) {
          if (file is File && file.path.endsWith('.json')) {
            String filenameWithPath =
                file.path.substring(file.path.lastIndexOf("/") + 1);

            String filename = filenameWithPath.substring(
                0, filenameWithPath.indexOf(".json"));

            String dataString = File(file.path).readAsStringSync();
            dynamic jsonData = jsonDecode(dataString);

            String formTitle = jsonData['title'];

            String saveDate = timeAgoFromString(jsonData['dateSaved']);

            data.addAll([
              {"filename": filename, "title": formTitle, "dateSaved": saveDate}
            ]);
          }
        }
      } catch (e) {
        debugPrint('Error accessing support directory: $e');
      }
    } else {
      // Web behavior
      // TODO You would need to handle web-specific file access methods here
    }

    return data;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    debugPrint(path);
    return File('$path/$fileName.json');
  }

  static Future<void> deleteFile(String fileName) async {
    try {
      final file = await _localFile(fileName);

      debugPrint(file.path);
      if (await file.exists()) {
        await file.delete();
        debugPrint('File deleted successfully: $fileName');
      } else {
        debugPrint('File does not exist: $fileName');
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }

  /// --------------------------------------------------------------------------
  ///  Helper method for converting a string in DateTime format to time lapsed values.
  ///  This is used to display messages like "8 minutes ago"
  /// --------------------------------------------------------------------------
  static String timeAgoFromString(String dateString) {
    DateTime pastTime = DateTime.parse(dateString);
    Duration difference = DateTime.now().difference(pastTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months months ago';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years years ago';
    }
  }

  void _deleteForm(String filePath) {
    if (!kIsWeb) {
      // TODO mobile specific deletion
      // Need to: 1. decrement the counter in shared prefs for draftCount
      // 2. Delete the file from document storage
      // 3. delete from the list
      // 4. refresh list.
      deleteFile(filePath);
      SharedPrefUtils.decrementDraftCount();
      setState(() {
        // Refresh the data list by calling _getFormsList again
      });
    } else if (kIsWeb) {
      // TODO more web specific behavior for deleting forms
      // Can just delete from the map, we arent doing anything here specifically, just needs to not be
      // in memory and not in view.
    }
  }
}
