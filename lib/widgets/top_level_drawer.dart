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
                BlocProvider.of<RecipeListBloc>(context)
                    .add(GetRecipeListEvent());
                Navigator.pushNamedAndRemoveUntil(
                    context, '/recipes', (route) => false);
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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/groceries', (route) => false);
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
