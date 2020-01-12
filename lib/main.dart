import 'package:flutter/material.dart';
import 'recipe_model.dart';

void main() => runApp(MealManager());

class MealManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MealList(),
    );
  }
}

class MealListState extends State<MealList> {
  final List<Recipe> _recipeList = <Recipe>[
    new Recipe('Tomato Soup', new List<String>(), new List<String>()),
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
    return ListTile(title: Center(child: Text(recipe.title)));
  }
}

class MealList extends StatefulWidget {
  @override
  MealListState createState() => MealListState();
}
