import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:process_run/process_run.dart';


Future<Map<String, dynamic>> checkContainerRunning(String cmd) async {
  var process = await Process.run('docker', ['ps', '-f', 'status=running', '--format', '{{.Names}} {{.Status}}']);
  if (process.exitCode != 0) {
    print('Error executing command: ${process.stderr}');
    // return null;
  }
  var output = process.stdout as String;

  var process_exit = await Process.run('docker', ['ps', '-f', 'status=exited', '--format', '{{.Names}} {{.Status}}']);
  if (process_exit.exitCode != 0) {
    print('Error executing command: ${process.stderr}');
    // return null;
  }
  var output_2 = process_exit.stdout as String;

  var containerList = <String>[];
  var statusList = <String>[];
  var codeList = <String>[];

  for (var container in (output + output_2).split("\n")) {
    var data = container.split(" ");

    if (data.length < 2) {
      continue;
    }
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
  var containerData = Map<String, dynamic>.fromIterables(containerList,
      List<dynamic>.from(List.generate(containerList.length,
          (i) => [statusList[i], codeList[i]])));

  print(containerData);
  return containerData;
}

Future<Process> popenCommand(String cmd) async {
    var process = await Process.start(cmd, []);
    return process;
}

Future<void> upContainer(String containerName) async {
  final command = 'docker-compose -f /home/antachua/stadia/services-cluster/docker-compose.yml -f /home/antachua/stadia/services-cluster/docker_config/develop/sebastian-paths-romelio.yml up $containerName';

  final process = await Process.run('sh', ['-c', command]);
  if (process.exitCode != 0) {
    print('Error executing command: ${process.stderr}');
  } else {
    print('Container $containerName is up and running.');
  }
}

Future<Map<String, dynamic>> separateStats() async{

  var stats_process = await Process.run('docker', ['stats', '--no-stream']); 
  var cmd_output = stats_process.stdout as String; 
  var stats = cmd_output.split('\n');
  
  var containers = <String, dynamic>{};
  var lines = stats.sublist(1, stats.length - 1); // exclude the first and last lines
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    line = line.replaceAll(" %", "%").replaceAll(" / ", "/").replaceAll("\n", "");
    print(line);
    var bits = line.split(RegExp(r'\s+'));
    print(bits[1]);
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
  print(containers);
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