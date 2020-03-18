import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealmanager/models/models.dart';

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
