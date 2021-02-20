import 'package:driverhop/Assistants/requestAssistant.dart';
import 'package:driverhop/configMap.dart';
import 'package:driverhop/modle/address.dart';
import 'package:driverhop/modle/placePredictions.dart';
import 'package:driverhop/provider/appData.dart';
import 'package:driverhop/widget/divider.dart';
import 'package:driverhop/widget/progssesDailgo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const String screenId = 'SearchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionsList = [];

  @override
  Widget build(BuildContext context) {
    String pickAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = pickAddress;
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 5.0,
      ),
      Flexible(
        child: Container(
          height: MediaQuery.of(context).size.height * 35 / 100,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.5,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            )
          ]),
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                      height: 16,
                    ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back, color: Colors.black)),
                      SizedBox(
                        width: 80,
                      ),
                      Center(
                          child: Text(
                        'Start drop off',
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                  hintText: 'PickUp your location',
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, right: 8.0)),
                            )),
                      ),
                    ),
                  ]),
                  SizedBox(height: 10.0),
                  Row(children: [
                    Icon(
                      Icons.add_location_sharp,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropTextEditingController,
                              decoration: InputDecoration(
                                  hintText: 'where to ? ',
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, right: 8.0)),
                            )),
                      ),
                    ),
                  ])
                ]),
              )),
        ),
      ),
      (placePredictionsList.length > 0)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                  return PredictionsTitle(
                      placePredictions: placePredictionsList[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    DivederWidget(),
                itemCount: placePredictionsList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            )
          : Container(),
    ]));
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      // frist got url from:https://developers.google.com/places/web-service/autocomplete?hl=en_US
      String autoPlaceUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:tr";
      // call RequestAssistant.getRequest();
      var res = await RequestAssistant.getRequest(autoPlaceUrl);
      // check if respons failed or don
      if (res == 'failed') {
        return;
      } else {
        if (res["status"] == "OK") {
          var predictions = res["predictions"];
          var placeList = (predictions as List)
              .map((e) => PlacePredictions.fromJson(e))
              .toList();
          setState(() {
            placePredictionsList = placeList;
          });
        }
      }
    }
  }
}

// this class predictionsTitle it will be in list view for show resullt serach drop to rider

class PredictionsTitle extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredictionsTitle({Key key, this.placePredictions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceDiatels(placePredictions.place_id, context);
      },
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.add_location),
                  SizedBox(
                    width: 14.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placePredictions.main_text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          placePredictions.secondary_text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // this method for get details place  what user drop from :https://developers.google.com/places/web-service/details?hl=en_US
  void getPlaceDiatels(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgssesDailgo(
              message: 'Palace wait',
            ));
    String placeDiatelsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getRequest(placeDiatelsUrl);
    Navigator.pop(context);
    if (res == 'failed') {
      return;
    } else {
      if (res["status"] == "OK") {
        Address address = Address();
        address.placeId = placeId;
        address.placeName = res["result"]["name"];
        address.latitude = res["result"]["geometry"]["location"]["lat"];
        address.longitude = res["result"]["geometry"]["location"]["lng"];
        Provider.of<AppData>(context, listen: false)
            .updateDropOffLocation(address);
        print("getPlaceDiatels::");
        print(address.placeName);
        Navigator.pop(context, "obtainDirection");
      }
    }
  }
}
