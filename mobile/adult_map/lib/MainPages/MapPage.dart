import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:adult_map/Constants.dart';

import '../models/Placemark.dart';

import 'package:adult_map/IOfunctions/IOFunc.dart';

class MapPage extends StatefulWidget {
  final FlutterSecureStorage storage;
  const MapPage({Key? key, required this.storage}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  List<MapObject<dynamic>> objs = [];
  Future<Placemarks>? _futurePlacemarks;
  Completer<YandexMapController> _completer = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: _onMapCreated,
        mapObjects: objs,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onPointCreated,
      ),
    );
  }

//60.007465, 30.373109
//60.011194, 30.386736

  void _onPointCreated() async {

  }
  void _onMapCreated(YandexMapController map) async {
    _completer.complete(map);
    _futurePlacemarks = fetchPlacemarks(widget.storage);
    var places = await _futurePlacemarks;
    setState(() {
      for (var place in places!.placemark!) {
        objs.add(
            PlacemarkMapObject(
                mapId: MapObjectId(place.name!),
                point: Point(
                    latitude: place.latitude!, longitude: place.longitude!),
                icon: PlacemarkIcon.single(
                    PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage('assets/point.png'),
                      anchor: offsetOfPoint,
                    ))
            )
        );
      }
    });

  }
}

