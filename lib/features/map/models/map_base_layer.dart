// lib/features/map/models/map_base_layer.dart
//
// Map base layer enum extracted from base_layer_modal.dart to break
// circular dependency between core services and feature widgets.

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
  light('Light', 'mapbox://styles/mapbox/light-v11'),
  dark('Dark', 'mapbox://styles/mapbox/dark-v11');

  const MapBaseLayer(this.displayName, this.styleUrl);

  final String displayName;
  final String styleUrl;

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
