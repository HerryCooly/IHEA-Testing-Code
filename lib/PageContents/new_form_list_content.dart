import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/new_form.dart';

class NewFormListContent {
  static Widget getContent(BuildContext context) {
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

  static Widget buildListView() {
    List<dynamic> data = [];
    return FutureBuilder<List<dynamic>>(
        future: _getFormsList('assets/temp_forms_dir/forms_manifest_list.json')
            .then((result) {
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
                  title: Text(form["form"] + " (" + form["number"] + ")"),
                  subtitle: Text(form["title"]),
                  onTap: () {
                    // Handle item click
                    /** TODO make a page build here using a function
                     * to make a form read from JSON (See 807000.json)
                     */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewFormPage(form: form["number"])),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
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

  static Future<List<dynamic>> _getFormsList(String path) async {
    // Load JSON file
    String jsonString = await rootBundle.loadString(path);
    // Decode JSON data
    List<dynamic> data = json.decode(jsonString);
    return data;
  }
}
