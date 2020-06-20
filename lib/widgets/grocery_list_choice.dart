import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:mealmanager/blocs/blocs.dart';
import 'package:mealmanager/models/models.dart';

class GroceryListModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Grocery List Choices'),
        ),
        body: BlocBuilder<GroceryHubBloc, GroceryHubState>(
            builder: (context, state) {
          if (state is GroceryHubEmpty) {
            return Center(
                child: Text('No grocery lists found. Try adding some!'));
          }
          if (state is GroceryHubLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GroceryHubLoaded) {
            return _buildGroceryLists(state.groceryLists);
          }
          if (state is GroceryHubError) {
            return Center(
                child: Text('Something went wrong!',
                    style: TextStyle(color: Colors.red)));
          }
          return Center(
              child: Text('Bad state.', style: TextStyle(color: Colors.red)));
        }));
  }

  Widget _buildGroceryLists(List<GroceryList> groceryLists) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: groceryLists.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider(
            thickness: 2.0,
          );
        } else {
          return _buildGroceryTile(context, groceryLists[i ~/ 2]);
        }
      },
    );
  }

  Widget _buildGroceryTile(BuildContext context, GroceryList groceryList) {
    return ListTile(
        title: Center(child: Text(groceryList.name)),
        onTap: () async {
          Navigator.pop(context, groceryList);
        });
  }
}
