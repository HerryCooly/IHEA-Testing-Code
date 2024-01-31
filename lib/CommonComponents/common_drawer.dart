import 'package:flutter/material.dart';
import '../PageContents/jsonForm.dart';

class CommonDrawer extends StatelessWidget {
  final String role;

  const CommonDrawer({
    super.key,
    required this.role,
  });

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
            child: Text('IHA Expenses',
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
            title: const Text('New Expense'),
            onTap: () {
              //TODO Page navigation
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => RegisterMap()),);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.folder_shared_rounded,
            ),
            title: const Text('View Expenses'),
            onTap: () {
              //TODO Page navigation
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.folder_copy_rounded,
            ),
            title: const Text('Drafts'),
            onTap: () {
              //TODO Page navigation
              Navigator.pop(context);
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
              title: const Text('Pending Expenses'),
              onTap: () {
                //TODO Page navigation
                Navigator.pop(context);
              },
            ),
          if (role == "manager")
            ListTile(
              leading: const Icon(
                Icons.drive_folder_upload_rounded,
              ),
              title: const Text('Reviewed Expenses'),
              onTap: () {
                //TODO Page navigation
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
