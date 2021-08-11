import 'package:flutter/material.dart';
import 'package:prixz_test/Utils/constants.dart';
import 'package:prixz_test/Utils/timer_util.dart';
import 'package:prixz_test/Widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Aquí inicializamos esta clase que tiene un método para simular la carga de datos en una pantalla splash y posteriormente mostrar la pantalla principal
    TimerUtil().startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LogoWidget(
                width: MediaQuery.of(context).size.width * 0.6,
                reference: ASSET_LOGO_BLACK
            ),
            SizedBox(height: 10.0),
            _subtitleWidget("PRUEBA TÉCNICA", 20.0),
            _subtitleWidget("ING. RODRIGO IVÁN CANEPA CRUZ", 16)
          ],
        ),
      ),
    );
  }

  Widget _subtitleWidget(String text, double size){
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
    );
  }
}
