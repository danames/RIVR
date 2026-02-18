import 'package:flutter_test/flutter_test.dart';
import 'package:rivr/core/utils/river_image_utility.dart';

void main() {
  group('RiverImageUtility', () {
    group('getDefaultImageForRiver', () {
      test('returns a valid image path', () {
        final image = RiverImageUtility.getDefaultImageForRiver('23021904');
        expect(image, startsWith('assets/images/rivers/'));
        expect(image, endsWith('.webp'));
      });

      test('returns same image for same reachId (deterministic)', () {
        final image1 = RiverImageUtility.getDefaultImageForRiver('23021904');
        final image2 = RiverImageUtility.getDefaultImageForRiver('23021904');
        final image3 = RiverImageUtility.getDefaultImageForRiver('23021904');
        expect(image1, equals(image2));
        expect(image2, equals(image3));
      });

      test('returns different images for different reachIds', () {
        // With 24 images, different seeds should generally produce different images.
        // Use known-different IDs and check that at least some differ.
        final ids = ['10000001', '20000002', '30000003', '40000004', '50000005'];
        final images = ids.map(RiverImageUtility.getDefaultImageForRiver).toSet();
        // At least 2 distinct images out of 5 different IDs
        expect(images.length, greaterThan(1));
      });

      test('handles numeric string reachId', () {
        final image = RiverImageUtility.getDefaultImageForRiver('99999999');
        expect(RiverImageUtility.isValidImage(image), true);
      });

      test('handles empty string reachId without crashing', () {
        final image = RiverImageUtility.getDefaultImageForRiver('');
        expect(RiverImageUtility.isValidImage(image), true);
      });

      test('handles very long reachId', () {
        final image = RiverImageUtility.getDefaultImageForRiver('1' * 100);
        expect(RiverImageUtility.isValidImage(image), true);
      });
    });

    group('getRandomImage', () {
      test('returns a valid image path', () {
        final image = RiverImageUtility.getRandomImage();
        expect(RiverImageUtility.isValidImage(image), true);
      });
    });

    group('getAllImages', () {
      test('returns 24 images (6 per category x 4 categories)', () {
        final images = RiverImageUtility.getAllImages();
        expect(images.length, 24);
      });

      test('returned list is unmodifiable', () {
        final images = RiverImageUtility.getAllImages();
        expect(() => images.add('fake'), throwsUnsupportedError);
      });

      test('all images have .webp extension', () {
        for (final image in RiverImageUtility.getAllImages()) {
          expect(image, endsWith('.webp'));
        }
      });

      test('all images are under assets/images/rivers/', () {
        for (final image in RiverImageUtility.getAllImages()) {
          expect(image, startsWith('assets/images/rivers/'));
        }
      });
    });

    group('getImagesFromCategory', () {
      test('returns 6 mountain images', () {
        final images = RiverImageUtility.getImagesFromCategory('mountain');
        expect(images.length, 6);
        for (final image in images) {
          expect(image, contains('/mountain/'));
        }
      });

      test('returns 6 urban images', () {
        final images = RiverImageUtility.getImagesFromCategory('urban');
        expect(images.length, 6);
        for (final image in images) {
          expect(image, contains('/urban/'));
        }
      });

      test('returns 6 desert images', () {
        final images = RiverImageUtility.getImagesFromCategory('desert');
        expect(images.length, 6);
        for (final image in images) {
          expect(image, contains('/desert/'));
        }
      });

      test('returns 6 big_water images', () {
        final images = RiverImageUtility.getImagesFromCategory('big_water');
        expect(images.length, 6);
        for (final image in images) {
          expect(image, contains('/big_water/'));
        }
      });

      test('returns empty list for unknown category', () {
        final images = RiverImageUtility.getImagesFromCategory('ocean');
        expect(images, isEmpty);
      });
    });

    group('getCategoryFromImage', () {
      test('identifies mountain category', () {
        expect(
          RiverImageUtility.getCategoryFromImage(
            'assets/images/rivers/mountain/mountain_river_1.webp',
          ),
          'mountain',
        );
      });

      test('identifies urban category', () {
        expect(
          RiverImageUtility.getCategoryFromImage(
            'assets/images/rivers/urban/urban_river_1.webp',
          ),
          'urban',
        );
      });

      test('identifies desert category', () {
        expect(
          RiverImageUtility.getCategoryFromImage(
            'assets/images/rivers/desert/desert_river_1.webp',
          ),
          'desert',
        );
      });

      test('identifies big_water category', () {
        expect(
          RiverImageUtility.getCategoryFromImage(
            'assets/images/rivers/big_water/big_water_1.webp',
          ),
          'big_water',
        );
      });

      test('returns null for unknown path', () {
        expect(
          RiverImageUtility.getCategoryFromImage('/some/random/path.webp'),
          isNull,
        );
      });
    });

    group('isValidImage', () {
      test('true for a known image', () {
        expect(
          RiverImageUtility.isValidImage(
            'assets/images/rivers/mountain/mountain_river_1.webp',
          ),
          true,
        );
      });

      test('false for an unknown path', () {
        expect(
          RiverImageUtility.isValidImage('assets/images/rivers/fake.webp'),
          false,
        );
      });

      test('false for empty string', () {
        expect(RiverImageUtility.isValidImage(''), false);
      });
    });

    group('getImageStats', () {
      test('reports correct total count', () {
        final stats = RiverImageUtility.getImageStats();
        expect(stats['totalImages'], 24);
      });

      test('reports 6 images per category', () {
        final stats = RiverImageUtility.getImageStats();
        final categories = stats['categories'] as Map<String, int>;
        expect(categories['mountain'], 6);
        expect(categories['urban'], 6);
        expect(categories['desert'], 6);
        expect(categories['big_water'], 6);
      });
    });

    group('previewImageForReaches', () {
      test('returns a map with one entry per reachId', () {
        final ids = ['111', '222', '333'];
        final result = RiverImageUtility.previewImageForReaches(ids);
        expect(result.length, 3);
        expect(result.keys, containsAll(ids));
      });

      test('each entry is a valid image', () {
        final result = RiverImageUtility.previewImageForReaches(['100', '200']);
        for (final image in result.values) {
          expect(RiverImageUtility.isValidImage(image), true);
        }
      });

      test('same reachId always maps to same image', () {
        final result1 = RiverImageUtility.previewImageForReaches(['123']);
        final result2 = RiverImageUtility.previewImageForReaches(['123']);
        expect(result1['123'], equals(result2['123']));
      });

      test('handles empty list', () {
        final result = RiverImageUtility.previewImageForReaches([]);
        expect(result, isEmpty);
      });
    });
  });
}
