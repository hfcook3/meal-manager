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

    _database = await openDatabase(join(dbPath, 'meal_manager_groceries.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE GroceryLists(id INTEGER PRIMARY KEY, name TEXT, dateAdded INTEGER)');
      await db.execute(
          'CREATE TABLE GroceryItems(id INTEGER PRIMARY KEY, item TEXT, category TEXT, listKey INTEGER, checked BIT, ' +
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
      return GroceryList.withMeta(
          groceryLists[i]['id'],
          groceryLists[i]['name'],
          DateTime.fromMillisecondsSinceEpoch(groceryLists[i]['dateAdded'])
              .toLocal());
    });
  }

  Future<GroceryList> getFullGroceryList(int groceryListId) async {
    List<Map<String, dynamic>> groceryLists;
    List<Map<String, dynamic>> groceryItems;

    try {
      groceryLists = await _database
          .rawQuery('SELECT * FROM GroceryLists WHERE id = ?', [groceryListId]);
      groceryItems = await _database.rawQuery(
          'SELECT * FROM GroceryItems WHERE listKey = ?', [groceryListId]);
    } on Exception catch (e) {
      debugPrint('An error occurred when retrieving grocery lists from DB: $e');
      return GroceryList();
    }
    var groceryList = new GroceryList.withMeta(
        groceryListId,
        groceryLists[0]['name'],
        DateTime.fromMillisecondsSinceEpoch(groceryLists[0]['dateAdded'])
            .toLocal());

    List<GroceryItem> generatedItems = List.generate(groceryItems.length, (i) {
      return GroceryItem.withData(
          groceryItems[i]['id'],
          groceryItems[i]['item'] ?? "",
          groceryItems[i]['category'] ?? "",
          groceryItems[i]['checked'] == 1);
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
      var newId = await _database.rawInsert(
          'INSERT INTO GroceryLists(name, dateAdded) VALUES (?, ?)', [
        groceryList.name,
        groceryList.dateAdded.toUtc().millisecondsSinceEpoch
      ]);

      groceryList.id = newId;
      await insertGroceryItems(groceryList, groceryList.items);
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
            'INSERT INTO GroceryItems(item, category, checked, listKey) VALUES (?, ?, ?, ?)',
            [
              groceryItems[i].item,
              groceryItems[i].category,
              false,
              groceryList.id
            ]);
      } on Exception catch (e) {
        debugPrint(
            'An error occurred when inserting a grocery item into the DB: $e');
      }
    }
  }

  Future<void> updateGroceryList(GroceryList groceryList) async {
    try {
      await _database.execute(
          'UPDATE GroceryLists SET name = ?, dateAdded = ? WHERE id = ?', [
        groceryList.name,
        groceryList.dateAdded.toUtc().millisecondsSinceEpoch,
        groceryList.id
      ]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when updating a grocery list in the DB: $e');
    }

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
            'INSERT INTO GroceryItems(item, category, checked, listKey) VALUES (?, ?, ?, ?)',
            [
              groceryList.items[i].item ?? "",
              groceryList.items[i].category ?? "",
              groceryList.items[i].checked ?? false,
              groceryList.id
            ]);
      } on Exception catch (e) {
        debugPrint(
            'An error occurred when inserting a grocery item into the DB: $e');
      }
    }
  }

  Future<GroceryItem> getGroceryItem(int itemId) async {
    List<Map<String, dynamic>> results;
    try {
      results = await _database
          .rawQuery('SELECT * FROM GroceryItems WHERE id = ?', [itemId]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when inserting a grocery item into the DB: $e');
    }

    return GroceryItem.withData(results[0]['id'], results[0]['item'] ?? "",
        results[0]['category'] ?? "", results[0]['checked'] == 1);
  }

  Future<void> insertNewGroceryItem(GroceryItem groceryItem, int listId) async {
    try {
      await _database.execute(
          'INSERT INTO GroceryItems(item, category, checked, listKey) VALUES (?, ?, ?, ?)',
          [
            groceryItem.item ?? "",
            groceryItem.category ?? "",
            groceryItem.checked ?? false,
            listId
          ]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when inserting a grocery item into the DB: $e');
    }
  }

  Future<void> updateGroceryItem(GroceryItem groceryItem) async {
    try {
      await _database.execute(
          'UPDATE GroceryItems SET item = ?, category = ?, checked = ? WHERE id = ?',
          [
            groceryItem.item ?? "",
            groceryItem.category ?? "",
            groceryItem.checked ?? false,
            groceryItem.id
          ]);
    } on Exception catch (e) {
      debugPrint(
          'An error occurred when inserting a grocery item into the DB: $e');
    }
  }
}
