import 'dart:ffi';
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
        home: RecipeList());
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

    database = await openDatabase(
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
    _recipeList = await recipes();
    setState(() {});
  }

  Future<List<Recipe>> recipes() async {
    List<Map<String, dynamic>> recipes;
    try {
      recipes = await database.rawQuery('SELECT id, title FROM Recipes');
    } on Exception catch (e) {
      debugPrint('An error occurred when retrieving recipes from DB: $e');
      return new List<Recipe>();
    }

    return List.generate(recipes.length, (i) {
      return Recipe.withTitle(recipes[i]['id'], recipes[i]['title']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Manager'),
      ),
      body: _buildRecipes(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          List<Recipe> list = await _navigateAndGetResult(context);
          setState(() {
            _recipeList = list;
          });
        },
      ),
    );
  }

  Future<List<Recipe>> _navigateAndGetResult(BuildContext context) async {
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => RecipeFormHome(new Recipe())));

    if (result != null) {
      return await recipes();
    } else {
      return _recipeList;
    }
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
        trailing: PopupMenuButton<String>(
            onSelected: (String result) async {
              switch (result) {
                case 'Delete':
                  {
                    _deleteRecipe(recipe);
                  }
                  break;
                case 'Edit':
                  {
                    var fullRecipe = await _getFullRecipe(recipe);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeFormHome(fullRecipe)));
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext buildContext) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'Edit', child: Text('Edit'))
                ]),
        onTap: () async {
          var fullRecipe = await _getFullRecipe(recipe);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeView(
                        recipe: fullRecipe,
                      )));
        });
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    await database.rawDelete('DELETE FROM Recipes WHERE id = ?', [recipe.id]);
    await database
        .rawDelete('DELETE FROM Ingredients WHERE id = ?', [recipe.id]);
    await database.rawDelete('DELETE FROM Steps WHERE id = ?', [recipe.id]);

    var updatedRecipes = await recipes();
    setState(() {
      _recipeList = updatedRecipes;
    });
  }

  Future<Recipe> _getFullRecipe(Recipe recipe) async {
    var ingredientsData = await database
        .rawQuery('SELECT * FROM Ingredients WHERE recipeKey = ?', [recipe.id]);
    var ingredients = List.generate(ingredientsData.length, (i) {
      return ingredientsData[i]['ingredient'].toString();
    });

    var stepsData = await database
        .rawQuery('SELECT * FROM Steps WHERE recipeKey = ?', [recipe.id]);
    var steps = List.generate(stepsData.length, (i) {
      return stepsData[i]['step'].toString();
    });

    return Recipe.withData(recipe.id, recipe.title, ingredients, steps);
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
      body: ListView(padding: EdgeInsets.all(12.0), children: [
        Text(
          recipe.title,
          style: TextStyle(fontSize: 40.0),
          textAlign: TextAlign.left,
        ),
        Divider(
          thickness: 2.0,
        ),
        Text(
          'Ingredients',
          style: TextStyle(fontSize: 32.0),
          textAlign: TextAlign.left,
        ),
        Column(
          children: List.generate(recipe.ingredients.length, (i) {
            return Row(children: <Widget>[
              Icon(Icons.arrow_right),
              Text(
                recipe.ingredients[i],
                style: TextStyle(fontSize: 20.0),
              )
            ]);
          }),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Steps',
          style: TextStyle(fontSize: 32.0),
          textAlign: TextAlign.left,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(recipe.steps.length, (i) {
            return Text(
              "${i + 1}.  ${recipe.steps[i]}",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20.0),
            );
          }),
        ),
      ]),
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
