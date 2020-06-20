import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
}

class InitializeNewRecipeEvent extends RecipeEvent {
  const InitializeNewRecipeEvent();

  @override
  List<Object> get props => [];
}

class GetFullRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const GetFullRecipeEvent({@required this.recipe}) : assert(recipe != null);

  @override
  List<Object> get props => [recipe];
}

class AddIngredientEvent extends RecipeEvent {
  final Recipe recipe;
  final String ingredient;

  const AddIngredientEvent({@required this.recipe, @required this.ingredient})
      : assert(recipe != null);

  @override
  List<Object> get props => [recipe, ingredient];
}

class RemoveIngredientEvent extends RecipeEvent {
  final Recipe recipe;
  final int ingredientIndex;

  const RemoveIngredientEvent(
      {@required this.recipe, @required this.ingredientIndex})
      : assert(recipe != null);

  @override
  List<Object> get props => [recipe, ingredientIndex];
}

class AddStepEvent extends RecipeEvent {
  final Recipe recipe;
  final String step;

  const AddStepEvent({@required this.recipe, @required this.step})
      : assert(recipe != null);

  @override
  List<Object> get props => [recipe, step];
}

class RemoveStepEvent extends RecipeEvent {
  final Recipe recipe;
  final int stepIndex;

  const RemoveStepEvent({@required this.recipe, @required this.stepIndex})
      : assert(recipe != null);

  @override
  List<Object> get props => [recipe, stepIndex];
}
