import 'package:mealmanager/repositories/recipe_sql_client.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';

class RecipeRepository {
  final RecipeSqlClient recipeSqlClient;

  RecipeRepository({@required this.recipeSqlClient})
      : assert(recipeSqlClient != null);

  Future<List<Recipe>> getRecipes() async {
    return await recipeSqlClient.getRecipes();
  }

  Future<Recipe> getFullRecipe(Recipe recipe) async {
    return await recipeSqlClient.getFullRecipe(recipe);
  }

  Future<void> addRecipe(Recipe recipe) async {
    return await recipeSqlClient.insertRecipe(recipe);
  }

  Future<void> editRecipe(Recipe recipe) async {
    return await recipeSqlClient.updateRecipe(recipe);
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    return await recipeSqlClient.deleteRecipe(recipe);
  }
}
