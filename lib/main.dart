import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mealmanager/blocs/blocs.dart';
import 'package:mealmanager/repositories/recipe_repository.dart';
import 'package:mealmanager/SimpleBlocDelegate.dart';
import 'package:mealmanager/repositories/recipe_sql_client.dart';
import 'package:mealmanager/widgets/meal_manager.dart';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final RecipeRepository recipeRepository =
      RecipeRepository(recipeSqlClient: new RecipeSqlClient());

  WidgetsFlutterBinding.ensureInitialized();
  await recipeRepository.recipeSqlClient.initDb();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<RecipeListBloc>(
        create: (context) =>
            RecipeListBloc(recipeRepository: recipeRepository)),
    BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc(recipeRepository: recipeRepository)),
  ], child: MealManager()));
}
