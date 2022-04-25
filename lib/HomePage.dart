// import 'package:flutter/material.dart';

// import 'dart:html';

// import 'dart:html';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'counterStorage.dart';
import 'dart:io';
import 'dart:typed_data';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // final CounterStorage storage;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer player = AudioPlayer();
  AudioPlayer player1 = AudioPlayer();

  AudioCache audioCache = AudioCache();
  // PlayerState audioPlayerState = PlayerState.PAUSED;

  PlayerState playerState = PlayerState.PAUSED;

  CounterStorage storage = CounterStorage();
  String url =
      'https://masstamilan2019download.com/tamil/2020%20Tamil%20Songs/Soorarai%20Pottru/Maara%20Theme-Masstamilan.In.mp3';
  int timeProgress = 0;
  int audioDuration = 0;

  @override
  void initState() {
    super.initState();
    //ConnectionUtil connectionStatus = ConnectionUtil.getInstance();
    musicplayer();
    musicplayerone();
    connectionchecker();
  }

  //this is slider
  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
        value: timeProgress.toDouble(),
        max: audioDuration.toDouble(),
        onChanged: (value) {
          seekTOSec(value.toInt());
        },
      ),
    );
  }

  seekTOSec(int sec) async {
    Duration newpos = Duration(seconds: sec);
    await connectionchecker();
    if (connectivity == ConnectionState.active) {
      player.seek(newpos);
    } else {
      player1.seek(newpos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Player')),
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //
          IconButton(
              onPressed: () {
                playerState == PlayerState.PLAYING ? pause() : play();
              },
              icon: Icon(playerState == PlayerState.PLAYING
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(getTimeString(timeProgress)),
              SizedBox(width: 20),
              Container(width: 200, child: slider()),
              SizedBox(width: 20),
              Text(getTimeString(audioDuration))
            ],
          ),
          IconButton(
              onPressed: () async {
                //print(connectivity == ConnectionState.active);
                // widget.storage.writeCounter()
                await connectionchecker();
                connectivity == ConnectionState.active ? download() : toast();
              },
              icon: Icon(connectivity == ConnectionState.active
                  ? Icons.download
                  : Icons.file_download_off))
        ]),
      ),
    );
  }

  toast() {
    return Fluttertoast.showToast(
        msg: 'Download is not Available While offline.',
        toastLength: Toast.LENGTH_SHORT);
  }

  ConnectionState connectivity = ConnectionState.active;
  connectionchecker() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      setState(() {
        connectivity = ConnectionState.active;
      });
    } else {
      setState(() {
        connectivity = ConnectionState.none;
      });
    }
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  musicplayerone() {
    player1.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });

    // player.setUrl(url);
    player1.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d.inSeconds;
      });
    });

    player1.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        timeProgress = d.inSeconds;
      });
    });
  }

  musicplayer() {
    player.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });

    player.setUrl(url);
    player.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d.inSeconds;
      });
    });

    player.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        timeProgress = d.inSeconds;
      });
    });
  }

  play() async {
    await connectionchecker();
    //print(result);

    if (connectivity == ConnectionState.active) {
      print('one');
      await player.play(url);
      musicplayer();
    } else {
      print('two');
      print(await storage.readCounter());
      musicplayerone();
      await player1.playBytes(await storage.readCounter());
    }
  }

  pause() async {
    if (connectivity == ConnectionState.active) {
      await player.pause();
    } else {
      await player1.pause();
    }
  }

  playLocal() async {
    print("come");
    // Uint8List s = Uint8List.fromList(byteData);
    // print(s); // Load audio as a byte array here.
  }

  // downloa() async {
  //   if (connectivity == ConnectionState.active) {
  //     await download();
  //   } else {
  //     await toast();
  //   }
  // }

  Future<Uint8List> download() async {
    Fluttertoast.showToast(
        msg: 'Downloading...', toastLength: Toast.LENGTH_SHORT);
    return await storage.writeCounter(url);
  }
}
