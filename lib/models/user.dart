class UserM{
  String? id, pseudo, email, image;
  UserM({this.id, this.pseudo, this.email, this.image});

  static UserM? current;

  factory UserM.fromJson(Map<String, dynamic> j){
    return UserM(
        email: j['email'],
        pseudo: j['pseudo'],
        image: j['image'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {"id": id, "pseudo" : pseudo, "email" : email, "image": image};
}