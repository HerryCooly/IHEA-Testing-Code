import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'PageContents/saved_form_content.dart';
import 'auth_gate.dart';
import 'package:frontend/CommonComponents/auth_status.dart';

String formID = "";

class SavedFormPage extends StatefulWidget {
  const SavedFormPage({super.key, required this.form, required this.title});

  final String title;
  final String form;

  setFormID() {
    formID = form;
  }

  @override
  State<SavedFormPage> createState() {
    setFormID();
    return _MySavedFormPageState();
  }
}

class _MySavedFormPageState extends State<SavedFormPage> {

  @override
  Widget build(BuildContext context) {
    AuthStatus.initAuthCheck(context);
    return FutureBuilder(
        future: AuthStatus.getRole(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) return Container(); // still loading
          String? role = snapshot.data;
          // If for some reason the role was not loaded:
          role ??= "undefined";
          // Future builders must return a widget to build
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () => SavedFormContent.showExitDialog(context, formID),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<ProfileScreen>(
                        builder: (context) => ProfileScreen(
                          appBar: AppBar(
                            title: const Text('User Profile'),
                          ),
                          actions: [
                            SignedOutAction((context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AuthGate()),
                              );
                            })
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
              title: Text(widget.title),
            ),
            // Grab the body
            body: SavedFormContent.getContent(context, formID),
          );
        });
  }
}
