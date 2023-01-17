import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  final int rows;
  final int columns;

  FirstScreen({this.rows = 0, this.columns = 0});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _rowCount = 6;
  int _columnCount = 3;
  double _rowHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Table(
        defaultColumnWidth: FixedColumnWidth(100.0),
        children: List.generate(_rowCount, (rowIndex) {
          return TableRow(
            children: List.generate(_columnCount, (columnIndex) {
              return Container(
                height: _rowHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white)
                ),
                child: Center(
                  child: Text("Row $rowIndex, Column $columnIndex",
                    style: TextStyle(color: Colors.white))
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}