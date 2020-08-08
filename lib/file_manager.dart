import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter() async {
    final file = await _localFile;
    int counter = await readCounter();
    counter++;
    // Write the file
    return file.writeAsString('$counter');
  }
}
