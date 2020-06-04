import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';
import 'RoommateTileList.dart';


class HomeScreenWidget extends StatefulWidget {


  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Apartment>>.value(
      value: ApartmentServices().apartments,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(169, 228, 236, 1),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          centerTitle: true,

        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipPath(

              clipper: MyClipper(),

              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Highway To The City Free Vector.jpg"),
                    fit: BoxFit.fill
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Welcome\nHome",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,),
                      )
                    )
                  ],
                ),
              ),
            ),


            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Roommates", style: TextStyle(fontSize: 20),)
                ),

                ChangeColorButton()
              ],
            ),

            SizedBox(height: 20,),

            Expanded(
              child: RoommateTileList(),
            ),
            SizedBox(height: 20,)
          ],
        ),

        drawer: DrawerWidget(),
      ),
    );
  }
}


class MyClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width , 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}