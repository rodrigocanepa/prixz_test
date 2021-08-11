import 'dart:convert';

import 'package:flutter/material.dart';


class DialogSucess extends StatefulWidget {

  @override
  _DialogSucessState createState() => _DialogSucessState();
}

class _DialogSucessState extends State<DialogSucess> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context){

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // para hacer la carta compacta
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 50.0,
          ),
          SizedBox(height: 10.0),
          Text(
            "INFORMACIÓN GUARDADA EXITOSAMENTE",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 45.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black
              ),
              child: Center(
                child: Text(
                  "ACEPTAR",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }


}
