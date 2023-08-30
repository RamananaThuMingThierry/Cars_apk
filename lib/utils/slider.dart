import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vision/utils/loading.dart';

class Carousel extends StatelessWidget{

  List imgs;
  Carousel({required this.imgs});

  @override
  Widget build(BuildContext context) {
      return  (imgs == null)
                ? loading(context)
                : Stack(
        children: [CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            aspectRatio: 16/9,
            enlargeCenterPage: true,
            viewportFraction: 1,
          ), itemCount: imgs.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            if(imgs.length  > index){
              return Container(
                child: Image(
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(imgs[index]),
                ),
              );
            }else{
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child:CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              );
            }
          }
        ),],
      );
  }
}