import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:mealmanager/models/models.dart';

abstract class GroceryListState extends Equatable {
  const GroceryListState();

  @override
  List<Object> get props => [];
}

class GroceryListEmpty extends GroceryListState {}

class GroceryListLoading extends GroceryListState {}

class GroceryListLoaded extends GroceryListState {
  final GroceryList groceryList;

  const GroceryListLoaded({@required this.groceryList})
      : assert(groceryList != null);

  @override
  List<Object> get props => [groceryList];
}

class GroceryListError extends GroceryListState {}
