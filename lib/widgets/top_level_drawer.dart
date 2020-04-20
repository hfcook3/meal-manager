import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealmanager/blocs/blocs.dart';

import 'package:mealmanager/models/models.dart';
import 'package:mealmanager/widgets/grocery_list_hub.dart';
import 'widgets.dart';

class TopLevelDrawer extends StatelessWidget {
  final DrawerWidgets callingWidget;

  TopLevelDrawer({@required this.callingWidget})
      : assert(callingWidget != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Meal Manager',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
          ),
          ListTile(
            title: Text('Recipes'),
            onTap: () {
              if (callingWidget != DrawerWidgets.recipes) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => RecipeListView()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: Text('Grocery Lists'),
            onTap: () {
              if (callingWidget != DrawerWidgets.groceryLists) {
                BlocProvider.of<GroceryHubBloc>(context)
                    .add(GetGroceryListsEvent());
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => GroceryListHub()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
