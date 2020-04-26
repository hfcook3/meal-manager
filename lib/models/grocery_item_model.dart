class GroceryItem {
  int id;
  String item;
  String category;

  GroceryItem();
  GroceryItem.withNoId(this.item, this.category);
  GroceryItem.withData(this.id, this.item, this.category);
}
