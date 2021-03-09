import 'package:driverhop/tabPages/earningTabPage.dart';
import 'package:driverhop/tabPages/homeTabPage.dart';
import 'package:driverhop/tabPages/profileTabPage.dart';
import 'package:driverhop/tabPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static String screenId = "MainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  TabController tabController;
  int slectedIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4,vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "HomePage"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money),label: "EarningPage"),
          BottomNavigationBarItem(icon: Icon(Icons.star),label: "RatingPage"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: "ProfilePage"),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.yellowAccent,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        onTap:onItemClicked ,
        currentIndex: slectedIndex,
      ),
    );
  }
  // this method for on tap BottomNavigationBar
  void onItemClicked(int index){
setState(() {
  slectedIndex = index;
  tabController.index =slectedIndex;
});
  }
}

