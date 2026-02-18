// lib/core/services/i_background_image_service.dart

import 'package:flutter/cupertino.dart';
import 'background_image_service.dart';

/// Interface for custom background image operations
abstract class IBackgroundImageService {
  Future<BackgroundImageResult> pickFromGallery(String userId);
  Future<BackgroundImageResult> pickFromCamera(String userId);
  Future<BackgroundImageResult> showImageSourceSelector({
    required BuildContext context,
    required String userId,
  });
  Future<bool> deleteCustomBackground(String imagePath);
  Future<void> cleanupOldBackgrounds(String userId);
  Future<bool> imageExists(String imagePath);
}
