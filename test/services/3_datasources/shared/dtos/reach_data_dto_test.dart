import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/services/3_datasources/shared/dtos/reach_data_dto.dart';
import 'package:rivr/models/1_domain/shared/reach_data.dart';

import '../../../../helpers/fake_data.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  setUpAll(() => setupTestServiceLocator());
  tearDownAll(() => tearDownServiceLocator());

  group('ReachDataDto', () {
    group('fromNoaaApi', () {
      test('parses valid API response', () {
        final json = createTestNoaaApiResponse();
        final dto = ReachDataDto.fromNoaaApi(json);

        expect(dto.reachId, '23021904');
        expect(dto.riverName, 'Deep Creek');
        expect(dto.latitude, 47.6588);
        expect(dto.longitude, -117.4260);
        expect(dto.availableForecasts, ['short_range', 'medium_range']);
        expect(dto.isPartiallyLoaded, false);
      });

      test('trims whitespace from reachId', () {
        final json = createTestNoaaApiResponse(reachId: '  23021904  ');
        final dto = ReachDataDto.fromNoaaApi(json);
        expect(dto.reachId, '23021904');
      });

      test('parses upstream and downstream routes', () {
        final json = createTestNoaaApiResponse(
          route: {
            'upstream': [
              {'reachId': '23021906'},
              {'reachId': '23023198'},
            ],
            'downstream': [
              {'reachId': '23022058'},
            ],
          },
        );
        final dto = ReachDataDto.fromNoaaApi(json);

        expect(dto.upstreamReaches, ['23021906', '23023198']);
        expect(dto.downstreamReaches, ['23022058']);
      });

      test('handles missing route gracefully', () {
        final json = createTestNoaaApiResponse();
        final dto = ReachDataDto.fromNoaaApi(json);

        expect(dto.upstreamReaches, isNull);
        expect(dto.downstreamReaches, isNull);
      });

      test('throws FormatException on invalid data', () {
        expect(
          () => ReachDataDto.fromNoaaApi({'invalid': 'data'}),
          throwsA(isA<FormatException>()),
        );
      });

      test('converts to entity correctly', () {
        final json = createTestNoaaApiResponse();
        final entity = ReachDataDto.fromNoaaApi(json).toEntity();

        expect(entity, isA<ReachData>());
        expect(entity.reachId, '23021904');
        expect(entity.riverName, 'Deep Creek');
      });
    });

    group('fromReturnPeriodApi', () {
      test('parses return period response', () {
        final json = createTestReturnPeriodApiResponse();
        final dto = ReachDataDto.fromReturnPeriodApi(json);

        expect(dto.reachId, '23021904');
        expect(dto.returnPeriods, isNotNull);
        expect(dto.returnPeriods![2], 3518.03);
        expect(dto.returnPeriods![5], 6119.41);
        expect(dto.returnPeriods![10], 7841.75);
        expect(dto.returnPeriods![25], 10200.50);
        expect(dto.isPartiallyLoaded, true);
      });

      test('throws FormatException on empty array', () {
        expect(
          () => ReachDataDto.fromReturnPeriodApi([]),
          throwsA(isA<FormatException>()),
        );
      });

      test('converts to entity correctly', () {
        final json = createTestReturnPeriodApiResponse();
        final entity = ReachDataDto.fromReturnPeriodApi(json).toEntity();

        expect(entity, isA<ReachData>());
        expect(entity.reachId, '23021904');
        expect(entity.returnPeriods![2], 3518.03);
        expect(entity.isPartiallyLoaded, true);
      });
    });

    group('fromJson / toJson roundtrip', () {
      test('serializes and deserializes all fields', () {
        final dto = ReachDataDto(
          reachId: '23021904',
          riverName: 'Deep Creek',
          latitude: 47.6588,
          longitude: -117.4260,
          city: 'Spokane',
          state: 'WA',
          availableForecasts: ['short_range', 'medium_range'],
          returnPeriods: {2: 100.0, 5: 200.0},
          upstreamReaches: ['123', '456'],
          downstreamReaches: ['789'],
          customName: 'My Creek',
          cachedAt: DateTime(2025, 1, 1).toIso8601String(),
          lastApiUpdate: DateTime(2025, 6, 15).toIso8601String(),
          isPartiallyLoaded: false,
        );

        final json = dto.toJson();
        final restored = ReachDataDto.fromJson(json);

        expect(restored.reachId, dto.reachId);
        expect(restored.riverName, dto.riverName);
        expect(restored.latitude, dto.latitude);
        expect(restored.longitude, dto.longitude);
        expect(restored.city, dto.city);
        expect(restored.state, dto.state);
        expect(restored.availableForecasts, dto.availableForecasts);
        expect(restored.returnPeriods, dto.returnPeriods);
        expect(restored.upstreamReaches, dto.upstreamReaches);
        expect(restored.downstreamReaches, dto.downstreamReaches);
        expect(restored.customName, dto.customName);
        expect(restored.cachedAt, dto.cachedAt);
        expect(restored.lastApiUpdate, dto.lastApiUpdate);
        expect(restored.isPartiallyLoaded, dto.isPartiallyLoaded);
      });

      test('handles null optional fields', () {
        final dto = ReachDataDto(
          reachId: '123',
          riverName: 'Test',
          latitude: 0.0,
          longitude: 0.0,
          availableForecasts: [],
          cachedAt: DateTime(2025, 1, 1).toIso8601String(),
        );

        final json = dto.toJson();
        final restored = ReachDataDto.fromJson(json);

        expect(restored.city, isNull);
        expect(restored.state, isNull);
        expect(restored.returnPeriods, isNull);
        expect(restored.upstreamReaches, isNull);
        expect(restored.downstreamReaches, isNull);
        expect(restored.customName, isNull);
        expect(restored.lastApiUpdate, isNull);
      });
    });

    group('fromEntity / toEntity', () {
      test('converts entity to DTO and back preserving all fields', () {
        final original = createTestReachData(
          returnPeriods: {2: 100.0, 5: 200.0},
          upstreamReaches: ['123', '456'],
          customName: 'My Creek',
        );

        final dto = ReachDataDto.fromEntity(original);
        expect(dto.reachId, original.reachId);
        expect(dto.riverName, original.riverName);
        expect(dto.cachedAt, original.cachedAt.toIso8601String());

        final restored = dto.toEntity();
        expect(restored.reachId, original.reachId);
        expect(restored.riverName, original.riverName);
        expect(restored.latitude, original.latitude);
        expect(restored.longitude, original.longitude);
        expect(restored.city, original.city);
        expect(restored.state, original.state);
        expect(restored.availableForecasts, original.availableForecasts);
        expect(restored.returnPeriods, original.returnPeriods);
        expect(restored.upstreamReaches, original.upstreamReaches);
        expect(restored.customName, original.customName);
        expect(restored.isPartiallyLoaded, original.isPartiallyLoaded);
      });

      test('handles null optional fields in entity', () {
        final original = createTestReachData(
          city: null,
          state: null,
          returnPeriods: null,
          upstreamReaches: null,
          customName: null,
        );

        final dto = ReachDataDto.fromEntity(original);
        final restored = dto.toEntity();

        expect(restored.city, isNull);
        expect(restored.state, isNull);
        expect(restored.returnPeriods, isNull);
        expect(restored.upstreamReaches, isNull);
        expect(restored.customName, isNull);
      });
    });
  });

  group('ForecastPointDto', () {
    group('fromJson / toJson roundtrip', () {
      test('serializes and deserializes correctly', () {
        final dto = ForecastPointDto(
          validTime: DateTime(2025, 6, 15, 12, 0).toIso8601String(),
          flow: 150.5,
        );

        final json = dto.toJson();
        final restored = ForecastPointDto.fromJson(json);

        expect(restored.validTime, dto.validTime);
        expect(restored.flow, dto.flow);
      });
    });

    group('fromEntity / toEntity', () {
      test('converts entity to DTO and back', () {
        final original = ForecastPoint(
          validTime: DateTime(2025, 6, 15, 12, 0),
          flow: 150.5,
        );

        final dto = ForecastPointDto.fromEntity(original);
        expect(dto.validTime, original.validTime.toIso8601String());
        expect(dto.flow, original.flow);

        final restored = dto.toEntity();
        expect(restored.validTime, original.validTime);
        expect(restored.flow, original.flow);
      });
    });
  });

  group('ForecastSeriesDto', () {
    group('fromJson / toJson roundtrip', () {
      test('serializes and deserializes correctly', () {
        final dto = ForecastSeriesDto(
          referenceTime: DateTime(2025, 6, 15, 6, 0).toIso8601String(),
          units: 'CMS',
          data: [
            ForecastPointDto(
              validTime: DateTime(2025, 6, 15, 10, 0).toIso8601String(),
              flow: 100.0,
            ),
            ForecastPointDto(
              validTime: DateTime(2025, 6, 15, 11, 0).toIso8601String(),
              flow: 120.0,
            ),
          ],
        );

        final json = dto.toJson();
        final restored = ForecastSeriesDto.fromJson(json);

        expect(restored.referenceTime, dto.referenceTime);
        expect(restored.units, 'CMS');
        expect(restored.data.length, 2);
        expect(restored.data[0].flow, 100.0);
        expect(restored.data[1].flow, 120.0);
      });

      test('handles null referenceTime', () {
        final dto = ForecastSeriesDto(
          units: 'CFS',
          data: [
            ForecastPointDto(
              validTime: DateTime(2025, 6, 15, 12, 0).toIso8601String(),
              flow: 50.0,
            ),
          ],
        );

        final json = dto.toJson();
        final restored = ForecastSeriesDto.fromJson(json);

        expect(restored.referenceTime, isNull);
      });

      test('handles empty data list', () {
        final json = {
          'units': 'CFS',
          'data': <Map<String, dynamic>>[],
        };

        final restored = ForecastSeriesDto.fromJson(json);
        expect(restored.data, isEmpty);
      });

      test('handles null data field', () {
        final json = {
          'units': 'CFS',
        };

        final restored = ForecastSeriesDto.fromJson(json);
        expect(restored.data, isEmpty);
      });
    });

    group('fromEntity / toEntity', () {
      test('converts entity to DTO and back', () {
        final original = createTestForecastSeries(
          referenceTime: DateTime(2025, 6, 15, 6, 0),
          units: 'CMS',
        );

        final dto = ForecastSeriesDto.fromEntity(original);
        expect(dto.units, 'CMS');
        expect(dto.data.length, 3);
        expect(dto.referenceTime, original.referenceTime!.toIso8601String());

        final restored = dto.toEntity();
        expect(restored.units, 'CMS');
        expect(restored.data.length, 3);
        expect(restored.referenceTime, original.referenceTime);
        expect(restored.data[0].flow, original.data[0].flow);
        expect(restored.data[0].validTime, original.data[0].validTime);
      });

      test('handles null referenceTime in entity', () {
        final original = ForecastSeries(
          units: 'CFS',
          data: [createTestForecastPoint()],
        );

        final dto = ForecastSeriesDto.fromEntity(original);
        expect(dto.referenceTime, isNull);

        final restored = dto.toEntity();
        expect(restored.referenceTime, isNull);
      });
    });
  });

  group('ForecastResponseDto', () {
    group('fromApiResponse', () {
      test('parses complete API response with all forecast types', () {
        final apiResponse = {
          'reach': createTestNoaaApiResponse(),
          'shortRange': {
            'series': {
              'units': 'CFS',
              'referenceTime': '2025-06-15T06:00:00.000',
              'data': [
                {'validTime': '2025-06-15T10:00:00.000', 'flow': 100.0},
                {'validTime': '2025-06-15T11:00:00.000', 'flow': 120.0},
              ],
            },
          },
          'mediumRange': {
            'mean': {
              'units': 'CFS',
              'referenceTime': '2025-06-15T06:00:00.000',
              'data': [
                {'validTime': '2025-06-15T12:00:00.000', 'flow': 150.0},
              ],
            },
          },
          'longRange': {
            'member1': {
              'units': 'CFS',
              'data': [
                {'validTime': '2025-06-16T12:00:00.000', 'flow': 200.0},
              ],
            },
          },
        };

        final response = ForecastResponseDto.fromApiResponse(apiResponse);

        expect(response.reach.reachId, '23021904');
        expect(response.shortRange, isNotNull);
        expect(response.shortRange!.data.length, 2);
        expect(response.mediumRange, isNotEmpty);
        expect(response.mediumRange['mean'], isNotNull);
        expect(response.longRange, isNotEmpty);
        expect(response.longRange['member1'], isNotNull);
      });

      test('handles missing optional forecast sections', () {
        final apiResponse = {
          'reach': createTestNoaaApiResponse(),
        };

        final response = ForecastResponseDto.fromApiResponse(apiResponse);

        expect(response.reach.reachId, '23021904');
        expect(response.shortRange, isNull);
        expect(response.analysisAssimilation, isNull);
        expect(response.mediumRange, isEmpty);
        expect(response.longRange, isEmpty);
      });

      test('parses analysis_assimilation section', () {
        final apiResponse = {
          'reach': createTestNoaaApiResponse(),
          'analysisAssimilation': {
            'series': {
              'units': 'CMS',
              'data': [
                {'validTime': '2025-06-15T09:00:00.000', 'flow': 80.0},
              ],
            },
          },
        };

        final response = ForecastResponseDto.fromApiResponse(apiResponse);
        expect(response.analysisAssimilation, isNotNull);
        expect(response.analysisAssimilation!.data.length, 1);
        expect(response.analysisAssimilation!.units, 'CMS');
      });
    });
  });
}
