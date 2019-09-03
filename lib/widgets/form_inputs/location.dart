import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/helpers/ensure_visible.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;


class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    //Método de obtener mapas estaticas
    //getStaticMap();
    super.initState();
  }
  @override
  void dispose(){
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }
  //Método para obtener mapa estatico
  void getStaticMap(String address)async{
    if(address.isEmpty){
      return;
    }
    final Uri url = Uri.https('maps.googleapis.com', 
                    '/maps/api/geocode/json',
                    {'address':address,'key':'AIzaSyAAw4woNIssZ0P5Lonws9W-9LTRHRCMyqc'}
                    );
   final http.Response response = await http.get(url);
    final StaticMapProvider staticMapProvider = new StaticMapProvider('AIzaSyAAw4woNIssZ0P5Lonws9W-9LTRHRCMyqc');
   final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers([
      Marker('position','Position',41.40338,2.17403)
    ],
    center: Location(41.40338,2.17403),
    width: 500,
    height: 300,
    maptype: StaticMapViewType.roadmap
    );
    setState(() {
      _staticMapUri = staticMapUri;
    });
  }
  void _updateLocation(){
    if(!_addressInputFocusNode.hasFocus){
      //Se obtiene la direccion del mapa por medio de un campo de texto
      getStaticMap(_addressInputController.text);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            decoration: InputDecoration(
              labelText: 'Address'
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Image.network(_staticMapUri.toString())
      ],
    );
  }
}