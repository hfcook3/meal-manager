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
            return _buildGroceryList(state.groceryList);
          }
          if (state is GroceryListEmpty) {
            return Center(
                child: Text('Something went wrong!',
                    style: TextStyle(color: Colors.red)));
          }
        }));
  }

  Widget _buildGroceryList(GroceryList groceryList) {
    return ListView(padding: EdgeInsets.all(12.0), children: [
      Text(
        groceryList.name,
        style: TextStyle(fontSize: 40.0),
        textAlign: TextAlign.left,
      ),
      Divider(
        thickness: 2.0,
      ),
      Column(
        children: List.generate(groceryList.items.length, (i) {
          return Row(children: <Widget>[
            Icon(Icons.arrow_right),
            Text(
              groceryList.items[i].item,
              style: TextStyle(fontSize: 20.0),
            )
          ]);
        }),
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }
}
