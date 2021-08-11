import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMarkModel{

  String name;
  List<LatLng> coordinates;

  PlaceMarkModel({this.name, this.coordinates});

  // Mapping json data
  factory PlaceMarkModel.fromJson(Map<String, dynamic> jsonMap){
    /*
                    -99.1638816,19.4638269,0\\n                -99.1793311,19.4230352,0\\n                -99.1721213,19.4524969,0\\n                -99.2002738,19.4557341,0\\n                -99.2198432,19.4369573,0\\n                -99.2414725,19.4100834,0\\n                -99.2438758,19.3916252,0\\n                -99.2301429,19.3741365,0\\n                -99.21641,19.3592373,0\\n                -99.1958106,19.3864435,0\\n                -99.1927207,19.3663632,0\\n                -99.2119468,19.3530829,0\\n                -99.2043937,19.3446606,0\\n                -99.193064,19.3326744,0\\n                -99.1889441,19.3090234,0\\n                -99.1539252,19.2983307,0\\n                -99.139849,19.3099954,0\\n                -99.0880072,19.3216593,0\\n                -99.095217,19.3466043,0\\n                -99.0608847,19.3585895,0\\n                -99.0608847,19.3900059,0\\n                -99.0567649,19.4084643,0\\n                -99.0519584,19.4330722,0\\n                -99.0231192,19.4887501,0\\n                -99.0135062,19.5418204,0\\n                -99.0238059,19.570937,0\\n                -99.0588248,19.5482912,0\\n                -99.0794242,19.5521736,0\\n                -99.0993369,19.4816295,0\\n                -99.1089499,19.4842189,0\\n                -99.1055167,19.4991066,0\\n                -99.1027701,19.5230536,0\\n                -99.1206229,19.539232,0\\n                -99.1412223,19.5379378,0\\n                -99.1968406,19.5508795,0\\n                -99.2373526,19.513993,0\\n                -99.2421592,19.4602661,0\\n                -99.2112601,19.4874554,0\\n                -99.1851676,19.4783928,0\\n                -99.1638816,19.4638269,0\\n
     */
    String coordinatesPre = jsonMap['Polygon']['outerBoundaryIs']['LinearRing']['coordinates']['\$t'];
    coordinatesPre = coordinatesPre.replaceAll("\\n", "");
    List<String> coordinatesList = coordinatesPre.split(",0\\");
    List<LatLng> positions = [];
    coordinatesList.forEach((element) {
      if(element.contains(",")){
        element = element.trim();
        double lat = double.parse(element.split(",")[1]);
        double lng = double.parse(element.split(",")[0]);
        positions.add(LatLng(lat, lng));
      }
    });

    PlaceMarkModel placeMarkModel = PlaceMarkModel(
        name: jsonMap['name']['\$t'],
        coordinates: positions
    );

    return placeMarkModel;
  }
}