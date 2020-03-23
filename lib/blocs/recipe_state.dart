import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/recipe_model.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeEmpty extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final Recipe recipe;

  const RecipeLoaded({@required this.recipe}) : assert(recipe != null);

  @override
  List<Object> get props => [recipe];
}

class RecipeError extends RecipeState {}
