import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:vision/screens/register.dart';
import 'package:vision/services/auth.dart';
import 'package:vision/utils/constant.dart';
import 'package:vision/utils/loading.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}

class LoginState extends State<Login> {
  // Déclaration des variables
  AuthServices auth = AuthServices();

  String? email, pass;
  final keys = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Login", style: TextStyle(color: Colors.white),),
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
                  Text("Login", style: style,),
                  SizedBox(height: 15,),
                  /*********** Email ************/
                  TextFormField(
                    onChanged: (e) => email = e,
                    keyboardType: TextInputType.emailAddress,
                    validator: (e) => e!.isEmpty ? "Champ vide" : null,
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
                    validator: (e) =>
                    e!.isEmpty ? "Champ vide" : (e!.length < 6
                        ? "Le mot de passe doit-être plus de 6 caractère."
                        : null),
                    decoration: InputDecoration(
                      hintText: "******",
                      labelText: "Mot de passe",
                    ),
                  ),
                  SizedBox(height: 15,),
                  /*************** Button de connection ***************/
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.brown)),
                      onPressed: () async {
                        if (keys.currentState!.validate()) {
                          if (connectionStatus ==
                              InternetConnectionStatus.disconnected
                                  .toString()) {
                            Message(context);
                          } else {
                            loading(context);
                            bool login = await auth.signin(email!, pass!);
                            if (!login) {
                              Navigator.pop(context);
                              showMessage(
                                  context,
                                  titre: "Erreur",
                                  message: "email ou mot de passe incorrect!",
                                  ok: () {
                                    Navigator.pop(context);
                                  }
                              );
                            } else {
                              Navigator.pop(context);
                              print("Connecter");
                            }
                          }
                        }
                      },
                      child: Text(
                        "Connecter", style: TextStyle(color: Colors.white),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Avez-vous un compte ?"),
                      TextButton(
                          onPressed: () =>
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (ctx) => Register())),
                          child: Text("s'inscrire", style: TextStyle(
                              color: Colors.brown, fontSize: 12),)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}