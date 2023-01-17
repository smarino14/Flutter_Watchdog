import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:process_run/process_run.dart';


Future<Map<String, dynamic>> checkContainer(String cmd) async {
    var process = await Process.run(cmd, []);
    var output = process.stdout as String;
    var containerList = <String>[];
    var statusList = <String>[];
    var codeList = <String>[];

    for (var container in output.split("\n")) {
        var data = container.split(" ");

        containerList.add(data[0]);
        statusList.add(data[1]);
        if (data[1] == "Restarting" || data[1] == "Exited") {
            var code = data[2].replaceAll("(", "").replaceAll(")", "");
            codeList.add(code);
        } else {
            codeList.add("0");
        }
    }

    var ct = DateTime.now();
    var containerData = Map<String, dynamic>.fromIterables(containerList, List<dynamic>.from(List.generate(containerList.length, (i) => [statusList[i], codeList[i]])));
    containerData["TimeStamp"] = formatDate(ct, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    return containerData;
}

Future<Process> popenCommand(String cmd) async {
    var process = await Process.start(cmd, []);
    return process;
}

Map<String, dynamic> separateStats(List<String> stats) {
    var containers = <String, dynamic>{};
    for (var line in stats.sublist(1)) {
        line = line.replaceAll(" %", "%").replaceAll(" / ", "/").replaceAll("\n", "");
        var bits = line.split(" ");
        containers[bits[1]] = {
            "container": bits[0],
            "cpu": bits[2],
            "memory usage": bits[3],
            "memory %": bits[4],
            "network i/o": bits[5],
            "block i/o": bits[6],
            "pids": bits[7]
        };
    }
    return containers;
}

Map<String, dynamic> mergeDictionary(Map<String, dynamic> dict1, Map<String, dynamic> dict2) {
    var dict3 = Map<String, dynamic>.from(dict1)..addAll(dict2);
    for (var key in dict3.keys) {
        if (dict1.containsKey(key) && dict2.containsKey(key)) {
            dict3[key] = [dict3[key], dict1[key]];
        }
    }
    return dict3;
}