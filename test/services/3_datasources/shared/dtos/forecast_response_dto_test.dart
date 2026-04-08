import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/models/1_domain/shared/reach_data.dart';
import 'package:rivr/services/3_datasources/shared/dtos/reach_data_dto.dart';

import '../../../../helpers/fake_data.dart';

void main() {
  group('ForecastResponseDto round-trip', () {
    test('complete ForecastResponse survives toJson → fromJson', () {
      final original = ForecastResponse(
        reach: createTestReachData(),
        analysisAssimilation: createTestForecastSeries(),
        shortRange: createTestForecastSeries(),
        mediumRange: {
          'mean': createTestForecastSeries(),
          'member_1': createTestForecastSeries(),
        },
        longRange: {
          'mean': createTestForecastSeries(),
        },
        mediumRangeBlend: createTestForecastSeries(),
      );

      final json = ForecastResponseDto.toJson(original);
      final restored = ForecastResponseDto.fromJson(json);

      expect(restored.reach.reachId, original.reach.reachId);
      expect(restored.reach.riverName, original.reach.riverName);
      expect(restored.reach.latitude, original.reach.latitude);
      expect(restored.reach.longitude, original.reach.longitude);

      expect(restored.analysisAssimilation, isNotNull);
      expect(
        restored.analysisAssimilation!.data.length,
        original.analysisAssimilation!.data.length,
      );

      expect(restored.shortRange, isNotNull);
      expect(
        restored.shortRange!.data.length,
        original.shortRange!.data.length,
      );

      expect(restored.mediumRange.length, 2);
      expect(restored.mediumRange.containsKey('mean'), isTrue);
      expect(restored.mediumRange.containsKey('member_1'), isTrue);

      expect(restored.longRange.length, 1);
      expect(restored.longRange.containsKey('mean'), isTrue);

      expect(restored.mediumRangeBlend, isNotNull);
    });

    test('null optional fields round-trip correctly', () {
      final original = ForecastResponse(
        reach: createTestReachData(),
        analysisAssimilation: null,
        shortRange: null,
        mediumRange: {},
        longRange: {},
        mediumRangeBlend: null,
      );

      final json = ForecastResponseDto.toJson(original);
      final restored = ForecastResponseDto.fromJson(json);

      expect(restored.analysisAssimilation, isNull);
      expect(restored.shortRange, isNull);
      expect(restored.mediumRange, isEmpty);
      expect(restored.longRange, isEmpty);
      expect(restored.mediumRangeBlend, isNull);
    });

    test('ensemble maps with multiple members round-trip', () {
      final original = ForecastResponse(
        reach: createTestReachData(),
        mediumRange: {
          'mean': createTestForecastSeries(),
          'member_1': createTestForecastSeries(),
          'member_2': createTestForecastSeries(),
          'member_3': createTestForecastSeries(),
        },
        longRange: {
          'mean': createTestForecastSeries(),
          'member_1': createTestForecastSeries(),
        },
      );

      final json = ForecastResponseDto.toJson(original);
      final restored = ForecastResponseDto.fromJson(json);

      expect(restored.mediumRange.length, 4);
      expect(restored.longRange.length, 2);
      expect(restored.mediumRange.keys.toList()..sort(),
          ['mean', 'member_1', 'member_2', 'member_3']);
    });

    test('flow values are preserved through round-trip', () {
      final original = ForecastResponse(
        reach: createTestReachData(),
        shortRange: createTestForecastSeries(
          data: [
            createTestForecastPoint(flow: 42.5),
            createTestForecastPoint(flow: 99.9),
          ],
        ),
        mediumRange: {},
        longRange: {},
      );

      final json = ForecastResponseDto.toJson(original);
      final restored = ForecastResponseDto.fromJson(json);

      expect(restored.shortRange!.data[0].flow, 42.5);
      expect(restored.shortRange!.data[1].flow, 99.9);
    });

    test('reach with return periods round-trips', () {
      final original = ForecastResponse(
        reach: createTestReachDataWithReturnPeriods(),
        mediumRange: {},
        longRange: {},
      );

      final json = ForecastResponseDto.toJson(original);
      final restored = ForecastResponseDto.fromJson(json);

      expect(restored.reach.hasReturnPeriods, isTrue);
      expect(restored.reach.returnPeriods!.length, 4);
      expect(restored.reach.returnPeriods![2], 100.0);
    });

    test('fromJson tolerates missing optional keys', () {
      final json = {
        'reach': ReachDataDto.fromEntity(createTestReachData()).toJson(),
        'mediumRange': <String, dynamic>{},
        'longRange': <String, dynamic>{},
      };

      final restored = ForecastResponseDto.fromJson(json);

      expect(restored.analysisAssimilation, isNull);
      expect(restored.shortRange, isNull);
      expect(restored.mediumRangeBlend, isNull);
      expect(restored.reach.reachId, '23021904');
    });
  });
}
