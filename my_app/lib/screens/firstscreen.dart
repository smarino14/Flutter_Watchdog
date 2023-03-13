import 'package:flutter/material.dart';
import 'package:my_app/utils/utils.dart';
import 'dart:async';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Map<String, dynamic> _containerData = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (_) => _refreshData());
  }

  Future<void> _refreshData() async {
    final containerData = await checkContainerRunning('docker ps');
    if (mounted) {
      setState(() {
        _containerData = containerData;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final containerWidgets = _containerData.entries.map((entry) {
      final containerName = entry.key;
      final containerStatus = entry.value[0];
      final containerCode = entry.value[1];
      IconData iconData;
      Color textColor;
      bool isExited = false;
      switch (containerStatus) {
        case 'Up':
          iconData = Icons.check_circle;
          textColor = Colors.green;
          break;
        case 'Exited':
          iconData = Icons.error;
          textColor = Colors.red;
          isExited = true;
          break;
        case 'Restarting':
          iconData = Icons.refresh;
          textColor = Colors.orange;
          break;
        default:
          iconData = Icons.help_outline;
          textColor = Colors.grey;
          break;
      }
      final statusText = '$containerStatus${containerCode != '0' ? ' ($containerCode)' : ''}';
      final containerTile = ListTile(
        leading: Icon(iconData, color: textColor),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(containerName),
            if (isExited)
              ElevatedButton(
                onPressed: () => upContainer(containerName),
                child: Text('Start'),
              ),
          ],
        ),
        subtitle: Text(statusText),
      );

      return containerTile;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Docker Container Status'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          children: containerWidgets,
        ),
      ),
    );
  }
}