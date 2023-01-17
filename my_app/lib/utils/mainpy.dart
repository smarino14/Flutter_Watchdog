import 'dart:io';
import 'dart:convert';
import 'package:my_app/utils/utils.dart';

Future<void> checkAndPrintContainerStatus() async {

  const KCmdRestarting = 'docker ps -f status=restarting --format "{{.Names}} {{.Status}}"';
  const KCmdRunning = 'docker ps -f status=running --format "{{.Names}} {{.Status}}"';
  const KCmdExit = 'docker ps -f status=exited --format "{{.Names}} {{.Status}}"';
  const KCmdStatus = 'docker ps --format "{{.Names}} {{.Status}}"';
  const KCmdStats = 'docker stats';
  const KCmdDockerHost="export DOCKER_HOST";
  const KWorkAddres="/home/antachua/stadia/services-cluster/";
  const KWorkAddres1="/home/sebastian/antac/stadia/services-cluster/";
  const KCmdUpCont="docker-compose -f " + KWorkAddres + "docker-compose.yml -f " + "/docker_config/develop/sebastian-paths-romelio.yml up ";
  const KCmdUpCont1="docker compose -f " + KWorkAddres1 + "docker-compose.yml -f " + KWorkAddres1 +  "/docker_config/develop/sebastianHome-paths-romelio.yml up ";
  const KCmdDockStats="docker stats --no-stream";
  const KcCmdUpRomelio= KCmdUpCont1+"romelio";

  bool isRomelioDown = false;
  bool setAutoRestart = false;
  String romelioState = "no init";

  while (true) {
    // Check status of container
    try {
      var containerState = await checkContainer(KCmdRunning);
      var romelioState = containerState["romelio"][0];
      var romelioCode = containerState["romelio"][1];
      var timeStamp = containerState["TimeStamp"];
    } catch (e) {
      var containerState = await checkContainer(KCmdExit);
      var romelioState = containerState["romelio"][0];
      var romelioCode = containerState["romelio"][1];
      var timeStamp = containerState["TimeStamp"];
    }

    // Check stats of container
    var dockerStats = await popenCommand(kCmdDockStats);
    var containerStats = separateStats(dockerStats.stdout.readlines());

    // Print state
    if (romelioState == "Restarting") {
      romelioState = containerState["TimeStamp"];
      print("Romelio cayo con el codigo: " +
          romelioCode +
          " y se esta reinicando");
    } else if (romelioState == "Up") {
      print("Romelio esta corriendo con el codigo: " + romelioCode);
      isRomelioDown = false;
    } else if (romelioState == "Exited") {
      print("Romelio cayo con el codigo " + romelioCode);
      isRomelioDown = true;
    }

    if (setAutoRestart && isRomelioDown) {
      await Future.delayed(Duration(seconds: 1));
      var dockerStats = await popenCommand(kcCmdUpRomelio);
    }

    var merged = mergeDictionary(containerState, containerStats);
    print(containerState);
    // print(containerStats);
    print(merged);
    await Future.delayed(Duration(seconds: 2));
  }
}


