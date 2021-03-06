import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealmanager/widgets/widgets.dart';

import 'recipe_list_view.dart';

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
      initialRoute: '/recipes',
      routes: {
        '/recipes': (context) => RecipeListView(),
        '/groceries': (context) => GroceryListHub()
      },
    );
  }
}
