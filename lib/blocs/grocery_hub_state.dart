import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:mealmanager/models/models.dart';

abstract class GroceryHubState extends Equatable {
  const GroceryHubState();

  @override
  List<Object> get props => [];
}

class GroceryHubEmpty extends GroceryHubState {}

class GroceryHubLoading extends GroceryHubState {}

class GroceryHubLoaded extends GroceryHubState {
  final List<GroceryList> groceryLists;

  const GroceryHubLoaded({@required this.groceryLists})
      : assert(groceryLists != null);

  @override
  List<Object> get props => [groceryLists];
}

class GroceryHubError extends GroceryHubState {}
