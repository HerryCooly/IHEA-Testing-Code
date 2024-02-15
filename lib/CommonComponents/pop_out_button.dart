import 'package:flutter/material.dart';
import 'package:frontend/CommonComponents/pop_out_items.dart';
import 'package:popover/popover.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

class PopOutButton extends StatelessWidget {
  const PopOutButton({super.key});
  @override
  Widget build(BuildContext context) {
    var username = _getUsername(getCurrentUser());
    // TODO switch from gesture detector to something that shows hover/etc
    return GestureDetector(
        onTap: () => showPopover(
              context: context,
              bodyBuilder: (context) => const PopOutItems(),
              // TODO dynamically scale this
              width: 250,
              height: 98,
              backgroundColor: Theme.of(context).primaryColor,
            ),
        child: Row(children: [
          Text(username),
          const Icon(Icons.arrow_drop_down),
        ]));
  }

  //TODO Investigate having text disappear when screenwidth gets too small
  // See new form width scaling code
  String _getUsername(User? user) {
    return user?.displayName ?? user?.email ?? "Username";
  }
}
