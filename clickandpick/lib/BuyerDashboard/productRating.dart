import 'package:ClickandPick/BuyerDashboard/Buyer_Drawer.dart';
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
  int arInt;
  getProducts() async {
    User user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Reviews')
        .doc(widget.data.id + user.email)
        .get();
    setState(() {
      ar = snap['rating'];
      ar = arInt;
    });
  }

  @override
  User user = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    getProducts();
    //print(arInt.toDouble());
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
                      //rating: //arInt.toDouble(),
                      onRated: (double value) async {
                        debugPrint('Image no. was rated $value stars!!!');
                      }),
                ),
              ],
            ),
            Column(
              children: <Widget>[
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
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 10),
                        ),
                        hintText: 'Write your Review')),
                ElevatedButton(
                  child: Text('Done.'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[400], // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
