import 'package:flutter/material.dart';
import 'package:lester_apartments/services/route_generator.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            title: Text('View my Apartment'),
            trailing: Icon(Icons.people),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('View my profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/MyProfileScreen');
            },
          ),
        ],
      ),
    );
  }
}
