import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/screens/car_screens/addMoto.dart';
import 'package:vision/utils/loading.dart';
import 'package:vision/utils/vehicule.dart';

class ListMoto extends StatefulWidget {
  @override
  State<ListMoto> createState() => _ListMotoState();
}

class _ListMotoState extends State<ListMoto> {


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
    final List<Vehicule> motos = Provider.of<List<Vehicule>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Liste de moto"),
      ),
      body: (connectionStatus == InternetConnectionStatus.connected.toString())
          ? ListView.builder(
          itemCount: motos.length,
          itemBuilder: (ctx, i){
            final moto = motos[i];
            return moto == null
                ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                : Vcard(car: moto, type: CarType.moto,);
          })
          : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
                  return AddMoto();
                }));
              },
            ),
    );
  }
}
