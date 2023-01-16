import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return NavigationView(
        appBar: const NavigationAppBar(
          leading: Center(
            child: FlutterLogo(size: 20),
          ),
        ),
        pane: NavigationPane(
          header: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: DefaultTextStyle(
              style: FluentTheme.of(context).typography.title!,
              child: const Text('Flutter Desktop')
            ),
          ),
        ),
      );
  }
}