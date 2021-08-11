import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as tools;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:prixz_test/Dialogs/dialog_sucess.dart';
import 'package:prixz_test/Dialogs/dialog_tolerance.dart';
import 'package:prixz_test/Models/place_mark_model.dart';
import 'package:prixz_test/Utils/constants.dart';
import 'package:prixz_test/Utils/get_coordinates_from_url.dart';
import 'package:prixz_test/Utils/get_location_util.dart';
import 'package:prixz_test/Utils/shared_info_util.dart';
import 'package:prixz_test/Widgets/logo_widget.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Position _myCurrentLocation;
  bool _loading = true;
  bool inside = false;
  bool fail = false;
  Completer<GoogleMapController> _controller = Completer();
  final MarkerId markerId = MarkerId("myLocation");
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Polygon> polygonSet = <Polygon>{};
  String zone = "";
  Position _lastLocationSaved;
  double tolerance = 5.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50.0),
              Align(
                alignment: Alignment.center,
                child: LogoWidget(
                    width: MediaQuery.of(context).size.width * 0.4,
                    reference: ASSET_LOGO_WHITE
                ),
              ),
              SizedBox(height: 10.0),
              _body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(){
    if(fail){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "No has proporcionado el acceso a la ubicación, por lo que la app no puede funcionar correctamente.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            SizedBox(height: 10.0),
            _buttonRequestAgain()
          ],
        ),
      );

    } else{
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Mapa de referencia",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => DialogTolerance(reload: _reloadWithNewTolerance)
                  );
                },
                child: Text(
                  "Tolerancia en metros: " + tolerance.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              flex: 2,
              child: GoogleMap(
                mapType: MapType.normal,
                polygons: polygonSet,
                initialCameraPosition: CameraPosition(
                  target: LatLng(19.431479743256656, -99.12920105573492),
                  zoom: 14.4746,
                ),
                markers: Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);

                },
              ),
            ),
            Expanded(
                flex: 3,
                child: resultWidget()
            ),
          ],
        ),
      );
    }
  }

  Widget resultWidget(){
    if(_loading){
      return Center(
        child: Text(
          "Cargando datos...",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0
          ),
        ),
      );
    }
    else{
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                inside ? "¡Te encuentras en la zona de entrega! ($zone)" : "Fuera de zona",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: inside ? Colors.green.shade700 : Colors.red.shade700,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buttonChangeLocation(),
              _buttonSaveLocation(),
              _buttonLoadLocation()
            ],
          ),
        ),
      );
    }
  }

  Widget _buttonChangeLocation(){
    return GestureDetector(
      onTap: () async{
        LocationResult result = await showLocationPicker(
          context,
          GOOGLE_API_KEY,
          initialCenter: LatLng(_myCurrentLocation.latitude, _myCurrentLocation.longitude),
          automaticallyAnimateToCurrentLocation: false,
          countries: ['MX'],
          myLocationButtonEnabled: true,
          layersButtonEnabled: true,
        );
        print("result = $result");
        _myCurrentLocation = Position(latitude: result.latLng.latitude, longitude: result.latLng.longitude);
        _reloadInfo();
      },
      child: Container(
        width: 250.0,
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black
        ),
        child: Center(
          child: Text(
            "Cambiar mi ubicación",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonSaveLocation(){
    if(_lastLocationSaved == _myCurrentLocation){
      return Container();
    } else{
      return GestureDetector(
        onTap: () async{
          await SharedInfo().sharedLocationSave(_myCurrentLocation);
          Position positionSaved = await SharedInfo().getLastLocationSaved();
          _lastLocationSaved = positionSaved;
          if(_lastLocationSaved == Position(latitude: 0.0, longitude: 0.0)){
            _lastLocationSaved = null;
          }
          setState(() {});
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => DialogSucess()
          );
        },
        child: Container(
          width: 250.0,
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.black
          ),
          child: Center(
            child: Text(
              "Guardar ubicación",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buttonLoadLocation(){
    if(_lastLocationSaved == null){
      return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Text(
          "Aún no has guardado alguna ubicación",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic
          ),
        ),
      );
    }
    else{
      if(_lastLocationSaved == _myCurrentLocation){
        return Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Text(
            "Estás en el mismo punto de tu ubicación almacenada",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic
            ),
          ),
        );
      } else{
        return GestureDetector(
          onTap: () async{
            Position positionSaved = await SharedInfo().getLastLocationSaved();
            _lastLocationSaved = positionSaved;
            _myCurrentLocation = positionSaved;
            _reloadInfo();
          },
          child: Container(
            width: 250.0,
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.transparent,
              border: Border.all(
                color: Colors.black,
                width: 4.0
              )
            ),
            child: Center(
              child: Text(
                "Colocarme en mi ubicación almacenada",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buttonRequestAgain(){
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen ()
            )
        );
      },
      child: Container(
        width: 250.0,
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black
        ),
        child: Center(
          child: Text(
            "Volver a pedir la solicitud de ubicación",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0
            ),
          ),
        ),
      ),
    );
  }

  _loadInitialData() async {
    try{
      setState(() {
        _loading = true;
      });
      _myCurrentLocation = await GetLocationUtil().determinePosition();
      fail = false;
      _lastLocationSaved = await SharedInfo().getLastLocationSaved();
      if(_lastLocationSaved == Position(latitude: 0.0, longitude: 0.0)){
        _lastLocationSaved = null;
      }
      _reloadInfo();
    } catch(e){
      setState(() {
        fail = true;
        _loading = false;
      });
    }

  }

  _reloadInfo() async{
    setState(() {
      _loading = true;
    });
    final Marker marker  = Marker(
      markerId: markerId,
      position: LatLng(
        _myCurrentLocation.latitude,
        _myCurrentLocation.longitude,
      ),
    );
    final GoogleMapController controller = await _controller.future;
    if(Platform.isIOS){
      Timer(Duration(milliseconds: 500), () async {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            zoom: 14.4746,
            target: LatLng(_myCurrentLocation.latitude, _myCurrentLocation.longitude))
        ));
      });
    } else{
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 14.4746,
          target: LatLng(_myCurrentLocation.latitude, _myCurrentLocation.longitude))
      ));
    }

    setState(() {
      markers[markerId] = marker;
    });
    _checkLocationArea();
  }

  _checkLocationArea() async{
    List<PlaceMarkModel> areas = await GetCoordinatesFromUrl().get();
    inside = false;
    zone = "";
    for(int j = 0; j < areas.length; j++){
      List<tools.LatLng> paths = [];

      for(int i = 0; i < areas[j].coordinates.length; i++){
        paths.add(tools.LatLng(areas[j].coordinates[i].latitude, areas[j].coordinates[i].longitude));
      }
      // Coordinate you want to check if it lies within or near path.
      tools.LatLng point = tools.LatLng(_myCurrentLocation.latitude, _myCurrentLocation.longitude);

      if(tools.PolygonUtil.containsLocation(point, paths, true)){
        inside = true;
        zone = areas[j].name;
      }

      if(!inside){
        if(tools.PolygonUtil.isLocationOnEdge(point, paths, true, tolerance: tolerance)){
          inside = true;
          zone = areas[j].name + " - con tolerancia";
          print("Ubicación almacenada con tolerancia");
        }
      }

    }

    polygonSet.add(Polygon(
        polygonId: PolygonId(areas[0].name),
        points: areas[0].coordinates,
        strokeWidth: 2,
        fillColor: Colors.red.withAlpha(100),
        strokeColor: Colors.red));

    polygonSet.add(Polygon(
        polygonId: PolygonId(areas[1].name),
        points: areas[1].coordinates,
        strokeWidth: 2,
        fillColor: Colors.blue.withAlpha(100),
        strokeColor: Colors.blue));

    setState(() {
      _loading = false;
    });
    print("inside: " + inside.toString());
  }

  _reloadWithNewTolerance(double newTolerance){
    tolerance = newTolerance;
    _reloadInfo();
  }
}
