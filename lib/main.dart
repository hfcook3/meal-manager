import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mealmanager/recipe_form.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'recipe_model.dart';

void main() => runApp(MealManager());

class MealManager extends StatefulWidget {
  @override
  MealManagerState createState() => MealManagerState();
}

class MealManagerState extends State<MealManager> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Meal Manager',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Home());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Manager'),
      ),
      body: RecipeList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecipeFormHome()));
        },
      ),
    );
  }
}

class RecipeListState extends State<RecipeList> {
  Database database;
  List<Recipe> _recipeList;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<void> _initState() async {
    var dbPath = await getDatabasesPath();
    await Directory(dbPath).create(recursive: true);

    database = await openDatabase(join(dbPath, 'meal_manager.db'));
    _recipeList = await recipes();
  }

  Future<List<Recipe>> recipes() async {
    List<Map<String, dynamic>> recipes;
    try {
      recipes = await database.query('recipes');
    } on Exception catch (e) {
      return new List<Recipe>();
    }

    return List.generate(recipes.length, (i) {
      return Recipe(
          recipes[i]['title'], recipes[i]['ingredients'], recipes[i]['steps']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildRecipes();
  }

  Widget _buildRecipes() {
    if (_recipeList == null || _recipeList.length == 0) {
      return Center(
        child: Text("No recipes found. Make some!"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _recipeList.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider(
            thickness: 2.0,
          );
        } else {
          return _buildRecipeTile(context, _recipeList[i ~/ 2]);
        }
      },
    );
  }

  Widget _buildRecipeTile(BuildContext context, Recipe recipe) {
    return ListTile(
        title: Center(child: Text(recipe.title)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeView(
                        recipe: recipe,
                      )));
        });
  }
}

class RecipeList extends StatefulWidget {
  @override
  RecipeListState createState() => RecipeListState();
}

class RecipeView extends StatelessWidget {
  final Recipe recipe;

  RecipeView({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Manager'),
      ),
      body: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(children: [
            Text(
              recipe.title,
              style: TextStyle(fontSize: 32.0),
            ),
            Divider(
              thickness: 2.0,
            ),
            Text(
              'Ingredients',
              style: TextStyle(fontSize: 24.0),
            ),
            ListView.builder(
              itemCount: recipe.ingredients.length,
              itemBuilder: (BuildContext context, int i) {
                return _buildIngredient(recipe.ingredients[i]);
              },
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
            ),
            Text(
              'Steps',
              style: TextStyle(fontSize: 24.0),
            ),
            ListView.builder(
              itemCount: recipe.steps.length,
              itemBuilder: (BuildContext context, int i) {
                return _buildStep(recipe.steps[i], i);
              },
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
            )
          ])),
    );
  }

  Widget _buildIngredient(String ingredient) {
    return ListTile(
      title: Center(child: Text(ingredient)),
    );
  }

  Widget _buildStep(String step, int i) {
    return ListTile(
      title: Center(child: Text('${i + 1}. $step')),
    );
  }
}
