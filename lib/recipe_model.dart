class Recipe {
  String title;
  List<String> ingredients;
  List<String> steps;

  Recipe();
  Recipe.withData(this.title, this.ingredients, this.steps);
}
