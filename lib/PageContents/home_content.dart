import 'package:flutter/material.dart';

class MainContent {
  static Widget getContent(
      BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Text("Hello!"))),
          ),
        ],
      ),
    );
  }
}
