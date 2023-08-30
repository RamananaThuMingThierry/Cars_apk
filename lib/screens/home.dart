import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:vision/models/user.dart';
import 'package:vision/models/vehicule.dart';
import 'package:vision/screens/car_screens/addCar.dart';
import 'package:vision/screens/car_screens/addMoto.dart';
import 'package:vision/screens/car_screens/listcar.dart';
import 'package:vision/screens/car_screens/listmoto.dart';
import 'package:vision/screens/menu.dart';
import 'package:vision/services/auth.dart';
import 'package:vision/services/db.dart';
import 'package:vision/utils/constant.dart';
import 'package:vision/utils/loading.dart';
import 'package:vision/utils/slider.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin{
  // Déclaration des variables
  UserM? userm;
  AuthServices auth = AuthServices();
  final keys = GlobalKey<ScaffoldState>();
  Animation<double>? animation;
  List imgs = [];
  AnimationController? _animationController;

  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  Future<void> getUser() async{
    User? user = await auth.user;
    final userResult = await DbServices().getUser(user!.uid);
    setState(() {
      userm = userResult;
      UserM.current = userResult;
    });
  }

  get getCarouselImage async{
    final img = await DbServices().getCarouselImage;
    setState(() {
      imgs = img!;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(microseconds: 250)
    );
    final curve = CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut);
    animation = Tween<double>(begin: 0, end: 1).animate(curve);
    getCarouselImage;
    super.initState();
    getUser();
    /********************* Connection internet ******************/
    connectionChecker = InternetConnectionChecker();
    connectionChecker.onStatusChange.listen((status) {
      setState(() {
        connectionStatus = status.toString();
      });
      if(connectionStatus == InternetConnectionStatus.disconnected.toString()){
        Message(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keys,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Text("Accueil", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.person)),
        ],
      ),
      drawer: Menu(),
      body: ((connectionStatus == InternetConnectionStatus.disconnected.toString()))
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
              ),
            )
          :  Column(
        children: [
          Carousel(imgs: imgs,),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext b){
                      return StreamProvider<List<Vehicule>>.value(
                        child: ListCar(),
                        value: DbServices().getVehicule,
                        initialData: [],
                      );
                    }));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(FontAwesomeIcons.car, size: 30,color: Colors.white,),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext b){
                      return StreamProvider<List<Vehicule>>.value(
                        child: ListMoto(),
                        value: DbServices().getVehicule,
                        initialData: [],
                      );
                    }));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.lightBlue,
                    child: Icon(FontAwesomeIcons.motorcycle, size: 30, color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
             floatingActionButton: FloatingActionBubble(
        backGroundColor: Colors.brown,
        items: [
          Bubble(
              icon: FontAwesomeIcons.car,
              iconColor: Colors.white,
              title: "Voiture",
              titleStyle: style.copyWith(fontSize: 16, color: Colors.white),
              bubbleColor: Colors.green,
              onPress: (){
                _animationController!.reverse();
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext b){
                  return AddCar();
                }));
              }
          ),
          Bubble(
              icon: FontAwesomeIcons.motorcycle,
              iconColor: Colors.white,
              title: "Moto",
              titleStyle: style.copyWith(fontSize: 16, color: Colors.white),
              bubbleColor: Colors.lightBlue,
              onPress: (){
                _animationController!.reverse();
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext b){
                  return AddMoto();
                }));
              }
          ),
        ],
        onPress: _animationController!.isCompleted
            ? _animationController!.reverse
            : _animationController!.forward,
        animation: animation!,
        iconColor: Colors.white,
        animatedIconData: AnimatedIcons.add_event,
      ),
    );
  }
}