import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision/models/user.dart';
import 'package:path/path.dart' as Path;
import 'package:vision/models/vehicule.dart';

class DbServices{

  final CollectionReference userCol = FirebaseFirestore.instance.collection("users");
  final CollectionReference vehiculeCol = FirebaseFirestore.instance.collection("vehicule");
  final CollectionReference carouselCol = FirebaseFirestore.instance.collection("carousel");

  Future saveUser(UserM user) async{
    try{
      await userCol.doc(user.id).set(user.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future saveVehicule(Vehicule vehicule) async{
    try{
      await vehiculeCol.doc().set(vehicule.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future updateVehicule(Vehicule vehicule) async{
    try{
      await vehiculeCol.doc(vehicule.id).update(vehicule.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future deleteVehicule(String id) async{
    try{
      await vehiculeCol.doc(id).delete();
      return true;
    }catch(e){
      return false;
    }
  }

  Stream<List<Vehicule>> get getVehicule{
    return vehiculeCol.snapshots().map((vehicule){
      return vehicule.docs.map((e) {
          return Vehicule.fromJson(e.data() as Map<String, dynamic>, id: e.id);
      }).toList();
    });
  }

  Future<UserM?> getUser(String id) async{
      final donne = await userCol.doc(id).get();
      final user = UserM.fromJson(donne.data() as Map<String, dynamic>);
      if(user == null){
        return null;
      }
      return user;
  }

  Future<bool> updateUser(UserM userM) async{
    try{
      await userCol.doc(userM.id).update(userM.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future<String?> uploadImage(File file, {String? path}) async{
    var time = DateTime.now().toString();
    var ext = Path.basename(file.path).split(".")[1].toString();
    String image = path! + "_" + time + "." + ext;
    try{
       Reference ref = FirebaseStorage.instance.ref().child(path! + "/" + image);
       UploadTask uploadTask = ref.putFile(file);
       return await uploadTask.then((res) => res.ref.getDownloadURL());
    }catch(e){
      return null;
    }
  }

  Future<List<String>?> get getCarouselImage async{
    try{
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference imagesRef = storage.ref().child('carousel');
      final ListResult result = await imagesRef.listAll();
      final List<String> imageURLs = [];
      for (final Reference ref in result.items) {
        final String downloadURL = await ref.getDownloadURL();
        imageURLs.add(downloadURL);
      }
      return imageURLs;
    }catch(e){
      return null;
    }
  }
}