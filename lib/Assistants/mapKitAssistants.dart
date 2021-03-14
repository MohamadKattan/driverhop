// this class when rider move for update location on map from point to point
import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant
{
  static double getMarkerLocation(sLat,sLng,dLat,dLng)
  {
    var rot =SphericalUtil.computeHeading(LatLng(sLat, sLng), LatLng(dLat, dLng));
    return rot;
  }
}