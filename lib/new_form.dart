import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'PageContents/new_form_content.dart';
import 'auth_gate.dart';
import 'package:frontend/CommonComponents/auth_status.dart';

String formID = "";

class NewFormPage extends StatefulWidget {
  const NewFormPage({super.key, required this.form});

  final String title = "New Form";
  final String form;

  setFormID() {
    formID = form;
  }

  @override
  State<NewFormPage> createState() {
    setFormID();
    return _MyNewFormPageState();
  }
}

class _MyNewFormPageState extends State<NewFormPage> {
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
                onPressed: () => NewFormContent.showExitDialog(context),
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
            body: NewFormContent.getContent(context, formID),
          );
        });
  }
}
