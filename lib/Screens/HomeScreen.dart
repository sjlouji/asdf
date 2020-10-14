import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pat/Screens/AdminPage.dart';
import 'package:pat/Screens/LoginScreen.dart';
import 'package:pat/Screens/RegisterScreen.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'StudentDashboard.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(FirebaseAuth.instance.currentUser != null){
      final user = FirebaseAuth.instance.currentUser;
      var dbRef = FirebaseDatabase.instance.reference().child("User").child(user.uid);
      print("======");
      print(dbRef);
      print(user);
      dbRef.orderByKey().once().then((DataSnapshot snapshot){
        if(snapshot != null){
          print(snapshot.value);
          Map<dynamic, dynamic> values=snapshot.value;
          print(values["email"]);
          if(values['isAdmin']=='true'){
            print('====================');
            print('admin');
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
          }
          else{
            print('====================');
            print('student');
            Navigator.push(context, MaterialPageRoute(builder: (context) => StuDashPage()));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 700,
                  child: Image.asset('Assets/Main.jpg'),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text('Welcome', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    Text('Create an account and access the dashboard page', style: TextStyle(color: Colors.grey[600]),),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Text('Getting Started'),
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        },
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: Text("Already have an account ? Log In")
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}