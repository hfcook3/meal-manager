class GroceryItem {
  int id;
  String item;
  String category;
  bool checked;

  GroceryItem();
  GroceryItem.withNoId(this.item, this.category, this.checked);
  GroceryItem.withData(this.id, this.item, this.category, this.checked);
}
