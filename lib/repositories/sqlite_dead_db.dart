import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String deadTable = "deadTable";
const String idColumn = "idColumn";
const String titleColumn = "titleColumn";
const String datetimeColumn = "datetimeColumn";

class DeadPeople {
  int id;
  String title;
  String datetime;

  DeadPeople({
    required this.id,
    required this.title,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'datetime': datetime,
    };
  }

  @override
  String toString() {
    return 'Dead{id: $id, name: $title, datetime: $datetime}';
  }
}

class DeadPeopleHelper {
  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'dead.db');
    return await openDatabase(path, version: 1,
        onCreate: ((Database db, int version) async {
      await db.execute(
          'CREATE TABLE $deadTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $datetimeColumn TEXT)');
    }));
  }

  Future<void> insertDead(DeadPeople deadPeople) async {
    final db = await initDb();
    await db.insert(
      'dead',
      deadPeople.toMap(),
    );
  }

  Future<List<DeadPeople>> findAll() async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query('dead');

    return List.generate(maps.length, (i) {
      return DeadPeople(
        id: maps[i]['id'],
        title: maps[i]['title'],
        datetime: maps[i]['datetime'],
      );
    });
  }

  Future<void> updateDead(DeadPeople deadPeople) async {
    final db = await initDb();
    await db.update(
      'dead',
      deadPeople.toMap(),
      where: 'id = ?',
      whereArgs: [deadPeople.id],
    );
  }

  Future<void> deleteDead(int id) async {
    final db = await initDb();
    await db.delete(
      'dead',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
