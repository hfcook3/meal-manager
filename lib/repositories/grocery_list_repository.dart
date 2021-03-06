import 'package:meta/meta.dart';

import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/repositories/grocery_list_client.dart';

class GroceryListRepository {
  final GroceryListSqlClient grocerySqlClient;

  GroceryListRepository({@required this.grocerySqlClient})
      : assert(grocerySqlClient != null);

  Future<List<GroceryList>> getGroceryLists() async {
    return await grocerySqlClient.getGroceryLists();
  }

  Future<GroceryList> getFullGroceryList(int groceryListId) async {
    return await grocerySqlClient.getFullGroceryList(groceryListId);
  }

  Future<void> deleteGroceryList(GroceryList groceryList) async {
    return await grocerySqlClient.deleteGroceryList(groceryList);
  }

  Future<void> insertGroceryList(GroceryList groceryList) async {
    return await grocerySqlClient.insertGroceryList(groceryList);
  }

  Future<void> insertGroceryItems(
      GroceryList groceryList, List<GroceryItem> groceryItems) async {
    return await grocerySqlClient.insertGroceryItems(groceryList, groceryItems);
  }

  Future<void> updateGroceryList(GroceryList groceryList) async {
    return await grocerySqlClient.updateGroceryList(groceryList);
  }

  Future<GroceryItem> getGroceryItem(int itemId) async {
    return await grocerySqlClient.getGroceryItem(itemId);
  }

  Future<void> insertNewGroceryItem(GroceryItem groceryItem, int listId) async {
    return await grocerySqlClient.insertNewGroceryItem(groceryItem, listId);
  }

  Future<void> updateGroceryItem(GroceryItem groceryItem) async {
    return await grocerySqlClient.updateGroceryItem(groceryItem);
  }
}
