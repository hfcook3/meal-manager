import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/blocs/recipe_list_state.dart';
import 'package:mealmanager/blocs/recipe_list_event.dart';
import 'package:mealmanager/repositories/recipe_repository.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final RecipeRepository recipeRepository;

  RecipeListBloc({@required this.recipeRepository})
      : assert(recipeRepository != null),
        super(null);

  @override
  RecipeListState get initialState => RecipeListEmpty();

  @override
  Stream<RecipeListState> mapEventToState(RecipeListEvent event) async* {
    if (event is GetRecipeListEvent) {
      yield* _mapGetRecipeListEvent(event);
    }

    if (event is AddRecipeEvent) {
      yield* _mapAddRecipeEvent(event);
    }

    if (event is EditRecipeEvent) {
      yield* _mapEditRecipeEvent(event);
    }

    if (event is DeleteRecipeEvent) {
      yield* _mapDeleteRecipeEvent(event);
    }
  }

  Stream<RecipeListState> _mapGetRecipeListEvent(
      GetRecipeListEvent event) async* {
    yield RecipeListLoading();

    try {
      final recipes = await recipeRepository.getRecipes();
      yield RecipeListLoaded(recipeList: recipes);
    } catch (_) {
      yield RecipeListError();
    }
  }

  Stream<RecipeListState> _mapAddRecipeEvent(AddRecipeEvent event) async* {
    yield RecipeListLoading();

    try {
      recipeRepository.addRecipe(event.recipe);
      final recipes = await recipeRepository.getRecipes();
      yield RecipeListLoaded(recipeList: recipes);
    } catch (_) {
      yield RecipeListError();
    }
  }

  Stream<RecipeListState> _mapEditRecipeEvent(EditRecipeEvent event) async* {
    yield RecipeListLoading();

    try {
      recipeRepository.editRecipe(event.recipe);
      final recipes = await recipeRepository.getRecipes();
      yield RecipeListLoaded(recipeList: recipes);
    } catch (_) {
      yield RecipeListError();
    }
  }

  Stream<RecipeListState> _mapDeleteRecipeEvent(
      DeleteRecipeEvent event) async* {
    yield RecipeListLoading();

    try {
      recipeRepository.deleteRecipe(event.recipe);
      final recipes = await recipeRepository.getRecipes();
      yield RecipeListLoaded(recipeList: recipes);
    } catch (_) {
      yield RecipeListError();
    }
  }
}
