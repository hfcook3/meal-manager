import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mealmanager/blocs/blocs.dart';
import 'package:mealmanager/repositories/grocery_list_client.dart';
import 'package:mealmanager/repositories/grocery_list_repository.dart';
import 'package:mealmanager/repositories/recipe_sql_client.dart';
import 'package:mealmanager/repositories/recipe_repository.dart';
import 'package:mealmanager/widgets/meal_manager.dart';

void main() async {
  final RecipeRepository recipeRepository =
      RecipeRepository(recipeSqlClient: new RecipeSqlClient());

  final GroceryListRepository groceryListRepository =
      GroceryListRepository(grocerySqlClient: new GroceryListSqlClient());

  WidgetsFlutterBinding.ensureInitialized();
  await recipeRepository.recipeSqlClient.initDb();
  await groceryListRepository.grocerySqlClient.initDb();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<RecipeListBloc>(
        create: (context) =>
            RecipeListBloc(recipeRepository: recipeRepository)),
    BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc(recipeRepository: recipeRepository)),
    BlocProvider<GroceryHubBloc>(
        create: (context) =>
            GroceryHubBloc(groceryListRepository: groceryListRepository)),
    BlocProvider<GroceryListBloc>(
        create: (context) =>
            GroceryListBloc(groceryListRepository: groceryListRepository)),
  ], child: MealManager()));
}
