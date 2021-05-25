import 'package:ClickandPick/BuyerDashboard/buyerdashboard.dart';
import 'package:ClickandPick/BuyerDashboard/title_text.dart';
import 'package:ClickandPick/Cart/initservice.dart';
import 'package:ClickandPick/SellerDashboard/data.dart';
import 'package:ClickandPick/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class Wallet extends StatefulWidget {
  final Data data;

  Wallet({Key key, this.data}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final phone = TextEditingController();
  final amount = TextEditingController();
  getUsers() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      return FirebaseFirestore.instance
          .collection('user')
          .doc(user.email)
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    getphone();
    getUsers();
    super.initState();
  }

  getphone() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .get();
    setState(() {
      g = snap['phone'];
    });
  }

  checkReview() async {
    await FirebaseFirestore.instance
        .collection('Reviews')
        .doc(widget.data.id + user.email)
        .get()
        .then((value) async {
      value.data();
      if (value.data() == null) {
        await FirebaseFirestore.instance
            .collection('Reviews')
            .doc(widget.data.id + user.email)
            .set({
          'pid': widget.data.id,
          'uid': user.email,
          'rating': 0,
          'msg': "",
        });
      }
    });
  }

  var g;

  User user = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int _selectedItem = 0;

  selectItem(index) {
    setState(() {
      _selectedItem = index;
      print(selectItem.toString());
    });
  }

  int index = 0;
  bool isSelected;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: containercolor,
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
                Container(
                  height: 250.0,
                  width: double.infinity,
                  color: Color(0xFFBB03B2),
                ),
                Positioned(
                  bottom: 450.0,
                  right: 100.0,
                  child: Container(
                    height: 400.0,
                    width: 400.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Color(0xFFBB03B2),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 500.0,
                  left: 150.0,
                  child: Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150.0),
                          color: Color(0xFFBB03B2).withOpacity(0.5))),
                ),
                Positioned(
                    top: 35.0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    )),
                Positioned(
                  top: 95.0,
                  left: 15.0,
                  child: TitleText(
                    text: 'Select Payment Method',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 315.0,
                  left: 15.0,
                  child: TitleText(
                    text: 'Recommended Methods',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  top: 315.0,
                  left: 15.0,
                  child: TitleText(
                    text: 'Recommended Methods',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 380.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        leading: Image.asset("assets/cod.png"),
                        title: Text('Cash On Delivery'),
                        subtitle: Text('payment is made on delivery'),
                        trailing: StreamBuilder<Object>(
                            stream: null,
                            builder: (context, snapshot) {
                              return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      index = 0;
                                    });
                                  },
                                  icon: (index == 0
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border)),
                                  color: Colors.red[500]);
                            }),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 480.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        leading: Image.asset("assets/jaaz.png"),
                        title: Text('Jaaz Cash'),
                        subtitle: Text('Online Paymet Through Jaazcash'),
                        trailing: StreamBuilder<Object>(
                            stream: null,
                            builder: (context, snapshot) {
                              return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      index = 1;
                                    });
                                  },
                                  icon: (index == 1
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border)),
                                  color: Colors.red[500]);
                            }),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 600.0),
                    child: Center(
                        child: Container(
                            width: 300,
                            height: 50,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            child: index == 0
                                ? RaisedButton(
                                    color: Color(0xFFBB03B2),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      User user =
                                          FirebaseAuth.instance.currentUser;
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(user.email)
                                          .collection('orders')
                                          .doc()
                                          .set({
                                        'name': widget.data.name,
                                        'selleremail': widget.data.selleremail,
                                        'id': widget.data.id,
                                        'quantity': widget.data.quantity,
                                        'image': widget.data.image
                                      });
                                      checkReview();
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc()
                                          .set({
                                        'name': widget.data.name,
                                        'selleremail': widget.data.selleremail,
                                        'id': widget.data.id,
                                        'quantity': widget.data.quantity,
                                        'price': widget.data.price,
                                        'image': widget.data.image,
                                        'buyeremail': user.email,
                                        'phone': g.toString(),
                                        'picked from vendor': false,
                                        'Order Dilevered to Collection Point':
                                            false,
                                        'Order Recieved to Collection Point':
                                            false,
                                        'Rider': "",
                                        'shopaddress': widget.data.shopaddress,
                                        'collection point':
                                            widget.data.collectionpoint,
                                        'PaymentStatus': "cod",
                                        'total': widget.data.total
                                      });
                                      showThankYouBottomSheet(context);
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(user.email)
                                          .collection('cart')
                                          .doc(widget.data.id)
                                          .delete();
                                    },
                                    child: Text(
                                      "Pay Now",
                                      style: CustomTextStyle.textFormFieldMedium
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : RaisedButton(
                                    color: Color(0xFFBB03B2),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      Dialog errorDialog = Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.0)), //this right here
                                        child: Container(
                                          height: 300.0,
                                          width: 300.0,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Phone number',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Container(
                                                width: 300,
                                                child: TextFormField(
                                                    controller: phone,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Phone number",
                                                        border:
                                                            InputBorder.none,
                                                        fillColor:
                                                            Color(0xFFF4F3F4),
                                                        filled: true)),
                                              ),
                                              Text(
                                                'Amount',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Container(
                                                width: 300,
                                                child: TextFormField(
                                                    controller: amount,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            widget.data.price,
                                                        border:
                                                            InputBorder.none,
                                                        fillColor:
                                                            Color(0xFFF4F3F4),
                                                        filled: true)),
                                              ),
                                              RaisedButton(
                                                onPressed: () async {
                                                  isLoading = true;

                                                  JazzcashPayment
                                                      jazzcashPayment =
                                                      JazzcashPayment(
                                                          phone: phone.text
                                                              .toString()
                                                              .replaceAll(
                                                                  '-', ''),
                                                          amount: amount.text
                                                                  .toString() +
                                                              '00');

                                                  await jazzcashPayment
                                                      .payment()
                                                      .then((value) {
                                                    // setState((){response = value});

                                                    if (json.decode(value.body)[
                                                            'pp_ResponseCode'] ==
                                                        '000') {
                                                      setState(() {
                                                        isLoading = false;
                                                      });

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BuyerDashboard()));
                                                      FirebaseFirestore.instance
                                                          .collection('user')
                                                          .doc(user.email)
                                                          .collection('orders')
                                                          .doc()
                                                          .set({
                                                        'name':
                                                            widget.data.name,
                                                        'selleremail': widget
                                                            .data.selleremail,
                                                        'id': widget.data.id,
                                                        'quantity': widget
                                                            .data.quantity,
                                                        'image':
                                                            widget.data.image
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('orders')
                                                          .doc()
                                                          .set({
                                                        'name':
                                                            widget.data.name,
                                                        'selleremail': widget
                                                            .data.selleremail,
                                                        'id': widget.data.id,
                                                        'quantity': widget
                                                            .data.quantity,
                                                        'price':
                                                            widget.data.price,
                                                        'image':
                                                            widget.data.image,
                                                        'buyeremail':
                                                            user.email,
                                                        'phone': g.toString(),
                                                        'picked from vendor':
                                                            false,
                                                        'Order Dilevered to Collection Point':
                                                            false,
                                                        'Order Recieved to Collection Point':
                                                            false,
                                                        'Rider': "",
                                                        'shopaddress': widget
                                                            .data.shopaddress,
                                                        'collection point':
                                                            widget.data
                                                                .collectionpoint,
                                                        'PaymentStatus': "paid",
                                                        'total':
                                                            widget.data.total
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection('user')
                                                          .doc(user.email)
                                                          .collection('cart')
                                                          .doc(widget.data.id)
                                                          .delete();
                                                    } else {}
                                                  });
                                                },
                                                padding: EdgeInsets.only(
                                                    left: 48, right: 48),
                                                child: Text(
                                                  "Pay Now",
                                                  style: CustomTextStyle
                                                      .textFormFieldMedium
                                                      .copyWith(
                                                          color: Colors.white),
                                                ),
                                                color: Colors.pink,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                24))),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              errorDialog);
                                    },
                                    child: Text(
                                      "Pay Now",
                                      style: CustomTextStyle.textFormFieldMedium
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )))),
              ],
            ),
          ),
        ));
  }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("images/ic_thank_you.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "\n\nThank you for your purchase. Our company values each and every customer. We strive to provide state-of-the-art devices that respond to our clients’ individual needs. If you have any questions or feedback, please don’t hesitate to reach out.",
                            style: CustomTextStyle.textFormFieldMedium.copyWith(
                                fontSize: 14, color: Colors.grey.shade800),
                          )
                        ])),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BuyerDashboard()));
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Place another order",
                        style: CustomTextStyle.textFormFieldMedium
                            .copyWith(color: Colors.white),
                      ),
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }
}
