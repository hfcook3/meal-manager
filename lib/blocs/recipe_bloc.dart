import 'package:bloc/bloc.dart';
import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/models/recipe_model.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/repositories/recipe_repository.dart';
import 'blocs.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc({@required this.recipeRepository})
      : assert(recipeRepository != null),
        super(null);

  @override
  RecipeState get initialState => RecipeLoading();

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is InitializeNewRecipeEvent) {
      yield* _mapInitializeNewRecipeEvent(event);
    }
    if (event is GetFullRecipeEvent) {
      yield* _mapGetFullRecipeEvent(event);
    }
    if (event is AddIngredientEvent) {
      yield* _mapAddIngredientEvent(event);
    }
    if (event is RemoveIngredientEvent) {
      yield* _mapRemoveIngredientEvent(event);
    }
    if (event is AddStepEvent) {
      yield* _mapAddStepEvent(event);
    }
    if (event is RemoveStepEvent) {
      yield* _mapRemoveStepEvent(event);
    }
  }

  Stream<RecipeState> _mapInitializeNewRecipeEvent(event) async* {
    var recipe = new Recipe();
    recipe.ingredients = new List<Ingredient>();
    recipe.steps = new List<String>();

    yield RecipeLoaded(recipe: recipe);
  }

  Stream<RecipeState> _mapGetFullRecipeEvent(GetFullRecipeEvent event) async* {
    yield RecipeLoading();

    try {
      final fullRecipe = await recipeRepository.getFullRecipe(event.recipe);
      yield RecipeLoaded(recipe: fullRecipe);
    } catch (_) {
      yield RecipeError();
    }
  }

  Stream<RecipeState> _mapAddIngredientEvent(AddIngredientEvent event) async* {
    yield RecipeLoading();

    try {
      var recipe = event.recipe;
      recipe.ingredients.add(event.ingredient);
      yield RecipeLoaded(recipe: recipe);
    } catch (_) {
      yield RecipeError();
    }
  }

  Stream<RecipeState> _mapRemoveIngredientEvent(
      RemoveIngredientEvent event) async* {
    yield RecipeLoading();

    try {
      var recipe = event.recipe;
      recipe.ingredients.removeAt(event.ingredientIndex);
      yield RecipeLoaded(recipe: recipe);
    } catch (_) {
      yield RecipeError();
    }
  }

  Stream<RecipeState> _mapAddStepEvent(AddStepEvent event) async* {
    yield RecipeLoading();

    try {
      var recipe = event.recipe;
      recipe.steps.add(event.step);
      yield RecipeLoaded(recipe: recipe);
    } catch (_) {
      yield RecipeError();
    }
  }

  Stream<RecipeState> _mapRemoveStepEvent(RemoveStepEvent event) async* {
    yield RecipeLoading();

    try {
      var recipe = event.recipe;
      recipe.steps.removeAt(event.stepIndex);
      yield RecipeLoaded(recipe: recipe);
    } catch (_) {
      yield RecipeError();
    }
  }
}
