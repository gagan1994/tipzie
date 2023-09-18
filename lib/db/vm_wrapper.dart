import 'dart:io';

import 'package:path_provider/path_provider.dart';

class VMWrapper {
  Future<File> getSharedJsonFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/${this.runtimeType}.json');
    return file;
  }

  Future<File> getSharedTextFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/${this.runtimeType}.txt');
    return file;
  }
}
