import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/screens/car_screens/addCar.dart';
import 'package:vision/utils/vehicule.dart';

class ListCar extends StatefulWidget {
  @override
  State<ListCar> createState() => _ListCarState();
}

class _ListCarState extends State<ListCar> {
  @override
  Widget build(BuildContext context) {

    final List<Vehicule> cars = Provider.of<List<Vehicule>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Liste de voiture"),
      ),
      body: ListView.builder(
        itemCount: cars.length,
          itemBuilder: (ctx, i){
          final car = cars[i];
          return cars == null
             ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
               )
             : Vcard(car: car);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
              return AddCar();
            }));
        },
      ),
    );
  }
}
