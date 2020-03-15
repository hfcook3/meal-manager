import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

import '../recipe_model.dart';

class RecipeSqlClient {
  Database _database;

  Future<void> initDb() async {
    var dbPath = await getDatabasesPath();
    await Directory(dbPath).create(recursive: true);

    _database = await openDatabase(
      join(dbPath, 'meal_manager.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Recipes(id INTEGER PRIMARY KEY, title TEXT)');
        await db.execute(
            'CREATE TABLE Ingredients(id INTEGER PRIMARY KEY, recipeKey INTEGER, ingredient TEXT, ' +
                'CONSTRAINT fk_recipes FOREIGN KEY (recipeKey) REFERENCES Recipes(id))');
        await db.execute(
            'CREATE TABLE Steps(id INTEGER PRIMARY KEY, recipeKey INTEGER, step TEXT, ' +
                'CONSTRAINT fk_recipes FOREIGN KEY (recipeKey) REFERENCES Recipes(id))');
      },
    );
  }

  Future<List<Recipe>> getRecipes() async {
    List<Map<String, dynamic>> recipes;
    try {
      recipes = await _database.rawQuery('SELECT id, title FROM Recipes');
    } on Exception catch (e) {
      debugPrint('An error occurred when retrieving recipes from DB: $e');
      return new List<Recipe>();
    }

    return List.generate(recipes.length, (i) {
      return Recipe.withTitle(recipes[i]['id'], recipes[i]['title']);
    });
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    await _database.rawDelete('DELETE FROM Recipes WHERE id = ?', [recipe.id]);
    await _database
        .rawDelete('DELETE FROM Ingredients WHERE recipeKey = ?', [recipe.id]);
    await _database
        .rawDelete('DELETE FROM Steps WHERE recipeKey = ?', [recipe.id]);
  }

  Future<Recipe> getFullRecipe(Recipe recipe) async {
    var ingredientsData = await _database
        .rawQuery('SELECT * FROM Ingredients WHERE recipeKey = ?', [recipe.id]);
    var ingredients = List.generate(ingredientsData.length, (i) {
      return ingredientsData[i]['ingredient'].toString();
    });

    var stepsData = await _database
        .rawQuery('SELECT * FROM Steps WHERE recipeKey = ?', [recipe.id]);
    var steps = List.generate(stepsData.length, (i) {
      return stepsData[i]['step'].toString();
    });

    return Recipe.withData(recipe.id, recipe.title, ingredients, steps);
  }
}
