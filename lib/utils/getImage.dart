import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends StatelessWidget{
  // Déclaration des variables

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.brown,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "Photo de profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: ()async{
                    final result = await picker.getImage(source: ImageSource.camera);
                    Navigator.of(context).pop(File(result!.path));
                  },
                  color: Colors.white,
                  icon: Icon(Icons.camera_alt, color: Colors.brown,),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () async{
                    final result = await picker.getImage(source: ImageSource.gallery);
                    Navigator.of(context).pop(File(result!.path));
                  },
                  icon: Icon(Icons.photo_library, color: Colors.brown,),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}