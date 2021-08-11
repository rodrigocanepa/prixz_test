import 'dart:convert';

import 'package:prixz_test/Models/place_mark_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import 'constants.dart';

class GetCoordinatesFromUrl{

  List<PlaceMarkModel> placeList = [];

  Future<List<PlaceMarkModel>> get() async {
    final Xml2Json xml2Json = Xml2Json();
    var url = Uri.parse(GOOGLE_MAPS_AREA_TO_CHECK);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    xml2Json.parse(response.body);
    var gdata = xml2Json.toGData();
    var jsondata = json.decode(gdata);
    var jsonList = jsondata["kml"]["Document"]["Folder"][1]["Placemark"] as List;

    List<PlaceMarkModel> places = jsonList.map((i)=>PlaceMarkModel.fromJson(i)).toList();
    return places;
  }
}