import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:fluent_ui/fluent_ui.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return ScaffoldPage(
        content: Center(
          child: Text("Hola"),
        ),
      );
  }
}