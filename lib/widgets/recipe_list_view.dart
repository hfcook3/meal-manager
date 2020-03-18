import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealmanager/models/recipe_model.dart';
import 'package:mealmanager/repositories/recipe_sql_client.dart';
import 'package:mealmanager/widgets/widgets.dart';

class RecipeListViewState extends State<RecipeListView> {
  RecipeSqlClient _recipeSqlClient;
  List<Recipe> _recipeList;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  Future<void> _initState() async {
    _recipeSqlClient = new RecipeSqlClient();
    await _recipeSqlClient.initDb();
    _recipeList = await _recipeSqlClient.getRecipes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Manager'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext buildContext) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem(value: 'Delete', child: Text('Delete'))
              ];
            },
          )
        ],
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
            builder: (context) =>
                RecipeFormHome(new Recipe(), _recipeSqlClient)));

    if (result != null) {
      return await _recipeSqlClient.getRecipes();
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
                    _recipeSqlClient.deleteRecipe(recipe);

                    var updatedRecipes = await _recipeSqlClient.getRecipes();
                    setState(() {
                      _recipeList = updatedRecipes;
                    });
                  }
                  break;
                case 'Edit':
                  {
                    var fullRecipe =
                        await _recipeSqlClient.getFullRecipe(recipe);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecipeFormHome(fullRecipe, _recipeSqlClient)));
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
          var fullRecipe = await _recipeSqlClient.getFullRecipe(recipe);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeView(
                        recipe: fullRecipe,
                      )));
        });
  }
}

class RecipeListView extends StatefulWidget {
  @override
  RecipeListViewState createState() => RecipeListViewState();
}
