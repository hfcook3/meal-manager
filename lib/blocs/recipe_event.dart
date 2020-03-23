import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
}

class GetFullRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const GetFullRecipeEvent({@required this.recipe}) : assert(recipe != null);

  @override
  List<Object> get props => [recipe];
}
