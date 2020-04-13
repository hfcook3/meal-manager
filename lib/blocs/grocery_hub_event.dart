import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';

abstract class GroceryHubEvent extends Equatable {
  const GroceryHubEvent();
}

class GetGroceryListsEvent extends GroceryHubEvent {
  const GetGroceryListsEvent();

  @override
  List<Object> get props => [];
}

class AddGroceryListEvent extends GroceryHubEvent {
  final GroceryList groceryList;

  const AddGroceryListEvent({@required this.groceryList})
      : assert(groceryList != null);

  @override
  List<Object> get props => [groceryList];
}

class EditGroceryListEvent extends GroceryHubEvent {
  final GroceryList groceryList;

  const EditGroceryListEvent({@required this.groceryList})
      : assert(groceryList != null);

  @override
  List<Object> get props => [groceryList];
}

class DeleteGroceryListEvent extends GroceryHubEvent {
  final GroceryList groceryList;

  const DeleteGroceryListEvent({@required this.groceryList})
      : assert(groceryList != null);

  @override
  List<Object> get props => [groceryList];
}
