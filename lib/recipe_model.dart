class Recipe {
  int id;
  String title;
  List<String> ingredients;
  List<String> steps;

  Recipe();
  Recipe.withTitle(this.id, this.title);
  Recipe.withData(this.title, this.ingredients, this.steps);
}
