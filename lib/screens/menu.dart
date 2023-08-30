import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:vision/models/user.dart';
import 'package:vision/screens/login.dart';
import 'package:vision/services/auth.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/getImage.dart';
import 'package:vision/utils/loading.dart';

class Menu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu>{
  // Déclarations des variables
  bool loading = false;
  AuthServices auth = AuthServices();

  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  @override
  void initState() {
    super.initState();
    connectionChecker = InternetConnectionChecker();
    connectionChecker.onStatusChange.listen((status) {
      setState(() {
        connectionStatus = status.toString();
      });
      if (connectionStatus ==
          InternetConnectionStatus.disconnected.toString()) {
        Message(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = UserM.current;
    return Container(
      width: 250,
      color: Colors.white,
      child: ListView(
        children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.brown,
                ),
                accountName: Text("${user!.pseudo ?? "Aucun"}", style: TextStyle(color: Colors.white),),
                accountEmail: Text("${user!.email ?? "Aucun"}",style: TextStyle(color: Colors.white),),
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white70,
                  backgroundImage: (connectionStatus == InternetConnectionStatus.connected.toString()) ? (user!.image != null ? NetworkImage(user.image!) : null): null,
                  child: Stack(
                    children: [
                      if(user.image == null)
                        Center(
                          child: Icon(Icons.person, color: Colors.black,),
                        ),
                        if(loading)
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                            ),
                          ),
                          Positioned(
                          top: 40,
                          left: 30,
                          child: IconButton(
                            onPressed: () async{
                              final data = await
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx){
                                    return GetImage();
                                  });
                                  if(data != null){
                                loading  = true;
                                setState(() {
                                });
                                String? urlImage = await DbServices().uploadImage(data ,path: "profil");
                                print(urlImage!);
                                if(urlImage != null){
                                  UserM.current!.image = urlImage;
                                  print(urlImage);
                                  bool isupdate = await DbServices().updateUser(UserM.current!);
                                  if(isupdate){
                                    loading = false;
                                    setState(() {
                                    });
                                  }
                                }
                              }
                            },
                            icon: Icon(Icons.camera_alt, color: Colors.white,),
                          ),
                        ),
                    ],
                  ),
                ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Déconnection"),
              onTap: () => showMessage(
                    context,
                    ok:  () async {
                      await auth.signOut();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    titre: "Déconnection",
                    message: "Voulez-vous vous déconnecter ?"
              ),
            )
        ],
      ),
    );
  }
}