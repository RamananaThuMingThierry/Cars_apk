import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/getImage.dart';
import 'package:vision/utils/loading.dart';

class AddCar extends StatefulWidget {
  const AddCar({Key? key}) : super(key: key);

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  // Déclaration des variables
  final keys = GlobalKey<FormState>();
  String? marque, description, prix, model;
  List<File>? images = []; // Ajouter plusieurs images dans un liste d'image
  Vehicule car = Vehicule();

  @override
  void initState() {
    super.initState();
    car.type = CarType.car;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une voiture"),
        backgroundColor: Colors.green,
        actions: [
          Padding(padding: EdgeInsets.only(right: 20), child:  Icon(FontAwesomeIcons.car),),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: keys,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Marque du véhicule",
                    labelText: "Marque",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => marque = e!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Model du véhicule",
                    labelText: "Model",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => model = e!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Prix du véhicule",
                    labelText: "Prix",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => prix = e!,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description du véhicule",
                    labelText: "Description",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => description = e!,
                  maxLines: 5,
                ),
                SizedBox(height: 7,),
                Wrap(
                  children: [
                    for(int i = 0; i < images!.length; i++)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.4),
                        ),
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.only(right: 5, bottom: 5),
                        child: Stack(
                            children : [
                              Image.file(images![i]),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                 icon: Icon(FontAwesomeIcons.minusCircle, color: Colors.white,),
                                 onPressed: (){
                                   // Supprimer une image dans la list Image
                                   setState(() {
                                     images!.removeAt(i);
                                   });
                                 },
                                ),
                              )
                              ],
                        ),),
                    InkWell(
                      onTap: () async{
                        final data = await
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx){
                              return GetImage();
                            });
                        if(data != null)
                          setState(() {
                            images!.add(data);
                          });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.green,
                        child: Icon(FontAwesomeIcons.plusCircle, color: Colors.white,),
                      ),
                    ),
                  ]
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    color: Colors.green,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    onPressed: () async{
                      if(keys.currentState!.validate() && images!.length > 0){
                        loading(context);
                        car.marque = marque!;
                        car.prix = prix!;
                        car.model = model!;
                        car.description = description!;
                        car.uid = FirebaseAuth.instance.currentUser!.uid;
                        car.images = [];
                        for(var i = 0; i < images!.length; i++){
                          String? urlImages = await DbServices().uploadImage(images![i], path: "cars");
                          print("La valeur de i = ${i}");
                          if(urlImages != null) car.images!.add(urlImages);
                        }
                        print("Longueur image est : ${images!.length} \n Longueur liste image est : ${car.images!.length}");
                        if(images!.length == car.images!.length){
                          print("Marque voiture ${car!.marque}");
                          bool save = await DbServices().saveVehicule(car);
                          if(save == true){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }else{
                            print("La valeur est false");
                          }
                        }
                      }else{
                        _showDialog(context,"Warning", "Veuillez ajouter au moins une image!");
                      }
                  },
                    child: Text("Enregistrer", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context,String titre, String message){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            title: Text(titre, style: TextStyle(color: Colors.brown),textAlign: TextAlign.center,),
            content: Text(message, style: TextStyle(color: Colors.grey,), textAlign: TextAlign.center,),
            actions: [
              TextButton(
                  onPressed: () async{
                    Navigator.of(context).pop();
                  },
                  child: Text("oui", style: TextStyle(color: Colors.lightBlue),)),
            ],
          );
        });
  }
}
