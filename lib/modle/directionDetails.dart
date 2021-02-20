// this class for save data what it will come from Direction api

class DirectionDetails {
  int durationValue;
  String durationText;
  int distanceValue;
  String distanceText;
  String encodedPoints;
  DirectionDetails(
      {this.distanceText,
        this.distanceValue,
        this.durationText,
        this.durationValue,
        this.encodedPoints});
}
