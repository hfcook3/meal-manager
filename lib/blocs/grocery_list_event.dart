import 'package:equatable/equatable.dart';
import 'package:mealmanager/blocs/blocs.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';

abstract class GroceryListEvent extends Equatable {
  const GroceryListEvent();
}

class InitializeNewGroceryListEvent extends GroceryListEvent {
  const InitializeNewGroceryListEvent();

  @override
  List<Object> get props => [];
}

class GetFullGroceryListEvent extends GroceryListEvent {
  final GroceryList groceryList;

  const GetFullGroceryListEvent({@required this.groceryList})
      : assert(groceryList != null);

  @override
  List<Object> get props => [groceryList];
}

class AddIngredientListEvent extends GroceryListEvent {
  final GroceryList groceryList;
  final List<GroceryItem> groceryItems;

  const AddIngredientListEvent(
      {@required this.groceryList, @required this.groceryItems})
      : assert(groceryList != null && groceryItems != null);

  @override
  List<Object> get props => [groceryList, groceryItems];
}

class AddGroceryItemEvent extends GroceryListEvent {
  final GroceryList groceryList;
  final GroceryItem groceryItem;

  const AddGroceryItemEvent(
      {@required this.groceryList, @required this.groceryItem})
      : assert(groceryList != null && groceryItem != null);

  @override
  List<Object> get props => [groceryList, groceryItem];
}

class RemoveGroceryItemEvent extends GroceryListEvent {
  final GroceryList groceryList;
  final int groceryItemIndex;

  const RemoveGroceryItemEvent(
      {@required this.groceryList, @required this.groceryItemIndex})
      : assert(groceryList != null && groceryItemIndex != null);

  @override
  List<Object> get props => [groceryList, groceryItemIndex];
}

class CheckGroceryItemEvent extends GroceryListEvent {
  final GroceryItem groceryItem;
  final GroceryList groceryList;
  final int groceryItemIndex;

  const CheckGroceryItemEvent(
      {@required this.groceryItem,
      @required this.groceryList,
      @required this.groceryItemIndex})
      : assert(groceryItem != null &&
            groceryList != null &&
            groceryItemIndex != null);

  @override
  List<Object> get props => [groceryItem, groceryList, groceryItemIndex];
}
