import 'package:ClickandPick/BuyerDashboard/Buyer_drawer.dart';
import 'package:ClickandPick/BuyerDashboard/Category.dart';
import 'package:ClickandPick/BuyerDashboard/Categoryselect.dart';
import 'package:ClickandPick/BuyerDashboard/details.dart';
import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Cart/cart.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/settings.dart/setting_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1523381294911-8d3cead13475?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1500&q=80',
  'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=340&q=80',
  'https://images.unsplash.com/photo-1533603208986-24fd819e718a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80',
  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80',
  'https://images.unsplash.com/photo-1560243563-062bfc001d68?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80'
];

class BuyerDashboard extends StatefulWidget {
  BuyerDashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BuyerDashboardState createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard>
    with SingleTickerProviderStateMixin {
  final Distance distance = Distance();
  double totalDistanceInM = 0;
  double totalDistanceInKm = 0;
  var _bottomNavIndex = 0;
  var store;
  List<int> distances = [];
  List<GeoPoint> collection = [];

  String nearestCollectionPoint;
  var small;
  var collect;
  Future getlocation() async {
    List<Map<String, dynamic>> distancesBetween = [];
    await FirebaseFirestore.instance
        .collection('manager')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        distancesBetween.add({
          'name': doc['collection point'],
          'distance': distance(
            LatLng(_currentPosition.latitude, _currentPosition.longitude),
            LatLng(doc['location'].latitude, doc['location'].longitude),
          ).toInt()
        });
      });
      int smallest = (distancesBetween[0])['distance'];
      var collectionPoint = distancesBetween[0];

      distancesBetween.forEach((element) {
        if ((element)['distance'] < smallest) {
          smallest = (element)['distance'];
          collectionPoint = element;
        }
      });
      setState(() {
        nearestCollectionPoint = (collectionPoint['name']);
      });
      print((collectionPoint['name']));
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
    getlocation();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isLoggedIn() async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.emailVerified);
  }

  int activeIndex;

  int index;
  void initState() {
    _getCurrentLocation();
    getlocation();
    super.initState();
  }

  getProducts() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection('clothing')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  List<String> favIds = [];
  getfavourites() async {
    User user = FirebaseAuth.instance.currentUser;

    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection("user")
        .doc(user.email)
        .collection('favourites')
        .get();
    snap2.docs.forEach((element) {
      favIds.add(element['id']);
    });
  }

  getMen() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection('electronics')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  getkids() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection('watches')
          .where('collection point', isEqualTo: collect)
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  getfood() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection('food')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  getfragances() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection('fragrances')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  getshoes() {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc('category')
          .collection('shoes')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getlocation();
    index = 0;
    print(nearestCollectionPoint);
    var height = MediaQuery.of(context).size.height;
    //width of the screen
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
          onWillPop: () {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Are you sure you want to exit?',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Segoe'),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Segoe'),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Exit",
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Segoe'),
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                    ],
                  );
                });
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(0xFFFFFFFF),
            appBar: AppBar(
              backgroundColor: Color(0xFFBB03B2),
              elevation: 0.0,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Text("Click and Pick",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                  /* Write listener code here */
                },
                child: Icon(Icons.menu,
                    color: Colors.white // add custom icons also
                    ),
              ),
            ),
            drawer: BuyerDrawer(),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                    ),
                    items: imgList
                        .map((item) => Container(
                              child: Center(
                                  child: Image.network(item,
                                      fit: BoxFit.cover, width: width)),
                            ))
                        .toList(),
                  )),
                  _currentPosition == null
                      ? Container()
                      : Container(
                          child: Text(_currentPosition.latitude.toString())),
                  _currentPosition == null
                      ? Container()
                      : Container(
                          child: Text(_currentPosition.longitude.toString())),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TitleText(
                            text: 'Clothing',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          child: new Text(
                            'See All',
                            style: TextStyle(
                                color: Color(0xFFBB03B2),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategorySelected(type: 'clothing'),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: getProducts(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? Container(
                              height: 370,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ds['quantity'].toString() == "0"
                                                  ? "Out of Stock"
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Details(
                                                          type: 'clothing',
                                                          data: Data(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['id'],
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                            price: snapshot.data
                                                                    .docs[index]
                                                                ['price'],
                                                            image: snapshot.data
                                                                    .docs[index]
                                                                ['image_path'],
                                                            description: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['description'],
                                                            sellername: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['sellername'],
                                                            shopaddress: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['shopaddress'],
                                                            selleremail: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['selleremail'],
                                                            quantity: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'],
                                                            rating: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['rating'],
                                                            collectionpoint:
                                                                nearestCollectionPoint,
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 160,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ds['image_path']
                                                        .toString(),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          ds['price'].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['quantity'].toString() == "0"
                                                ? 'Out of Stock'
                                                : 'In stock',
                                            style: TextStyle(
                                                color: Color(0xFF84A2AF),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TitleText(
                            text: 'Electronics ',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          child: new Text(
                            'See All',
                            style: TextStyle(
                                color: Color(0xFFBB03B2),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategorySelected(
                                    type: 'electronics',
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: getMen(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? Container(
                              height: 370,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ds['quantity'].toString() == "0"
                                                  ? "Out of Stock"
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Details(
                                                          type: 'electronics',
                                                          data: Data(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['id'],
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                            price: snapshot.data
                                                                    .docs[index]
                                                                ['price'],
                                                            image: snapshot.data
                                                                    .docs[index]
                                                                ['image_path'],
                                                            description: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['description'],
                                                            sellername: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['sellername'],
                                                            shopaddress: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['shopaddress'],
                                                            selleremail: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['selleremail'],
                                                            rating: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['rating'],
                                                            quantity: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'],
                                                            collectionpoint:
                                                                nearestCollectionPoint,
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 160,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ds['image_path']
                                                        .toString(),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: .0),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                ds['price'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              'RS',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['quantity'].toString() == "0"
                                                ? "Out of Stock"
                                                : 'In stock',
                                            style: TextStyle(
                                                color: Color(0xFF84A2AF),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TitleText(
                            text: 'Watches',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          child: new Text(
                            'See All',
                            style: TextStyle(
                                color: Color(0xFFBB03B2),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategorySelected(
                                    type: 'watches',
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: getkids(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? Container(
                              height: 370,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ds['quantity'].toString() == "0"
                                                  ? "Out of Stock"
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Details(
                                                          type: 'watches',
                                                          data: Data(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['id'],
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                            price: snapshot.data
                                                                    .docs[index]
                                                                ['price'],
                                                            image: snapshot.data
                                                                    .docs[index]
                                                                ['image_path'],
                                                            description: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['description'],
                                                            sellername: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['sellername'],
                                                            shopaddress: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['shopaddress'],
                                                            selleremail: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['selleremail'],
                                                            rating: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['rating'],
                                                            quantity: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'],
                                                            collectionpoint:
                                                                nearestCollectionPoint,
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 160,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ds['image_path']
                                                        .toString(),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: .0),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                ds['price'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              'RS',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['quantity'].toString() == "0"
                                                ? "Out of Stock"
                                                : 'In stock',
                                            style: TextStyle(
                                                color: Color(0xFF84A2AF),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TitleText(
                            text: 'Food',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          child: new Text(
                            'See All',
                            style: TextStyle(
                                color: Color(0xFFBB03B2),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategorySelected(
                                    type: 'food',
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: getfood(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? Container(
                              height: 370,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ds['quantity'].toString() == "0"
                                                  ? "Product Unavilable"
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Details(
                                                          type: 'food',
                                                          data: Data(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['id'],
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                            price: snapshot.data
                                                                    .docs[index]
                                                                ['price'],
                                                            image: snapshot.data
                                                                    .docs[index]
                                                                ['image_path'],
                                                            description: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['description'],
                                                            sellername: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['sellername'],
                                                            shopaddress: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['shopaddress'],
                                                            selleremail: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['selleremail'],
                                                            rating: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['rating'],
                                                            quantity: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'],
                                                            collectionpoint:
                                                                nearestCollectionPoint,
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 160,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ds['image_path']
                                                        .toString(),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 85),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['price'].toString() + " RS ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['quantity'].toString() == "0"
                                                ? "Out of Stock"
                                                : 'In stock',
                                            style: TextStyle(
                                                color: Color(0xFF84A2AF),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TitleText(
                            text: 'Fragrances',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          child: new Text(
                            'See All',
                            style: TextStyle(
                                color: Color(0xFFBB03B2),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategorySelected(
                                    type: 'fragrances',
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: getfragances(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? Container(
                              height: 370,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ds['quantity'].toString() == "0"
                                                  ? "Out of Stock"
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Details(
                                                          type: 'fragances',
                                                          data: Data(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['id'],
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                            price: snapshot.data
                                                                    .docs[index]
                                                                ['price'],
                                                            image: snapshot.data
                                                                    .docs[index]
                                                                ['image_path'],
                                                            description: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['description'],
                                                            sellername: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['sellername'],
                                                            shopaddress: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['shopaddress'],
                                                            selleremail: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['selleremail'],
                                                            rating: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['rating'],
                                                            quantity: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'],
                                                            collectionpoint:
                                                                nearestCollectionPoint,
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 160,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ds['image_path']
                                                        .toString(),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: .0),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                ds['price'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              'RS',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['quantity'].toString() == "0"
                                                ? "Out of Stock"
                                                : 'In stock',
                                            style: TextStyle(
                                                color: Color(0xFF84A2AF),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TitleText(
                            text: 'Shoes Collection',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          child: new Text(
                            'See All',
                            style: TextStyle(
                                color: Color(0xFFBB03B2),
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategorySelected(
                                    type: 'shoes',
                                  ),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: getshoes(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? Container(
                              height: 370,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.docs.length,
                                padding: const EdgeInsets.only(top: 20.0),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];

                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              ds['quantity'].toString() == "0"
                                                  ? "Out of Stock"
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Details(
                                                          type: 'shoes',
                                                          data: Data(
                                                            id: snapshot.data
                                                                    .docs[index]
                                                                ['id'],
                                                            name: snapshot.data
                                                                    .docs[index]
                                                                ['name'],
                                                            price: snapshot.data
                                                                    .docs[index]
                                                                ['price'],
                                                            image: snapshot.data
                                                                    .docs[index]
                                                                ['image_path'],
                                                            description: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['description'],
                                                            sellername: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['sellername'],
                                                            shopaddress: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['shopaddress'],
                                                            selleremail: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['selleremail'],
                                                            rating: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['rating'],
                                                            quantity: snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'],
                                                            collectionpoint:
                                                                nearestCollectionPoint,
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 160,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ds['image_path']
                                                        .toString(),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['name'].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: .0),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                ds['price'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              'RS',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            ds['quantity'].toString() == "0"
                                                ? "Out of Stock"
                                                : 'In stock',
                                            style: TextStyle(
                                                color: Color(0xFF84A2AF),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: 50,
              color: Colors.black54,
              backgroundColor: Color(0xFFBB03B2),
              buttonBackgroundColor: Colors.black54,
              items: <Widget>[
                Icon(Icons.home, size: 20, color: Color(0xFFFFFFFF)),
                Icon(Icons.category, size: 20, color: Color(0xFFFFFFFF)),
                Icon(Icons.shopping_bag, size: 20, color: Color(0xFFFFFFFF)),
                Icon(Icons.people, size: 20, color: Color(0xFFFFFFFF)),
              ],
              animationDuration: Duration(milliseconds: 300),
              animationCurve: Curves.easeInOut,

              onTap: (index) {
                print(index);
                if (index == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuyerDashboard()));
                }
                if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Category(),
                      ));
                }
                if (index == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cart(),
                      ));
                }
                if (index == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                }
              },

              //other params
            ),
          )),
    );
  }
}
