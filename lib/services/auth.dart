// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision/services/db.dart';

import '../models/user.dart';

class AuthServices{
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signinAnonymous() async{
    try{
        final result = await auth.signInAnonymously();
        return result.user;
    }catch(e){
        print(e);
    }
  }

  Future<User?> get user async{
    // Envoyer l'utilisateur connecter
    final user = await FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<bool> signup(String email, String pass, String pseudo) async{
   try{
      final result = await auth.createUserWithEmailAndPassword(email: email, password: pass);
      if(result.user != null){
        await DbServices().saveUser(UserM(id: result.user!.uid, email: email, pseudo: pseudo));
        return true;
      }else{
        return false;
      }
   }catch(e){
     return false;
    }
  }

  Future<bool> signin(String email, String pass) async{
    try{
      final result = await auth.signInWithEmailAndPassword(email: email, password: pass);
      if(result != null){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future signOut() async{
    try{
      return auth.signOut();
    }catch(e){
      return null;
    }
  }
}