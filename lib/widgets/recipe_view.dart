import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mealmanager/blocs/blocs.dart';
import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/widgets/widgets.dart';

enum RecipeAction { addToGroceries }

class RecipeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meal Manager'),
          actions: <Widget>[
            BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
              if (state is RecipeLoaded) {
                return PopupMenuButton(
                  onSelected: (RecipeAction action) {
                    _executeRecipeAction(context, action, state.recipe);
                  },
                  itemBuilder: (BuildContext buildContext) {
                    return <PopupMenuEntry<RecipeAction>>[
                      const PopupMenuItem(
                          value: RecipeAction.addToGroceries,
                          child: Text('Add to Groceries'))
                    ];
                  },
                );
              } else {
                return Text('Loading...');
              }
            })
          ],
        ),
        body: BlocBuilder<RecipeBloc, RecipeState>(builder: (context, state) {
          if (state is RecipeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is RecipeLoaded) {
            return _buildRecipe(state.recipe);
          }
          if (state is RecipeError) {
            return Center(
                child: Text('Something went wrong!',
                    style: TextStyle(color: Colors.red)));
          }
        }));
  }

  Widget _buildRecipe(Recipe recipe) {
    return ListView(padding: EdgeInsets.all(12.0), children: [
      Text(
        recipe.title,
        style: TextStyle(fontSize: 40.0),
        textAlign: TextAlign.left,
      ),
      Divider(
        thickness: 2.0,
      ),
      Text(
        'Ingredients',
        style: TextStyle(fontSize: 32.0),
        textAlign: TextAlign.left,
      ),
      Column(
        children: List.generate(recipe.ingredients.length, (i) {
          return Row(children: <Widget>[
            Icon(Icons.arrow_right),
            Text(
              recipe.ingredients[i],
              style: TextStyle(fontSize: 20.0),
            )
          ]);
        }),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        'Steps',
        style: TextStyle(fontSize: 32.0),
        textAlign: TextAlign.left,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(recipe.steps.length, (i) {
          return Text(
            "${i + 1}.  ${recipe.steps[i]}",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20.0),
          );
        }),
      ),
    ]);
  }

  Future<void> _executeRecipeAction(
      BuildContext context, RecipeAction action, Recipe recipe) async {
    switch (action) {
      case RecipeAction.addToGroceries:
        {
          BlocProvider.of<GroceryHubBloc>(context).add(GetGroceryListsEvent());

          var groceryList = await Navigator.push<GroceryList>(context,
              new MaterialPageRoute(builder: (context) => GroceryListModal()));

          if (groceryList == null) {
            return;
          }

          var groceryItems = recipe.ingredients.map<GroceryItem>((ingredient) {
            return new GroceryItem.withNoId(ingredient, "Other", false);
          }).toList();
          BlocProvider.of<GroceryListBloc>(context).add(AddIngredientListEvent(
              groceryList: groceryList, groceryItems: groceryItems));

          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new GroceryListView(
                        groceryListId: groceryList.id,
                      )));
        }
    }
  }
}
