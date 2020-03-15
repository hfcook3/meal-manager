import 'package:flutter/material.dart';
import 'package:mealmanager/recipe_form.dart';
import 'package:mealmanager/repositories/recipe_sql_client.dart';

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
            builder: (context) => RecipeFormHome(new Recipe())));

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
