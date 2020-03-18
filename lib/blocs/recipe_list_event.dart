import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';

abstract class RecipeListEvent extends Equatable {
  const RecipeListEvent();
}

class GetRecipeListEvent extends RecipeListEvent {
  const GetRecipeListEvent();

  @override
  List<Object> get props => [];
}

class AddRecipeEvent extends RecipeListEvent {
  final Recipe recipe;

  const AddRecipeEvent({@required this.recipe}) : assert(recipe != null);

  @override
  List<Object> get props => [recipe];
}

class EditRecipeEvent extends RecipeListEvent {
  final Recipe recipe;

  const EditRecipeEvent({@required this.recipe}) : assert(recipe != null);

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipeEvent extends RecipeListEvent {
  final Recipe recipe;

  const DeleteRecipeEvent({@required this.recipe}) : assert(recipe != null);

  @override
  List<Object> get props => [recipe];
}
