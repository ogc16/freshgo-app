import 'dart:typed_data';
import 'supabase.dart';

class StorageService {
  static const String bucket = 'products';

  static Future<String> uploadImage(String path, Uint8List bytes) async {
    await supabase.storage.from(bucket).uploadBinary(path, bytes);
    return supabase.storage.from(bucket).getPublicUrl(path);
  }

  static String getImageUrl(String path) {
    return supabase.storage.from(bucket).getPublicUrl(path);
  }

  static Future<List<String>> listImages(String folder) async {
    try {
      final files = await supabase.storage.from(bucket).list(path: folder);
      return files.map((f) => supabase.storage.from(bucket).getPublicUrl('$folder/${f.name}')).toList();
    } catch (_) {
      return [];
    }
  }
}
