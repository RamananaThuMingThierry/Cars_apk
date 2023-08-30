import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vision/models/user.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/constant.dart';
import 'package:vision/utils/loading.dart';
import 'package:vision/utils/slider.dart';

class CarDetails extends StatefulWidget {
  // Déclarations des variablres
  Vehicule v;

  CarDetails({required this.v});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {

  UserM? users;

  getUser() async{
    final u = await DbServices().getUser(widget.v.uid!);
    setState(() {
      users = u!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    Color couleur = widget.v.type == CarType.car ? Colors.green : Colors.lightBlue;
    IconData icon = widget.v.type == CarType.car ? FontAwesomeIcons.car : FontAwesomeIcons.motorcycle;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: couleur,
          title: Text("${widget.v.marque}"),
        ),
        body: (users != null)
        ? SingleChildScrollView(
          child: Column(
            children: [
              Carousel(imgs: widget.v.images!),
              SizedBox(height: 10,),
              item(widget.v.marque!, icon),
              item(widget.v.model!, icon),
              item("${widget.v.prix!} Ar", FontAwesomeIcons.coins),
              item("${widget.v.description!}", icon),
               ListTile(
                title: Text("${users!.pseudo}", style: style.copyWith(fontSize: 18),),
                subtitle: Text("${users!.email}"),
                leading: CircleAvatar(
                  backgroundImage:  users!.image != null ? NetworkImage(users!.image!) : null,
                  radius: 18,
                ),
              )
            ],
          ),
        )
        : Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(),)
                ],
            ),
        ),
    );
  }

  ListTile item(String titre, IconData iconData){
    return ListTile(
      leading: Icon(iconData, color: widget.v.type == CarType.car ? Colors.green : Colors.lightBlue,),
      title: Text("${titre}", style: style.copyWith(fontSize: 20),),
    );
  }
}
