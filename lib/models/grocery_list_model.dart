import 'package:mealmanager/models/grocery_item_model.dart';
import 'package:mealmanager/models/models.dart';

class GroceryList {
  int id;
  String name;
  DateTime dateAdded;
  List<GroceryItem> items;

  GroceryList();
  GroceryList.withMeta(this.id, this.name, this.dateAdded);
  GroceryList.withItems(this.id, this.name, this.dateAdded, this.items);
}
