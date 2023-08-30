import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/screens/car_screens/carDetails.dart';
import 'package:vision/screens/car_screens/updateMoto.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/loading.dart';

class Vcard extends StatelessWidget{
  Vehicule? car;
  Vcard({this.car, this.type = CarType.car});
  CarType? type;
  @override
  Widget build(BuildContext context){
    if(type == CarType.car){
      return car!.type == CarType.car
          ? Card(
            child: ListTile(
              onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
              return CarDetails(v: car!);
            }));
        },
               subtitle: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("${car!.model}"),
                   Row(
                     children: [
                       IconButton(
                           onPressed: (){},
                           icon: Icon(FontAwesomeIcons.solidThumbsUp, size: 20, color: Colors.grey,)),
                       Text("1"),
                       SizedBox(width: 10,),
                       IconButton(
                           onPressed: (){},
                           icon: Icon(FontAwesomeIcons.solidThumbsDown, size: 20, color: Colors.grey,)),
                       Text("1"),
                     ],
                   ),
                 ],
               ),
              title: Text("${car!.marque}"),
              leading: Container(
            child: Image(
              height: 70,
              width: 50,
              fit: BoxFit.fitHeight,
              image: NetworkImage(car!.images!.first),
            ),
        ),
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                onSelected: (dynamic value){
                  if(value == "modifier"){
                    //_ajouterPersonnes(personne);
                  }else{
                    showMessage(context, titre: "Suppression",message: "Voulez-vous supprimer ${car!.marque} ?", ok: () async{
                      Navigator.pop(context);
                      await DbServices().deleteVehicule(car!.id!);
                    });
                  }
                },
                itemBuilder: (context){
                  List<PopupMenuEntry<Object>> list = [];
                  list.add(
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.blueGrey,),
                        title: Text("Modifier"),
                      ),
                      value: "modifier",
                    ),
                  );
                  list.add(
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.redAccent,),
                        title: Text("Supprimer"),
                      ),
                      value: "supprimer",
                    ),
                  );
                  return list;
                },
              ),
             ),
            )
          : Container(
      );
    }else{
      return car!.type == CarType.moto
          ? Card(
              child: ListTile(
        onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
              return CarDetails(v: car!);
            }));
        },
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${car!.model}"),
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: Icon(FontAwesomeIcons.solidThumbsUp, size: 20, color: Colors.grey,)),
                        Text("1"),
                        SizedBox(width: 10,),
                        IconButton(
                            onPressed: (){},
                            icon: Icon(FontAwesomeIcons.solidThumbsDown, size: 20, color: Colors.grey,)),
                        Text("1"),
                      ],
                    ),
                  ],
                ),
                title: Text("${car!.marque}"),
        leading: Container(
            child: Image(
              height: 50,
              width: 50,
              image: NetworkImage(car!.images!.first),
            ),
        ),
                trailing: car!.uid == FirebaseAuth.instance.currentUser!.uid ? PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                  onSelected: (dynamic value){
                    if(value == "modifier"){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
                        return UpdateMoto(v: car!,);
                      }));
                    }else{
                      showMessage(context, titre: "Suppression",message: "Voulez-vous supprimer ${car!.marque} ?", ok: () async{
                          Navigator.pop(context);
                          await DbServices().deleteVehicule(car!.id!);
                      });
                    }
                  },
                  itemBuilder: (context){
                    List<PopupMenuEntry<Object>> list = [];
                    list.add(
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.edit, color: Colors.blueGrey,),
                          title: Text("Modifier"),
                        ),
                        value: "modifier",
                      ),
                    );
                    list.add(
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.redAccent,),
                          title: Text("Supprimer"),
                        ),
                        value: "supprimer",
                      ),
                    );
                    return list;
                  },
                ) : null,
        ),
            )
          : Container(
      );
    }
  }
}