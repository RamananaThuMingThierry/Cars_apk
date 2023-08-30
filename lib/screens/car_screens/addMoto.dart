import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/getImage.dart';
import 'package:vision/utils/loading.dart';

class AddMoto extends StatefulWidget {
  const AddMoto({Key? key}) : super(key: key);

  @override
  State<AddMoto> createState() => _AddMotoState();
}

class _AddMotoState extends State<AddMoto> {
  // Déclaration des variables
  final keys = GlobalKey<FormState>();
  String? marque, description, prix, model;
  List<File>? images = []; // Ajouter plusieurs images dans un liste d'image
  Vehicule moto = Vehicule();

  @override
  void initState() {
    moto.type = CarType.moto;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une moto"),
        backgroundColor: Colors.blue,
        actions: [
          Padding(padding: EdgeInsets.only(right: 20), child:  Icon(FontAwesomeIcons.motorcycle),),
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
                    hintText: "Marque du moto",
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
                    hintText: "Prix du moto",
                    labelText: "Prix",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => prix = e!,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description du moto",
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
                          color: Colors.lightBlue,
                          child: Icon(FontAwesomeIcons.plusCircle, color: Colors.white,),
                        ),
                      ),
                    ]
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    color: Colors.blue,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    onPressed: () async{
                      if(keys.currentState!.validate() && images!.length > 0){
                        loading(context);
                        moto.marque = marque!;
                        moto.prix = prix!;
                        moto.model = model!;
                        moto.description = description!;
                        moto.images = [];
                        moto.uid = FirebaseAuth.instance.currentUser!.uid;
                        for(var i = 0; i < images!.length; i++){
                          String? urlImages = await DbServices().uploadImage(images![i], path: "cars");
                          print("La valeur de i = ${i}");
                          if(urlImages != null) moto.images!.add(urlImages);
                        }
                        print("Longueur image est : ${images!.length} \n Longueur liste image est : ${moto.images!.length}");
                        if(images!.length == moto.images!.length){
                          print("Marque du moto, ${moto!.marque}");
                          bool save = await DbServices().saveVehicule(moto);
                          if(save == true){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }else{
                            print("La valeur est false");
                          }
                        }
                      }else{
                        showMessage(context,titre: "Warning",message: "Veuillez ajouter au moins une image!", ok: (){Navigator.pop(context);});
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
}
