import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'CommonComponents/common_drawer.dart';
import 'PageContents/home_content.dart';
import 'package:frontend/CommonComponents/auth_status.dart';
import 'PageContents/jsonForm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "IHA Expenses";

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
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
            // Grab drawer such that same on every page
            drawer: CommonDrawer(role: role),
            // Grab the body
            body: MainContent.getContent(context),
            // Insert a FAB (Currently just does DEBUG msg, but will make new form later)
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text("User is a: $role"),
                  duration: Durations.medium4,
                ));
              },
              tooltip: 'New Expense',
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
