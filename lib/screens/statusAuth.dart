import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vision/screens/home.dart';
import 'package:vision/screens/login.dart';
import 'package:vision/services/auth.dart';

class Status extends StatefulWidget{
  @override
  StatusState createState() {
    return StatusState();
  }
}

class StatusState extends State<Status>{
  // Déclaration des variables
  User? user;
  AuthServices auth = AuthServices();

  Future<void> getUser() async {
    final userResult = await auth.user;
    setState(() {
      user = userResult;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Home();
        }else{
          return Login();
        }
      });
  }
}