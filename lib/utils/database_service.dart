import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase.dart';

class DatabaseService {
  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    final res = await supabase.from('profiles').select().eq('id', userId).maybeSingle();
    return res;
  }

  static Future<void> upsertProfile(Map<String, dynamic> data) async {
    await supabase.from('profiles').upsert(data);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final res = await supabase.from('products').select();
    return res;
  }

  static Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    final res = await supabase.from('orders').select().eq('user_id', userId).order('created_at', ascending: false);
    return res;
  }

  static Future<void> createOrder(Map<String, dynamic> data) async {
    await supabase.from('orders').insert(data);
  }
}
