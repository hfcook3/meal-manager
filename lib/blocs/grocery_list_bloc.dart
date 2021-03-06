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
    if (event is UpdateGroceryListEvent) {
      yield* _mapUpdateGroceryListEvent(event);
    }
    if (event is AddGroceryItemEvent) {
      yield* _mapAddGroceryItemEvent(event);
    }
    if (event is AddIngredientListEvent) {
      yield* _mapAddIngredientListEvent(event);
    }
    if (event is RemoveGroceryItemEvent) {
      yield* _mapRemoveGroceryItemEvent(event);
    }
    if (event is CheckGroceryItemEvent) {
      yield* _mapCheckGroceryItemEvent(event);
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
          await groceryListRepository.getFullGroceryList(event.groceryListId);
      yield GroceryListLoaded(groceryList: fullGroceryList);
    } on Exception catch (e) {
      yield GroceryListError();
    }
  }

  Stream<GroceryListState> _mapUpdateGroceryListEvent(
      UpdateGroceryListEvent event) async* {
    if (state is GroceryListLoaded) {
      await groceryListRepository.updateGroceryList(event.groceryList);

      final groceryList =
          await groceryListRepository.getFullGroceryList(event.groceryList.id);

      yield GroceryListLoaded(groceryList: groceryList);
    }
  }

  Stream<GroceryListState> _mapAddGroceryItemEvent(
      AddGroceryItemEvent event) async* {
    if (state is GroceryListLoaded) {
      event.groceryList.items.add(event.groceryItem);
      final groceryList = new GroceryList.withMeta(event.groceryList.id,
          event.groceryList.name, event.groceryList.dateAdded);
      groceryList.items = event.groceryList.items;

      await groceryListRepository.insertNewGroceryItem(
          event.groceryItem, event.groceryList.id);

      yield GroceryListLoaded(groceryList: groceryList);
    }
  }

  Stream<GroceryListState> _mapAddIngredientListEvent(
      AddIngredientListEvent event) async* {
    if (state is GroceryListLoaded) {
      await groceryListRepository.insertGroceryItems(
          event.groceryList, event.groceryItems);
      final groceryList =
          await groceryListRepository.getFullGroceryList(event.groceryList.id);

      yield GroceryListLoaded(groceryList: groceryList);
    }
  }

  Stream<GroceryListState> _mapRemoveGroceryItemEvent(
      RemoveGroceryItemEvent event) async* {
    if (state is GroceryListLoaded) {
      event.groceryList.items.removeAt(event.groceryItemIndex);
      final groceryList = new GroceryList.withMeta(event.groceryList.id,
          event.groceryList.name, event.groceryList.dateAdded);
      groceryList.items = event.groceryList.items;

      await groceryListRepository.updateGroceryList(groceryList);

      yield GroceryListLoaded(groceryList: groceryList);
    }
  }

  Stream<GroceryListState> _mapCheckGroceryItemEvent(
      CheckGroceryItemEvent event) async* {
    if (state is GroceryListLoaded) {
      event.groceryItem.checked = !event.groceryItem.checked;
      event.groceryList.items[event.groceryItemIndex] = event.groceryItem;

      final groceryList = new GroceryList.withMeta(event.groceryList.id,
          event.groceryList.name, event.groceryList.dateAdded);
      groceryList.items = event.groceryList.items;

      await groceryListRepository.updateGroceryItem(event.groceryItem);
      yield GroceryListLoaded(groceryList: groceryList);
    }
  }
}
