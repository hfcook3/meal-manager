import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/blocs/blocs.dart';
import 'package:mealmanager/repositories/grocery_list_repository.dart';

class GroceryHubBloc extends Bloc<GroceryHubEvent, GroceryHubState> {
  final GroceryListRepository groceryListRepository;

  GroceryHubBloc({@required this.groceryListRepository})
      : assert(groceryListRepository != null),
        super(null);

  @override
  GroceryHubState get initialState => GroceryHubEmpty();

  @override
  Stream<GroceryHubState> mapEventToState(GroceryHubEvent event) async* {
    if (event is GetGroceryListsEvent) {
      yield* _mapGetGroceryListsEvent(event);
    }
    if (event is DeleteGroceryListEvent) {
      yield* _mapDeleteGroceryListEvent(event);
    }
    if (event is AddGroceryListEvent) {
      yield* _mapAddGroceryListEvent(event);
    }
  }

  Stream<GroceryHubState> _mapGetGroceryListsEvent(
      GetGroceryListsEvent event) async* {
    yield GroceryHubLoading();

    try {
      final groceryLists = await groceryListRepository.getGroceryLists();
      yield GroceryHubLoaded(groceryLists: groceryLists);
    } on Exception catch (e) {
      yield GroceryHubError();
    }
  }

  Stream<GroceryHubState> _mapDeleteGroceryListEvent(
      DeleteGroceryListEvent event) async* {
    yield GroceryHubLoading();

    try {
      await groceryListRepository.deleteGroceryList(event.groceryList);
      final groceryLists = await groceryListRepository.getGroceryLists();
      yield GroceryHubLoaded(groceryLists: groceryLists);
    } on Exception catch (e) {
      yield GroceryHubError();
    }
  }

  Stream<GroceryHubState> _mapAddGroceryListEvent(
      AddGroceryListEvent event) async* {
    yield GroceryHubLoading();

    try {
      await groceryListRepository.insertGroceryList(event.groceryList);
      final groceryLists = await groceryListRepository.getGroceryLists();
      yield GroceryHubLoaded(groceryLists: groceryLists);
    } on Exception catch (e) {
      yield GroceryHubError();
    }
  }
}
