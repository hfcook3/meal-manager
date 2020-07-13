import 'package:mealmanager/models/units/cooking_unit_enum.dart';

class UnitConverter {
  static double convertMass(
      double amount, CookingUnit unit1, CookingUnit unit2) {
    switch (unit1) {
      case CookingUnit.pound:
        switch (unit2) {
          case CookingUnit.ounce:
            return amount * 16;
            break;
          case CookingUnit.milligram:
            return amount * 453592;
            break;
          case CookingUnit.gram:
            return amount * 453.592;
            break;
          case CookingUnit.kilogram:
            return amount * 0.453592;
            break;
          default:
            return amount;
            break;
        }
        break;
      case CookingUnit.ounce:
        switch (unit2) {
          case CookingUnit.pound:
            return amount / 16;
            break;
          case CookingUnit.milligram:
            return amount * 28350;
            break;
          case CookingUnit.gram:
            return amount * 28.350;
            break;
          case CookingUnit.kilogram:
            return amount * 0.028350;
            break;
          default:
            return amount;
            break;
        }
        break;
      case CookingUnit.milligram:
        switch (unit2) {
          case CookingUnit.pound:
            return amount / 453592;
            break;
          case CookingUnit.ounce:
            return amount / 28350;
            break;
          case CookingUnit.gram:
            return amount / 1000;
            break;
          case CookingUnit.kilogram:
            return amount / 1000000;
            break;
          default:
            return amount;
            break;
        }
        break;
      case CookingUnit.gram:
        switch (unit2) {
          case CookingUnit.pound:
            return amount / 454;
            break;
          case CookingUnit.ounce:
            return amount / 28.350;
            break;
          case CookingUnit.milligram:
            return amount * 1000;
            break;
          case CookingUnit.kilogram:
            return amount / 1000;
            break;
          default:
            return amount;
            break;
        }
        break;
      case CookingUnit.kilogram:
        switch (unit2) {
          case CookingUnit.pound:
            return amount * 2.205;
            break;
          case CookingUnit.ounce:
            return amount * 35.274;
            break;
          case CookingUnit.milligram:
            return amount * 1000000;
            break;
          case CookingUnit.gram:
            return amount * 1000;
            break;
          default:
            return amount;
            break;
        }
        break;
      default:
        return amount;
        break;
    }
  }

  static double convertVolume(
      double amount, CookingUnit unit1, CookingUnit unit2) {
    switch (unit1) {
      case CookingUnit.teaspoon:
        switch (unit2) {
          case CookingUnit.tablespoon:
            return amount / 3.0;
            break;
          case CookingUnit.fluidOunce:
            return amount / 6.0;
            break;
          case CookingUnit.cup:
            return amount / 48.0;
            break;
          case CookingUnit.pint:
            return amount / 96.0;
            break;
          case CookingUnit.quart:
            return amount / 192.0;
            break;
          case CookingUnit.gallon:
            return amount / 768.0;
            break;
          case CookingUnit.milliliter:
            return amount * 4.929;
            break;
          case CookingUnit.liter:
            return amount / 203.0;
            break;
          case CookingUnit.deciliter:
            return amount / 20.288;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.tablespoon:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 3.0;
            break;
          case CookingUnit.fluidOunce:
            return amount / 2.0;
            break;
          case CookingUnit.cup:
            return amount / 16.0;
            break;
          case CookingUnit.pint:
            return amount / 32.0;
            break;
          case CookingUnit.quart:
            return amount / 64.0;
            break;
          case CookingUnit.gallon:
            return amount / 256.0;
            break;
          case CookingUnit.milliliter:
            return amount * 14.787;
            break;
          case CookingUnit.liter:
            return amount / 67.628;
            break;
          case CookingUnit.deciliter:
            return amount / 6.763;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.fluidOunce:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 6.0;
            break;
          case CookingUnit.tablespoon:
            return amount * 2.0;
            break;
          case CookingUnit.cup:
            return amount / 8.0;
            break;
          case CookingUnit.pint:
            return amount / 16.0;
            break;
          case CookingUnit.quart:
            return amount / 32.0;
            break;
          case CookingUnit.gallon:
            return amount / 128.0;
            break;
          case CookingUnit.milliliter:
            return amount * 29.573;
            break;
          case CookingUnit.liter:
            return amount / 33.8;
            break;
          case CookingUnit.deciliter:
            return amount / 3.37;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.cup:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 48.0;
            break;
          case CookingUnit.tablespoon:
            return amount * 16.0;
            break;
          case CookingUnit.fluidOunce:
            return amount * 8.0;
            break;
          case CookingUnit.pint:
            return amount / 2.0;
            break;
          case CookingUnit.quart:
            return amount / 4.0;
            break;
          case CookingUnit.gallon:
            return amount / 16.0;
            break;
          case CookingUnit.milliliter:
            return amount * 237.0;
            break;
          case CookingUnit.liter:
            return amount / 4.227;
            break;
          case CookingUnit.deciliter:
            return amount * 2.37;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.pint:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 96.0;
            break;
          case CookingUnit.tablespoon:
            return amount * 32.0;
            break;
          case CookingUnit.fluidOunce:
            return amount * 16.0;
            break;
          case CookingUnit.cup:
            return amount * 2;
            break;
          case CookingUnit.quart:
            return amount / 2.0;
            break;
          case CookingUnit.gallon:
            return amount / 8.0;
            break;
          case CookingUnit.milliliter:
            return amount * 473.176;
            break;
          case CookingUnit.liter:
            return amount / 2.113;
            break;
          case CookingUnit.deciliter:
            return amount * 4.732;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.quart:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 192.0;
            break;
          case CookingUnit.tablespoon:
            return amount * 64.0;
            break;
          case CookingUnit.fluidOunce:
            return amount * 32.0;
            break;
          case CookingUnit.cup:
            return amount * 4;
            break;
          case CookingUnit.pint:
            return amount * 2.0;
            break;
          case CookingUnit.gallon:
            return amount / 4.0;
            break;
          case CookingUnit.milliliter:
            return amount * 946.353;
            break;
          case CookingUnit.liter:
            return amount / 1.06;
            break;
          case CookingUnit.deciliter:
            return amount * 9.464;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.gallon:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 768.0;
            break;
          case CookingUnit.tablespoon:
            return amount * 256.0;
            break;
          case CookingUnit.fluidOunce:
            return amount * 128.0;
            break;
          case CookingUnit.cup:
            return amount * 16;
            break;
          case CookingUnit.pint:
            return amount * 4.0;
            break;
          case CookingUnit.quart:
            return amount * 2.0;
            break;
          case CookingUnit.milliliter:
            return amount * 3785;
            break;
          case CookingUnit.liter:
            return amount * 3.785;
            break;
          case CookingUnit.deciliter:
            return amount * 37.85;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.milliliter:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount / 4.929;
            break;
          case CookingUnit.tablespoon:
            return amount / 14.787;
            break;
          case CookingUnit.fluidOunce:
            return amount / 29.574;
            break;
          case CookingUnit.cup:
            return amount / 237;
            break;
          case CookingUnit.pint:
            return amount / 473;
            break;
          case CookingUnit.quart:
            return amount / 946;
            break;
          case CookingUnit.gallon:
            return amount / 1892;
            break;
          case CookingUnit.liter:
            return amount / 1000;
            break;
          case CookingUnit.deciliter:
            return amount / 100;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.deciliter:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 20.2884;
            break;
          case CookingUnit.tablespoon:
            return amount * 6.763;
            break;
          case CookingUnit.fluidOunce:
            return amount * 3.381;
            break;
          case CookingUnit.cup:
            return amount / 2.366;
            break;
          case CookingUnit.pint:
            return amount / 4.73;
            break;
          case CookingUnit.quart:
            return amount / 9.46;
            break;
          case CookingUnit.gallon:
            return amount / 37.854;
            break;
          case CookingUnit.milliliter:
            return amount * 100;
            break;
          case CookingUnit.liter:
            return amount / 10;
            break;
          default:
            return amount;
        }
        break;
      case CookingUnit.liter:
        switch (unit2) {
          case CookingUnit.teaspoon:
            return amount * 203;
            break;
          case CookingUnit.tablespoon:
            return amount * 67.628;
            break;
          case CookingUnit.fluidOunce:
            return amount * 33.814;
            break;
          case CookingUnit.cup:
            return amount * 4.227;
            break;
          case CookingUnit.pint:
            return amount * 2.113;
            break;
          case CookingUnit.quart:
            return amount * 1.057;
            break;
          case CookingUnit.gallon:
            return amount / 3.785;
            break;
          case CookingUnit.milliliter:
            return amount * 1000;
            break;
          case CookingUnit.deciliter:
            return amount * 10;
            break;
          default:
            return amount;
        }
        break;
      default:
        return amount;
        break;
    }
  }
}
