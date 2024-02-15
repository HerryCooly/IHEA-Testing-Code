import 'package:flutter/material.dart';
import 'package:frontend/CommonCode/shared_pref_utils.dart';
import 'package:frontend/new_form_list.dart';
import 'package:frontend/saved_form_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDrawer extends StatefulWidget {
  final String role;

  const CommonDrawer({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  CommonDrawerState createState() => CommonDrawerState(role);
}

class CommonDrawerState extends State<CommonDrawer> {
  final String role;
  CommonDrawerState(this.role);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('IHA Forms',
                style: Theme.of(context).textTheme.displayMedium),
          ),
          ListTile(
            dense: true,
            leading: Text("Employee Tools",
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          ListTile(
            leading: const Icon(
              Icons.create_new_folder_rounded,
            ),
            title: const Text('New Form'),
            onTap: () {
              Navigator.pop(context); // Close Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewFormListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.folder_copy_rounded,
            ),
            title: Row(
              children: [
                const Text('Saved Drafts'),
                Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: getDraftBadge()),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close Drawer // Close Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SavedFormListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.folder_shared_rounded,
            ),
            title: const Text('Submitted Forms'),
            onTap: () {
              //TODO Page navigation
              Navigator.pop(context); // Close Drawer
            },
          ),
          if (role == "manager")
            Divider(
                height: 15,
                // thickness: 5,
                color: Theme.of(context).colorScheme.inversePrimary),
          if (role == "manager")
            ListTile(
              dense: true,
              leading: Text(
                "Manager Tools",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          if (role == "manager")
            ListTile(
              leading: const Icon(
                Icons.rule_folder_rounded,
              ),
              title: const Text('Pending Forms'),
              onTap: () {
                //TODO Page navigation
                Navigator.pop(context); // Close Drawer
              },
            ),
          if (role == "manager")
            ListTile(
              leading: const Icon(
                Icons.drive_folder_upload_rounded,
              ),
              title: const Text('Reviewed Forms'),
              onTap: () {
                //TODO Page navigation
                Navigator.pop(context); // Close Drawer
              },
            ),
        ],
      ),
    );
  }

  FutureBuilder<int> getDraftBadge() {
    return FutureBuilder<int>(
      future: SharedPrefUtils.getDraftCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for the result
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int draftCount = snapshot.data ?? 0;
          return Text(
            draftCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }

}
