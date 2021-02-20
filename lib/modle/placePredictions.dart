// this class for save data what it will come from places api
class PlacePredictions {
  String place_id;
  String main_text;
  String secondary_text;
  PlacePredictions({this.main_text, this.place_id, this.secondary_text});
  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_id = json['place_id'];
    main_text = json["structured_formatting"]['main_text'];
    secondary_text = json["structured_formatting"]['secondary_text'];
  }
}
