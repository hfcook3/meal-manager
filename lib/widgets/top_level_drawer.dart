import 'package:flutter/material.dart';

import 'package:mealmanager/models/models.dart';
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
              // Update the state of the app.
              // ...
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
