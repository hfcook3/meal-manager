import 'package:flutter/material.dart';
import 'recipe_model.dart';

void main() => runApp(MealManager());

class MealManager extends StatelessWidget {
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
  final List<Recipe> _recipeList = <Recipe>[
    new Recipe('Tomato Soup', ['Tomatoes', 'Garlic', 'Cream'],
        ['Chop garlic', 'Blend tomatoes', 'Put in pot']),
    new Recipe('Sushi', new List<String>(), new List<String>()),
    new Recipe('Lamb Meatballs', new List<String>(), new List<String>()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meal Manager'),
        ),
        body: _buildRecipes());
  }

  Widget _buildRecipes() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _recipeList.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider(
            thickness: 2.0,
          );
        } else {
          return _buildRecipeTile(_recipeList[i ~/ 2]);
        }
      },
    );
  }

  Widget _buildRecipeTile(Recipe recipe) {
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
