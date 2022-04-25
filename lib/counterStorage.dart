import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final name = 'image';
    return File('$path/counter');
  }

  Future<Uint8List> readCounter() async {
    // try {
    final file = await _localFile;
    print("came");
    // Read the file
    final contents = await file.readAsBytes();
    print(contents);
    print('yes');
    return contents;
    // } catch (e) {
    //   Uint8List? bytes = [5, 4];
    //   print(e); // If encountering an error, return 0
    //   return e.;
    // }
  }

  Future<Uint8List> writeCounter(String u) async {
    final name = '/image';
    print('Came');
    Response response = await Client().get(
      Uri.parse(u),
    );

    Uint8List bytes = response.bodyBytes;
    File file = await _localFile;
    // file = file.path + name;
    await file.writeAsBytes(bytes);

    print(file);
    print(bytes);

    return bytes;
  }
}
