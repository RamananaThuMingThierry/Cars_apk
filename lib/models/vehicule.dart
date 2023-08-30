class Vehicule{
  List<String>? images;
  String? marque;
  String? model;
  String? prix;
  String? description;
  CarType? type;
  String? uid;
  String? id;

  Vehicule({this.id, this.marque, this.model, this.prix, this.description, this.images, this.type, this.uid});

  factory Vehicule.fromJson(Map<String, dynamic> map, {String? id}) => Vehicule(
    id : id,
    marque: map["marque"],
    model: map["model"],
    prix: map["prix"],
    uid: map["uid"],
    description: map["description"],
    images: map["images"].map<String>((i) => i as String).toList(),
    type: map["type"] == "car" ? CarType.car : CarType.moto,
  );

  Map<String, dynamic> toMap(){
    return {
      "type" : type == CarType.car ? "car" : "moto",
      "images" : images,
      "marque" : marque,
      "model" : model,
      "prix" : prix,
      "uid" : uid,
      "description" : description
    };
  }
}

enum CarType {car, moto}