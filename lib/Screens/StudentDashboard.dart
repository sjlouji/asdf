import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pat/Screens/HomeScreen.dart';
import 'package:pat/Screens/LoginScreen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

void main() {
  runApp(StuDashPage());
}

class StuDashPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;


    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
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
                child: QrImage(
                  data: user.uid,
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}