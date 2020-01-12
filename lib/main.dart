import 'package:flutter/material.dart';

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
  final List<String> _recipeTitleList = <String>[
    'Black Bean Burritos',
    'Sushi',
    'Lamb Meatballs'
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
      itemCount: _recipeTitleList.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider(
            thickness: 2.0,
          );
        } else {
          return _buildRecipeTile(_recipeTitleList[i ~/ 2]);
        }
      },
    );
  }

  Widget _buildRecipeTile(String recipeTitle) {
    return ListTile(title: Center(child: Text(recipeTitle)));
  }
}

class MealList extends StatefulWidget {
  @override
  MealListState createState() => MealListState();
}
