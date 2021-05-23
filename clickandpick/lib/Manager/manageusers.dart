import 'package:flutter/material.dart';

import 'Manager_drawer.dart';
import 'package:ClickandPick/Manager/ManageSellers.dart';
import 'package:ClickandPick/Manager/ManageRiders.dart';
import 'package:ClickandPick/Manager/ManageBuyers.dart';

class Manageusers extends StatefulWidget {
  @override
  _ManageusersState createState() => _ManageusersState();
}

class _ManageusersState extends State<Manageusers>
    with TickerProviderStateMixin {
  TabController tabController;
  int tabindex;
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          tabindex = tabController.index;
        });
      }
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFBB03B2),
        title: Text(
          'Manage Users',
          style: TextStyle(
              fontFamily: 'Segoe', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () {
            scaffoldKey.currentState.openDrawer();
            /* Write listener code here */
          },
          child: Icon(Icons.menu, color: Colors.white // add custom icons also
              ),
        ),
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Color.fromRGBO(102, 126, 234, 1),
          controller: tabController,
          tabs: [
            Tab(
              child: Text(
                'Buyers ',
                style:
                    TextStyle(fontFamily: 'Segoe', fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Sellers',
                style:
                    TextStyle(fontFamily: 'Segoe', fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Riders',
                style:
                    TextStyle(fontFamily: 'Segoe', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      drawer: ManagerDrawer(),
      body: TabBarView(controller: tabController, children: <Widget>[
        ManageBuyers(),
        ManageSellers(),
        ManageRiders(),
      ]),
    );
  }
}
