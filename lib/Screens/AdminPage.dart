import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pat/Screens/HomeScreen.dart';
import 'package:pat/Screens/LoginScreen.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(AdminPage());
}

class AdminPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: ZoomPageTransitionsBuilder(),TargetPlatform.iOS: ZoomPageTransitionsBuilder()}),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    await auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  final user = FirebaseAuth.instance.currentUser;

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  String result = "Hey there !";
  Map<dynamic,dynamic> exist;
  Iterable<dynamic>key_id,data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String formattedDate = formatter.format(now);
    var dbRef = FirebaseDatabase.instance.reference().child('Presence').child(formattedDate);
    dbRef.orderByKey().once().then((DataSnapshot snapshot){
      if(snapshot.value !=null ){
        print(snapshot.value);
        setState(() {
          exist=snapshot.value;
        });
      }
    });

  }
  Future _scanQR() async {
    var result = await BarcodeScanner.scan();
    String formattedDate = formatter.format(now);

    print(formattedDate);
    print('-----------------------'); // The result type (barcode, cancelled, failed)
    print(result.type); // The result type (barcode, cancelled, failed)
    print(result.rawContent); // The barcode content
    print(result.format); // The barcode format (as enum)
    print(result.formatNote);
    final databasereference = FirebaseDatabase.instance.reference();
    print(user.uid);
    var dat = FirebaseDatabase.instance.reference().child("User").child(user.uid);

    dat.orderByKey().once().then((DataSnapshot snapshot){
      print(snapshot.value);
      if(snapshot != null)  {
        print('val');
        var dbRef = FirebaseDatabase.instance.reference().child('Presence').child(formattedDate).child(result.rawContent);
        dbRef.set({
          "date":formattedDate,
          "present":"true"
        });
      }
      // if(snapshot.value.isNotEmpty){
      //   print(snapshot.value);
      //   Map<dynamic, dynamic> values=snapshot.value;
      //   print(values["email"]);
      // }
    });



  }



  @override
  Widget build(BuildContext context) {
    print('242341234234242314324234234');
    print(exist[]);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR,
        child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 39,),
        backgroundColor: Colors.blueGrey,
        tooltip: 'Scan code',
        elevation: 5,
        splashColor: Colors.grey,
      ),
        appBar: AppBar(
          title: Text('Admin Page'),
        ),
        body: Container(
          child: InkWell(
            onTap: (){
              signOut();
            },
            child: Column(
              children: [
                Container(
                  child: Center(
                    child: Text('Welcome'+user.email),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        signOut();
                      },
                      child: Text('SignOut'),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    result,
                    style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Flexible(
                    child: ListView.builder(
                        itemCount: exist.length,
                        itemBuilder: (context, i ) => new Container(
                          child: Column(
                            children: [
                              Text("Working"),
                            ],
                          ),
                        )
                    )
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}