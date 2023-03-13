import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_app/utils/utils.dart';

class DockerStatsPage extends StatefulWidget {
  DockerStatsPage({Key? key}) : super(key: key);

  @override
  _DockerStatsPageState createState() => _DockerStatsPageState();
}

class _DockerStatsPageState extends State<DockerStatsPage> {
  late Map<String, dynamic> _stats;
  late List<String> _containerNames;
  late String _selectedContainerName;
  late List<charts.Series<dynamic, num>> _cpuSeriesList;

  Future<void> _getStats() async {
    _stats = await separateStats();
    setState(() {
      _containerNames = _stats.keys.toList();
      _selectedContainerName = _containerNames.first;
      _cpuSeriesList = _createCpuSeriesList(_selectedContainerName);
    });
  }

  @override
  void initState() {
    super.initState();
    _getStats();
  }

List<charts.Series<num, num>> _createCpuSeriesList(String containerName) {
    final cpuData = _stats[containerName]['cpu'] as String;
    final cpuPercentage = double.parse(cpuData.substring(0, cpuData.length - 1));

    final data = <charts.Series<num, num>>[
      charts.Series<num, num>(
        id: 'CPU Usage',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (_, index) => index,
        measureFn: (cpu, _) => cpu as num,
        data: List.generate(10, (index) => cpuPercentage),
      )
    ];

    return data;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Docker Stats'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedContainerName,
            items: _containerNames
                .map((containerName) => DropdownMenuItem<String>(
                      value: containerName,
                      child: Text(containerName),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedContainerName = value!;
                _cpuSeriesList = _createCpuSeriesList(_selectedContainerName);
              });
            },
          ),
          Expanded(
            child: charts.LineChart(
              _cpuSeriesList,
              animate: true,
              domainAxis: charts.NumericAxisSpec(
                tickProviderSpec:
                    charts.BasicNumericTickProviderSpec(zeroBound: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
