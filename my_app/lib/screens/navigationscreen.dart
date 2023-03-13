import 'package:my_app/screens/firstscreen.dart';
import 'package:my_app/screens/statscreen.dart';
import 'package:fluent_ui/fluent_ui.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIdex = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        leading: Center(
          child: Image.asset('/home/antachua/Flutter_Watchdog/my_app/assets/images/antac_logo.png'),
        ),
      ),
      pane: NavigationPane(
        header: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: DefaultTextStyle(
            style: FluentTheme.of(context).typography.title!,
            child: const Text('Stadia Watchdog'),
          ),
        ),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.process),
            //body: const Text(''),
            title: const Text('Containers State'),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.chat_bot),
            //body: const Text(''),
            title: const Text('Container Stats'),
          ),
        ],
        selected: _currentIdex,
        displayMode: PaneDisplayMode.auto,
        onChanged: (i) {
          setState(() {
            _currentIdex = i;
          });
        },
      ),
      content: NavigationBody(
        index: _currentIdex,
        children:  [
          FirstScreen(),
          ContainerStatsWidget(),
        ],
      ),
    );
  }
}