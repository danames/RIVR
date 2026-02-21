// lib/core/models/map_base_layer.dart
//
// Map base layer enum. Lives in core because it's used by
// core/services/map_preference_service.dart.

import 'package:flutter/cupertino.dart';

enum MapBaseLayer {
  standard('Standard', 'mapbox://styles/mapbox/standard'),
  streets('Streets', 'mapbox://styles/mapbox/streets-v12'),
  satellite('Satellite', 'mapbox://styles/mapbox/satellite-v9'),
  satelliteStreets(
    'Satellite Streets',
    'mapbox://styles/mapbox/satellite-streets-v12',
  ),
  outdoors('Outdoors', 'mapbox://styles/mapbox/outdoors-v12'),
  light('Light', 'mapbox://styles/mapbox/light-v11', supports3D: false),
  dark('Dark', 'mapbox://styles/mapbox/dark-v11', supports3D: false);

  const MapBaseLayer(this.displayName, this.styleUrl, {this.supports3D = true});

  final String displayName;
  final String styleUrl;
  final bool supports3D;

  IconData get icon {
    switch (this) {
      case MapBaseLayer.standard:
        return CupertinoIcons.map_fill;
      case MapBaseLayer.streets:
        return CupertinoIcons.map;
      case MapBaseLayer.satellite:
        return CupertinoIcons.globe;
      case MapBaseLayer.satelliteStreets:
        return CupertinoIcons.location;
      case MapBaseLayer.outdoors:
        return CupertinoIcons.tree;
      case MapBaseLayer.light:
        return CupertinoIcons.sun_max;
      case MapBaseLayer.dark:
        return CupertinoIcons.moon;
    }
  }
}
