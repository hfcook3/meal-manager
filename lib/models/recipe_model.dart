import 'package:mealmanager/models/models.dart';

class Recipe {
  int id;
  String title;
  List<Ingredient> ingredients;
  List<String> steps;

  Recipe();
  Recipe.withTitle(this.id, this.title);
  Recipe.withData(this.id, this.title, this.ingredients, this.steps);
}
