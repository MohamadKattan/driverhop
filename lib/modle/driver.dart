// this class for save data driver commming from Firebase
import 'package:firebase_database/firebase_database.dart';

class Drivers{
  String name;
  String email;
  String phone;
  String id;
  String car;
  String color;
  String number;

  Drivers({this.car,this.color,this.number,this.id,this.email,this.name,this.phone});
  Drivers.fromDataSnapshot(DataSnapshot dataSnapshot){
    id = dataSnapshot.key;
    name= dataSnapshot.value["name"];
    email= dataSnapshot.value["email"];
    phone= dataSnapshot.value["phone"];
    car= dataSnapshot.value["carInfo"]["car"];
    color= dataSnapshot.value["carInfo"]["color"];
    number= dataSnapshot.value["carInfo"]["number"];

  }
}