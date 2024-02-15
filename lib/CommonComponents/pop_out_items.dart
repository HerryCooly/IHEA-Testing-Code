import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:frontend/auth_gate.dart';
import 'package:frontend/CommonComponents/auth_status.dart';

class PopOutItems extends StatelessWidget {
  const PopOutItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
            leading: const Icon(
              Icons.person,
            ),
            tileColor: Theme.of(context).primaryColor,
            title: Text('Profile', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<ProfileScreen>(
                      builder: (context) => ProfileScreen(
                            appBar: AppBar(
                              title: const Text('User Profile'),
                            ),
                          )));
            }),
        ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            tileColor: Theme.of(context).primaryColor,
            title: Text('Sign-out', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              AuthStatus.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthGate()),
              );
            }),
      ],
    );
  }
}
