import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SupabaseStorageService {
  static const String _bucketName = 'bucket1';

  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Uploads a project image or profile photo to bucket1, returns the public URL string.
  static Future<String?> uploadProjectImage(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final fileName = 'projects/${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      final ext = image.name.split('.').last.toLowerCase();
      String contentType = 'image/jpeg';
      if (ext == 'png') contentType = 'image/png';
      else if (ext == 'gif') contentType = 'image/gif';
      else if (ext == 'webp') contentType = 'image/webp';

      await _supabase.storage.from(_bucketName).uploadBinary(
        fileName,
        bytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true),
      );

      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  /// Uploads a profile photo to bucket1, returns the public URL string.
  static Future<String?> uploadProfilePhoto(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final fileName = 'profile/${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      final ext = image.name.split('.').last.toLowerCase();
      String contentType = 'image/jpeg';
      if (ext == 'png') contentType = 'image/png';
      else if (ext == 'webp') contentType = 'image/webp';

      await _supabase.storage.from(_bucketName).uploadBinary(
        fileName,
        bytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true),
      );

      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
  }

  static Future<String?> uploadCV(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = 'cv/${DateTime.now().millisecondsSinceEpoch}_${file.name}';

      final ext = file.name.split('.').last.toLowerCase();
      String contentType = 'application/pdf';
      if (ext == 'doc' || ext == 'docx') contentType = 'application/msword';

      await _supabase.storage.from(_bucketName).uploadBinary(
        fileName,
        bytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true),
      );

      final publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }
}
