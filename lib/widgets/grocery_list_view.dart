import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/blocs/blocs.dart';

class GroceryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Meal Manager')),
        body: BlocBuilder<GroceryListBloc, GroceryListState>(
            builder: (context, state) {
          if (state is GroceryListLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GroceryListLoaded) {
            return _buildGroceryList(context, state.groceryList);
          }
          if (state is GroceryListEmpty) {
            return Center(
                child: Text('Something went wrong!',
                    style: TextStyle(color: Colors.red)));
          }
        }));
  }

  Widget _buildGroceryList(BuildContext context, GroceryList groceryList) {
    return ListView.builder(
        itemCount: groceryList.items.length,
        itemBuilder: (BuildContext context, int index) {
          final recipeItem = groceryList.items[index];
          return Dismissible(
            key: Key(recipeItem.id.toString()),
            onDismissed: (direction) {
              BlocProvider.of<GroceryListBloc>(context).add(
                  RemoveGroceryItemEvent(
                      groceryList: groceryList, groceryItemIndex: index));

              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("${recipeItem.item} removed"),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      BlocProvider.of<GroceryListBloc>(context).add(
                          AddGroceryItemEvent(
                              groceryList: groceryList,
                              groceryItem: recipeItem));
                    },
                  )));
            },
            child: ListTile(
              leading: Checkbox(
                value: recipeItem.checked,
                onChanged: (isChecked) {
                  BlocProvider.of<GroceryListBloc>(context).add(
                      CheckGroceryItemEvent(
                          groceryItem: recipeItem,
                          groceryList: groceryList,
                          groceryItemIndex: index));
                },
              ),
              title: Text(
                recipeItem.item,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        });
  }
}
