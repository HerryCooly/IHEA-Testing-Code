import 'package:flutter/material.dart';
class MainContent {
  static Widget getContent(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Card Example with\nInner+Outter Padding",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
