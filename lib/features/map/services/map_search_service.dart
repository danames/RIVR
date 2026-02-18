// lib/features/map/services/map_search_service.dart
//
// Map search service and SearchedPlace model extracted from
// map_search_widget.dart to break circular dependency between
// core services and feature widgets.

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/config.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/services/geocoding_service.dart';

/// Simplified place search result model
class SearchedPlace {
  final String placeName;
  final String shortName;
  final double longitude;
  final double latitude;
  final String? category;
  final String? address;
  final List<String> context;

  const SearchedPlace({
    required this.placeName,
    required this.shortName,
    required this.longitude,
    required this.latitude,
    this.category,
    this.address,
    this.context = const [],
  });

  factory SearchedPlace.fromJson(Map<String, dynamic> json) {
    final coordinates = json['center'] as List;
    final context = <String>[];

    // Extract context (region/state, country, etc.) for better display
    if (json['context'] != null) {
      for (final ctx in json['context']) {
        final text = ctx['text'] as String;
        final id = ctx['id'] as String;

        // Include relevant context like region (state), country, etc.
        if (id.startsWith('region') ||
            id.startsWith('country') ||
            id.startsWith('district')) {
          context.add(text);
        }
      }
    }

    return SearchedPlace(
      placeName: json['place_name'] as String,
      shortName: json['text'] as String,
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
      category: json['properties']?['category'] as String?,
      address: json['properties']?['address'] as String?,
      context: context,
    );
  }

  factory SearchedPlace.fromCacheData(Map<String, dynamic> data) {
    return SearchedPlace(
      placeName: data['placeName'] as String,
      shortName: data['shortName'] as String,
      longitude: (data['longitude'] as num).toDouble(),
      latitude: (data['latitude'] as num).toDouble(),
      category: data['category'] as String?,
      address: data['address'] as String?,
      context: (data['context'] as List?)?.cast<String>() ?? <String>[],
    );
  }

  /// Get formatted location context (e.g., "Tennessee, United States")
  String get locationContext {
    if (context.isEmpty) return '';
    return context.join(', ');
  }

  /// Get display subtitle combining address and context
  String get displaySubtitle {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) {
      parts.add(address!);
    }
    if (locationContext.isNotEmpty) {
      parts.add(locationContext);
    }
    return parts.join(' • ');
  }

  IconData get categoryIcon {
    switch (category?.toLowerCase()) {
      case 'restaurant':
      case 'food':
        return CupertinoIcons.square_fill_on_circle_fill;
      case 'hotel':
      case 'lodging':
        return CupertinoIcons.bed_double;
      case 'gas':
      case 'fuel':
        return CupertinoIcons.car;
      case 'hospital':
      case 'medical':
        return CupertinoIcons.heart;
      case 'park':
      case 'recreation':
        return CupertinoIcons.tree;
      case 'shopping':
        return CupertinoIcons.bag;
      default:
        return CupertinoIcons.location;
    }
  }
}

/// Search service using Mapbox Geocoding API
class MapSearchService {
  static Future<List<SearchedPlace>> searchPlaces({
    required String query,
    int limit = 8,
    bool usOnly = true,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      final queryParams = {
        'access_token': AppConfig.mapboxPublicToken,
        'limit': limit.toString(),
        'autocomplete': 'true',
        'types':
            'country,region,place,district,locality,neighborhood,address,poi',
      };

      if (usOnly) {
        queryParams['country'] = 'US';
      }

      final uri = Uri.parse(
        '${AppConfig.mapboxSearchApiUrl}${Uri.encodeComponent(query)}.json',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(AppConfig.httpTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data['features'] as List;
        return features
            .map((feature) => SearchedPlace.fromJson(feature))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.error('MapSearchService', 'Search error', e);
      return [];
    }
  }

  /// Convert coordinates to city, state using Mapbox Geocoding API.
  /// Delegates to core GeocodingService.
  static Future<Map<String, String?>> reverseGeocode(
    double latitude,
    double longitude,
  ) {
    return GeocodingService.reverseGeocode(latitude, longitude);
  }
}
