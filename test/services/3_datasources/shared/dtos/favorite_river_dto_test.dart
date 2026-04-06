import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/services/3_datasources/shared/dtos/favorite_river_dto.dart';
import 'package:rivr/models/1_domain/shared/favorite_river.dart';

void main() {
  group('FavoriteRiverDto', () {
    group('fromJson / toJson roundtrip', () {
      test('serializes and deserializes all fields', () {
        final dto = FavoriteRiverDto(
          reachId: '23021904',
          customName: 'My Creek',
          riverName: 'Deep Creek',
          customImageAsset: 'assets/images/rivers/mountain/river1.webp',
          displayOrder: 3,
          lastKnownFlow: 250.5,
          storedFlowUnit: 'CFS',
          lastUpdated: DateTime(2025, 6, 15, 12, 0).toIso8601String(),
          latitude: 47.6588,
          longitude: -117.4260,
        );

        final json = dto.toJson();
        final restored = FavoriteRiverDto.fromJson(json);

        expect(restored.reachId, dto.reachId);
        expect(restored.customName, dto.customName);
        expect(restored.riverName, dto.riverName);
        expect(restored.customImageAsset, dto.customImageAsset);
        expect(restored.displayOrder, dto.displayOrder);
        expect(restored.lastKnownFlow, dto.lastKnownFlow);
        expect(restored.storedFlowUnit, dto.storedFlowUnit);
        expect(restored.lastUpdated, dto.lastUpdated);
        expect(restored.latitude, dto.latitude);
        expect(restored.longitude, dto.longitude);
      });

      test('handles null optional fields', () {
        final dto = FavoriteRiverDto(
          reachId: '123',
          displayOrder: 0,
        );

        final json = dto.toJson();
        final restored = FavoriteRiverDto.fromJson(json);

        expect(restored.reachId, '123');
        expect(restored.displayOrder, 0);
        expect(restored.customName, isNull);
        expect(restored.riverName, isNull);
        expect(restored.customImageAsset, isNull);
        expect(restored.lastKnownFlow, isNull);
        expect(restored.storedFlowUnit, isNull);
        expect(restored.lastUpdated, isNull);
        expect(restored.latitude, isNull);
        expect(restored.longitude, isNull);
      });
    });

    group('fromEntity / toEntity', () {
      test('converts entity to DTO and back preserving all fields', () {
        final original = FavoriteRiver(
          reachId: '23021904',
          customName: 'My Creek',
          riverName: 'Deep Creek',
          customImageAsset: 'assets/images/rivers/mountain/river1.webp',
          displayOrder: 3,
          lastKnownFlow: 250.5,
          storedFlowUnit: 'CFS',
          lastUpdated: DateTime(2025, 6, 15, 12, 0),
          latitude: 47.6588,
          longitude: -117.4260,
        );

        final dto = FavoriteRiverDto.fromEntity(original);
        expect(dto.reachId, original.reachId);
        expect(dto.customName, original.customName);
        expect(dto.lastUpdated, original.lastUpdated!.toIso8601String());

        final restored = dto.toEntity();
        expect(restored.reachId, original.reachId);
        expect(restored.customName, original.customName);
        expect(restored.riverName, original.riverName);
        expect(restored.customImageAsset, original.customImageAsset);
        expect(restored.displayOrder, original.displayOrder);
        expect(restored.lastKnownFlow, original.lastKnownFlow);
        expect(restored.storedFlowUnit, original.storedFlowUnit);
        expect(restored.lastUpdated, original.lastUpdated);
        expect(restored.latitude, original.latitude);
        expect(restored.longitude, original.longitude);
      });

      test('handles null optional fields in entity', () {
        const original = FavoriteRiver(reachId: '123', displayOrder: 0);

        final dto = FavoriteRiverDto.fromEntity(original);
        expect(dto.customName, isNull);
        expect(dto.lastUpdated, isNull);
        expect(dto.latitude, isNull);

        final restored = dto.toEntity();
        expect(restored.customName, isNull);
        expect(restored.riverName, isNull);
        expect(restored.lastKnownFlow, isNull);
        expect(restored.storedFlowUnit, isNull);
        expect(restored.lastUpdated, isNull);
        expect(restored.latitude, isNull);
        expect(restored.longitude, isNull);
      });

      test('preserves DateTime precision for lastUpdated', () {
        final lastUpdated = DateTime(2025, 6, 15, 12, 30, 45);
        final original = FavoriteRiver(
          reachId: '123',
          displayOrder: 0,
          lastUpdated: lastUpdated,
        );

        final dto = FavoriteRiverDto.fromEntity(original);
        final restored = dto.toEntity();

        expect(restored.lastUpdated, lastUpdated);
      });
    });
  });
}
