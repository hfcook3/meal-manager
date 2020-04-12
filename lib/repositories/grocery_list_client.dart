import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class GroceryListSqlClient {
  Database _database;

  Future<void> initDb() async {
    var dbPath = await getDatabasesPath();
    await Directory(dbPath).create(recursive: true);

    _database = await openDatabase(join(dbPath, 'meal_manager.db'), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE GroceryLists(id INTEGER PRIMARY KEY, name TEXT, dateAdded DATETIME)');
      await db.execute(
          'CREATE TABLE GroceryItems(id INTEGER PRIMARY KEY, item TEXT, category TEXT, ' +
              'CONSTRAINT fk_lists FOREIGN KEY (listKey) REFERENCES GroceryLists(id))');
    });
  }

  Future<List<GroceryList>> getGroceryLists() async {
    List<Map<String, dynamic>> groceryLists;

    try {
      groceryLists = await _database.rawQuery('SELECT * FROM GroceryLists');
    } on Exception catch (e) {
      debugPrint('An error occurred when retrieving grocery lists from DB: $e');
      return new List<GroceryList>();
    }

    return List.generate(groceryLists.length, (i) {
      return GroceryList.withMeta(groceryLists[i]['id'],
          groceryLists[i]['name'], groceryLists[i]['dateAdded']);
    });
  }

  Future<GroceryList> getFullGroceryList(GroceryList groceryList) async {
    List<Map<String, dynamic>> groceryItems;

    try {
      groceryItems = await _database.rawQuery(
          'SELECT * FROM GroceryItems WHERE listKey = ?', [groceryList.id]);
    } on Exception catch (e) {
      debugPrint('An error occurred when retrieving grocery lists from DB: $e');
      return GroceryList();
    }

    List<GroceryItem> generatedItems = List.generate(groceryItems.length, (i) {
      return GroceryItem.withData(groceryItems[i]['id'],
          groceryItems[i]['item'], groceryItems[i]['category']);
    });

    groceryList.items = generatedItems;

    return groceryList;
  }

  Future<void> deleteGroceryList(GroceryList groceryList) async {
    try {
      await _database.execute(
          'DELETE FROM GroceryItems WHERE listKey = ?', [groceryList.id]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when deleting a grocery list from the DB: $e');
    }

    try {
      await _database
          .execute('DELETE FROM GroceryLists WHERE id = ?', [groceryList.id]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when deleting a grocery list from the DB: $e');
    }
  }

  Future<void> insertGroceryList(GroceryList groceryList) async {
    try {
      await _database.execute(
          'INSERT INTO GroceryLists(name TEXT, dateAdded DATETIME) VALUES (?, ?)',
          [groceryList.name, groceryList.dateAdded]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when inserting a grocery list into the DB: $e');
    }
  }

  Future<void> insertGroceryItems(
      GroceryList groceryList, List<GroceryItem> groceryItems) async {
    for (int i = 0; i < groceryItems.length; i++) {
      try {
        await _database.execute(
            'INSERT INTO GroceryItems(item TEXT, category TEXT, listKey INTEGER) VALUES (?, ?, ?)',
            [
              groceryList.items[i].item,
              groceryList.items[i].category,
              groceryList.id
            ]);
      } on Exception catch (e) {
        debugPrint(
            'An error occurred when inserting a grocery item into the DB: $e');
      }
    }
  }

  Future<void> updateGroceryItems(GroceryList groceryList) async {
    try {
      await _database.execute(
          'DELETE FROM GroceryItems WHERE listKey = ?', [groceryList.id]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when deleting grocery items from the DB: $e');
    }

    for (int i = 0; i < groceryList.items.length; i++) {
      try {
        await _database.execute(
            'INSERT INTO GroceryItems(item TEXT, category TEXT, listKey INTEGER) VALUES (?, ?, ?)',
            [
              groceryList.items[i].item,
              groceryList.items[i].category,
              groceryList.id
            ]);
      } on Exception catch (e) {
        debugPrint(
            'An error occurred when inserting a grocery item into the DB: $e');
      }
    }
  }
}