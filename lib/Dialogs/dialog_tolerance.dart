import 'package:flutter/material.dart';

class DialogTolerance extends StatefulWidget {

  Function reload;
  DialogTolerance({this.reload});

  @override
  _DialogToleranceState createState() => _DialogToleranceState();
}

class _DialogToleranceState extends State<DialogTolerance> {

  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

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
        mainAxisSize: MainAxisSize.min, // para hacer la carta compacta
        children: <Widget>[
          Text(
            "TOLERANCIA",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              "Por favor, introduzca la tolerancia hacia fuera del polígono que desee en metros",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          _categoryField(),
          SizedBox(
            height: 30.0,
          ),
          _btnSave(),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _categoryField(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _controller,
                  //obscureText: true,

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.white
                      )
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          )
      ),
    );
  }

  Widget _btnSave(){
    return Container(
      height: 42.0,
      width: 220.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          if(_controller.text.length > 0){
            double num = double.tryParse(_controller.text.trim());
            if(num != null){
              widget.reload(num);
              Navigator.of(context).pop();
            }
          }
        },
        color: Colors.black,
        textColor: Colors.white,
        child: Text("ACEPTAR",
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
            )
        ),
      ),
    );
  }

}
