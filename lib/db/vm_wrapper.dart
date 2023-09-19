import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class VMWrapper {
  Future<File> getSharedJsonFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/${this.runtimeType}.json');
    var fileExist = await file.exists();
    if (!fileExist) {
      await file.create();
      Map<String, dynamic> keyVal = Map<String, dynamic>();
      await file.writeAsString(jsonEncode(keyVal));
    }
    return file;
  }

  void saveData(String key, dynamic data) async {
    print("saving shared file: $key :${data.toString()}");
    var shared = await getSharedJsonFile();
    var fileData = await shared.readAsString();
    Map<String, dynamic> keyVal = jsonDecode(fileData);
    keyVal.putIfAbsent(key, () => data);
    await shared.writeAsString(jsonEncode(keyVal));
  }

  Future<dynamic> getJsonData(String key) async {
    var shared = await getSharedJsonFile();
    var data = await shared.readAsString();
    print('current shared data: ' + data);
    Map<String, dynamic> keyVal = jsonDecode(data);
    return keyVal[key];
  }

  Future<File> getSharedTextFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/${this.runtimeType}.txt');
    return file;
  }
}
