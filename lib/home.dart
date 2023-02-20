import 'package:flutter/material.dart';
import 'package:flutter_application_300/screens/maps.dart';
import 'package:flutter_application_300/screens/record.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final screens =[
    Maps(),
    Record()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.redAccent,
          labelTextStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.bold))
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: index,
          onDestinationSelected: (index)=>
          setState(() {
            this.index = index;
          })
          ,
          destinations:const [
            NavigationDestination(
              icon: Icon(Icons.map),
               label: 'Maps'),
               NavigationDestination(
              icon: Icon(Icons.record_voice_over),
               label: 'Record'),
          ]),
      ),
    );
  }
}