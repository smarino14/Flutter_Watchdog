import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'dart:math';


class RealTimeGraph extends StatefulWidget {
  @override
  _RealTimeGraphState createState() => _RealTimeGraphState();
}

class _RealTimeGraphState extends State<RealTimeGraph> {
  List<charts.Series<DataPoint, int>> _seriesList = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _seriesList = [];
    _seriesList = _createRandomData();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seriesList = _createRandomData();
        _counter++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: charts.LineChart(_seriesList,
        defaultRenderer: charts.LineRendererConfig(
            includePoints: true,
            includeArea: true,
            stacked: true
        ),
        animate: false,
      ),
    );
  }

  List<charts.Series<DataPoint, int>> _createRandomData() {
    final data = [
      DataPoint(_counter, Random().nextInt(100)),
    ];
    return [
      charts.Series<DataPoint, int>(
        id: 'Data',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint dataPoint, _) => dataPoint.time,
        measureFn: (DataPoint dataPoint, _) => dataPoint.value,
        data: data,
      )
    ];
  }
}

class DataPoint {
  final int time;
  final int value;

  DataPoint(this.time, this.value);
}