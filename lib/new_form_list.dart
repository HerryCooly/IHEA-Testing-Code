import 'package:flutter/material.dart';
import 'package:frontend/CommonComponents/pop_out_button.dart';
import 'PageContents/new_form_list_content.dart';
import 'package:frontend/CommonComponents/auth_status.dart';

class NewFormListPage extends StatefulWidget {
  const NewFormListPage({super.key});

  final String title = "Choose a Form";

  @override
  State<NewFormListPage> createState() => _MyNewFormListPageState();
}

class _MyNewFormListPageState extends State<NewFormListPage> {
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
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onBackground,
                ), onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: const [PopOutButton()],
              title: Text(widget.title),
            ),
           // Grab the body
            body: NewFormListContent.getContent(context),
          );
        });
  }
}
