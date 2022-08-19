import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/deadpeople.dart';

const deadListKey = 'dead_list';

class DeadRepository {
  late SharedPreferences sharedPreferences;

  Future<List<DeadPeople>> getDeadList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(deadListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => DeadPeople.fromJson(e)).toList();
  }

  void saveDeadList(List<DeadPeople> dead) {
    final JsonString = json.encode(dead);
    sharedPreferences.setString(deadListKey, JsonString);
  }
}
