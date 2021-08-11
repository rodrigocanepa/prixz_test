import 'package:flutter/material.dart';

class LogoWidget extends StatefulWidget {

  double width;
  String reference;
  LogoWidget({@required this.width, @required this.reference});

  @override
  _LogoWidgetState createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {


  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.reference,
      width: widget.width,
      fit: BoxFit.fitWidth,
    );
  }
}
