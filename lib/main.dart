import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealmanager/blocs/recipe_list_bloc.dart';
import 'package:mealmanager/repositories/recipe_repository.dart';

import 'SimpleBlocDelegate.dart';
import 'repositories/recipe_sql_client.dart';
import 'widgets/meal_manager.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final RecipeRepository recipeRepository =
      RecipeRepository(recipeSqlClient: new RecipeSqlClient());

  recipeRepository.recipeSqlClient.initDb();

  runApp(BlocProvider<RecipeListBloc>(
      create: (context) => RecipeListBloc(recipeRepository: recipeRepository),
      child: MealManager()));
}
