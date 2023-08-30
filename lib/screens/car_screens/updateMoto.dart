import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/getImage.dart';
import 'package:vision/utils/loading.dart';

class UpdateMoto extends StatefulWidget {
  Vehicule v;

  UpdateMoto({required this.v});

  @override
  State<UpdateMoto> createState() => _UpdateMotoState();
}

class _UpdateMotoState extends State<UpdateMoto> {
  // Déclaration des variables
  final keys = GlobalKey<FormState>();
  String? marque, description, prix, model;
  List<dynamic>? images = []; // Ajouter plusieurs images dans un liste d'image
  Vehicule moto = Vehicule();

  @override
  void initState() {
    moto.type = CarType.moto;
    super.initState();
    marque = widget.v.marque;
    model = widget.v.model;
    prix = widget.v.prix;
    description = widget.v.description;
    images = widget.v.images;
    moto = widget.v;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier ${widget.v.marque}"),
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
                  initialValue: marque,
                  decoration: InputDecoration(
                    hintText: "Marque du moto",
                    labelText: "Marque",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => marque = e!,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  initialValue: model,
                  decoration: InputDecoration(
                    hintText: "Model du moto",
                    labelText: "Model",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => model = e!,
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  initialValue: model,
                  decoration: InputDecoration(
                    hintText: "Prix du moto",
                    labelText: "Prix",
                  ),
                  validator: (e) => e!.isEmpty ? "Champ vide !" : null,
                  onChanged: (e) => prix = e!,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  initialValue: description,
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
                              if(images![i] is File)
                                Image.file(images![i], fit: BoxFit.fitHeight,)
                              else
                                Image.network(images![i], fit: BoxFit.fitHeight,),
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
                          print(data);
                          if(data != null) {
                            setState(() {
                              images!.add(data);
                              print("Image été ajouter");
                            });
                          }
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
                          if(images![i] is File){
                            String? urlImages = await DbServices().uploadImage(images![i], path: "moto");
                            print("La valeur de i = ${i}");
                            if(urlImages != null) moto.images!.add(urlImages);
                          }else{
                            moto.images!.add(images![i]);
                          }
                        }
                        print("Longueur image est : ${images!.length} \n Longueur liste image est : ${moto.images!.length}");
                        if(images!.length == moto.images!.length){
                          print("Marque du moto, ${moto!.marque}");
                          bool update = await DbServices().updateVehicule(moto);
                          if(update == true){
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
                    child: Text("Modifier", style: TextStyle(color: Colors.white),),
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
