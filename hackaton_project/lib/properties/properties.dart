import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class PropertyFile {
  static final PropertyFile _instance = PropertyFile._internal();

  factory PropertyFile() {
    return _instance;
  }

  dynamic jsonMap;

  PropertyFile._internal();

  Future<PropertyFile> loadPropertyFileSync() async {
    if (jsonMap == null) {
      String jsonString = await loadJsonString();
      jsonMap = jsonDecode(jsonString);
      // ignore: avoid_print
      print("[PROPERTIES] data loaded");
    }
    return this;
  }

  Future<String> loadJsonString() async {
    String jsonString =
        await rootBundle.loadString('assets/properties/my_config.json');
    return jsonString;
  }

  String getAttribute(String key) {
    return jsonMap[key];
  }
}
