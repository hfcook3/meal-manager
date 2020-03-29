import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:mealmanager/models/models.dart';

abstract class RecipeListState extends Equatable {
  const RecipeListState();

  @override
  List<Object> get props => [];
}

class RecipeListEmpty extends RecipeListState {}

class RecipeListLoading extends RecipeListState {}

class RecipeListLoaded extends RecipeListState {
  final List<Recipe> recipeList;

  const RecipeListLoaded({@required this.recipeList})
      : assert(recipeList != null);

  @override
  List<Object> get props => [recipeList];
}

class RecipeListError extends RecipeListState {}
