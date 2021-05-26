import 'package:ClickandPick/BuyerDashboard/Buyer_Drawer.dart';
import 'package:ClickandPick/BuyerDashboard/myorders.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductRating extends StatefulWidget {
  final Data data;

  ProductRating({Key key, this.data}) : super(key: key);

  @override
  _ProductRatingState createState() => _ProductRatingState();
}

class _ProductRatingState extends State<ProductRating> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final msg = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var ar;
  double arInt;
  var msgV;
  String msgS;

  getProducts() async {
    User user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Reviews')
        .doc(widget.data.id + user.email)
        .get();
    setState(() {
      ar = snap['rating'];
      arInt = ar;
      if (arInt == null) {
        arInt = 0;
        return arInt;
      } else {
        return arInt;
      }
    });
  }

  getMsg() async {
    User user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Reviews')
        .doc(widget.data.id + user.email)
        .get();
    setState(() {
      msgV = snap['msg'];
      msgS = msgV;
      if (msgS == null) {
        msgS = ' ';
        return msgS;
      } else {
        return msgS;
      }
    });
  }

  double valueR;
  @override
  User user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    getProducts();
    getMsg();
    //print(arInt);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFFBB03B2),
        title: Text(
          'Product Review',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: BuyerDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Rate Item',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SmoothStarRating(
                      allowHalfRating: false,
                      size: 30.0,
                      color: Colors.yellow,
                      //rating: arInt,
                      onRated: (double value) async {
                        debugPrint('Image no. was rated $value stars!!!');
                        valueR = value;
                      }),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'You have rated this product as $arInt stars',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Write a Review',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextField(
                      controller: msg,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: msgS,
                          hintStyle: TextStyle(fontSize: 12.0)),
                    )),
                ElevatedButton(
                  child: Text('Done.'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[400], // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    User user = FirebaseAuth.instance.currentUser;
                    FirebaseFirestore.instance
                        .collection('Reviews')
                        .doc(widget.data.id + user.email)
                        .update({
                      'msg': msg.text,
                    });
                    FirebaseFirestore.instance
                        .collection('Reviews')
                        .doc(widget.data.id + user.email)
                        .update({
                      'rating': valueR,
                    });
                    AlertDialog(
                        title: Text(
                          'Your Rating has been submitted',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Segoe'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Segoe'),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Myorders()));
                            },
                          ),
                        ]);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
