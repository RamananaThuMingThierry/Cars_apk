import 'package:flutter/material.dart';
import 'package:vision/services/auth.dart';
import 'package:vision/utils/constant.dart';
import 'package:vision/utils/loading.dart';

class Register extends StatefulWidget{
  @override
  RegisterState createState() {
    return RegisterState();
  }

}

class RegisterState extends State<Register>{
  // Déclaration des variables
  AuthServices auth = AuthServices();

  String? pseudo, email, pass, cpass;
  final keys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: keys,
              child: Column(
                children: [
                  Text("Inscription", style: style,),
                  SizedBox(height: 15,),
                  /************** Pseudo **************/
                  TextFormField(
                    onChanged: (e) => pseudo = e,
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? "Champ vide": null,
                    decoration: InputDecoration(
                      hintText: "Entrer votre pseudo",
                      labelText: "Pseudo",
                    ),
                  ),
                  /*********** Email ************/
                  TextFormField(
                    onChanged: (e) => email = e,
                    keyboardType: TextInputType.emailAddress,
                    validator: (e) => e!.isEmpty ? "Champ vide": null,
                    decoration: InputDecoration(
                      hintText: "Entrer votre email",
                      labelText: "Email",
                    ),
                  ),
                  /*********** Mot de passe ************/
                  TextFormField(
                    onChanged: (e) => pass = e,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (e) => e!.isEmpty ? "Champ vide": (e!.length < 6 ? "Le mot de passe doit-être plus de 6 caractère."  : null ),
                    decoration: InputDecoration(
                      hintText: "******",
                      labelText: "Mot de passe",
                    ),
                  ),
                  /*********** Confirmer Mot de passe ************/
                  TextFormField(
                    onChanged: (e) => pass = e,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (e) => e!.isEmpty ? "Champ vide": (e!.length < 6 ? "Le mot de passe doit-être plus de 6 caractère."  : null ),
                    decoration: InputDecoration(
                      hintText: "******",
                      labelText: "Confirmer votre mot de passe",
                    ),
                  ),
                  SizedBox(height: 15,),
                  /*************** Button S'inscrire ***************/
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.brown)),
                      onPressed: () async{
                        if(keys.currentState!.validate()){
                          loading(context);
                          print(email! + " " + pass!);
                          bool register = await auth.signup(email!, pass!, pseudo!);
                          if(register != null){
                            Navigator.of(context).pop();
                            if(register) Navigator.pop(context);
                          }
                        }
                      },
                      child: Text("S'inscrire", style: TextStyle(color: Colors.white),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}