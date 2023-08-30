import 'package:flutter/material.dart';
import 'package:vision/utils/constant.dart';

loading(context) => showDialog(
  context: context,
  builder: (BuildContext context){
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      contentPadding: EdgeInsets.all(0.0),
      insetPadding: EdgeInsets.symmetric(horizontal: 100),
      content: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.blueGrey,),
            SizedBox(height: 16,),
            Text("Veuillez patientez...", style: TextStyle(color: Colors.grey),)
          ],
        ),
      ),
    );
  }
);

showMessage(BuildContext context,{String? titre, String? message, VoidCallback? ok}) async =>
showDialog(
  context: context,
  builder: (ctx){
    return AlertDialog(
      title: Text(titre!, style: TextStyle(color: Colors.brown),textAlign: TextAlign.center,),
      content: Text(message!, style: TextStyle(color: Colors.grey,), textAlign: TextAlign.center,),
      actions: [
        TextButton(
        onPressed: ok,
        child: Text("oui", style: TextStyle(color: Colors.lightBlue),)),
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("non", style: TextStyle(color: Colors.redAccent),)),
    ],
  );
});



Message(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext ctx){
        return AlertDialog(
          title: Row( mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.wifi_off, size: 80,color: Colors.brown,),],),
          content: Text("Pas de connection à internet", style: style.copyWith(color: Colors.grey,fontSize: 18),textAlign: TextAlign.center,),
          actions: [
            TextButton(
                onPressed: (){Navigator.pop(context);},
                child: Text("OK")),
          ],
        );
      });
}

