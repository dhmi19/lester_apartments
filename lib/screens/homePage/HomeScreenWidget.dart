import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

import 'HomePageRoommateList.dart';


class HomeScreenWidget extends StatefulWidget {


  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {

  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      child: StreamProvider<List<Apartment>>.value(
        value: ApartmentServices().apartments,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryVariant),
            elevation: 0,
            title: Text("", style: TextStyle(color: Colors.white),),

            centerTitle: true,

          ),


          body: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),

                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            HomePageRoommateList(),

                            SizedBox(height: 20,),

                            Text(
                              "My Home:",
                              style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryVariant,
                              fontFamily: 'Oswald'),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),

          drawer: DrawerWidget()
        ),
      ),
    );
  }
}
