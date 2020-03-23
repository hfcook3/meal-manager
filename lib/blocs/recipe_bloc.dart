import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/repositories/recipe_repository.dart';
import 'blocs.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc({@required this.recipeRepository})
      : assert(recipeRepository != null);

  @override
  RecipeState get initialState => RecipeLoading();

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is GetFullRecipeEvent) {
      _mapGetFullRecipeEvent(event);
    }
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
}
