import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/blocs/blocs.dart';
import 'package:mealmanager/repositories/grocery_list_repository.dart';

class GroceryListBloc extends Bloc<GroceryListEvent, GroceryListState> {
  final GroceryListRepository groceryListRepository;

  GroceryListBloc({@required this.groceryListRepository})
      : assert(groceryListRepository != null);

  @override
  GroceryListState get initialState => GroceryListEmpty();

  @override
  Stream<GroceryListState> mapEventToState(GroceryListEvent event) async* {
    if (event is InitializeNewGroceryListEvent) {
      yield* _mapInitializeNewGroceryListEvent(event);
    }
    if (event is GetFullGroceryListEvent) {
      yield* _mapGetFullGroceryListEvent(event);
    }
    if (event is AddGroceryItemEvent) {
      yield* _mapAddGroceryItemEvent(event);
    }
    if (event is RemoveGroceryItemEvent) {
      yield* _mapRemoveGroceryItemEvent(event);
    }
  }

  Stream<GroceryListState> _mapInitializeNewGroceryListEvent(
      InitializeNewGroceryListEvent event) async* {
    var groceryList = new GroceryList();
    groceryList.items = new List<GroceryItem>();

    yield GroceryListLoaded(groceryList: groceryList);
  }

  Stream<GroceryListState> _mapGetFullGroceryListEvent(
      GetFullGroceryListEvent event) async* {
    yield GroceryListLoading();

    try {
      var fullGroceryList =
          await groceryListRepository.getFullGroceryList(event.groceryList);
      yield GroceryListLoaded(groceryList: fullGroceryList);
    } on Exception catch (e) {
      yield GroceryListError();
    }
  }

  Stream<GroceryListState> _mapAddGroceryItemEvent(
      AddGroceryItemEvent event) async* {
    yield GroceryListLoading();

    try {
      event.groceryList.items.add(event.groceryItem);
      yield GroceryListLoaded(groceryList: event.groceryList);
    } on Exception catch (e) {
      yield GroceryListError();
    }
  }

  Stream<GroceryListState> _mapRemoveGroceryItemEvent(
      RemoveGroceryItemEvent event) async* {
    yield GroceryListLoading();

    try {
      event.groceryList.items.removeAt(event.groceryItemIndex);
      yield GroceryListLoaded(groceryList: event.groceryList);
    } on Exception catch (e) {
      yield GroceryListError();
    }
  }
}