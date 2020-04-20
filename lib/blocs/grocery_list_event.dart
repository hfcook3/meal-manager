import 'package:equatable/equatable.dart';
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
