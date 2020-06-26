class Ingredient {
  int id;
  double amount;
  String unit;
  String text;

  Ingredient();
  Ingredient.withInitialValues(this.amount, this.unit, this.text);
  Ingredient.withData(this.id, this.amount, this.unit, this.text);

  String fullIngredientText() {
    num amountToShow;
    if (amount.remainder(1) == 0) {
      amountToShow = amount.floor();
    } else {
      amountToShow = amount;
    }

    String unitText = (unit ?? "").trim() == "" ? " x " : unit;

    return amountToShow.toString() + " " + unitText + " " + (text ?? "");
  }
}
