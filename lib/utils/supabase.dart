import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = 'https://bjhwtwijmcnugnwbehxw.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqaHd0d2lqbWNudWdud2JlaHh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk2MTMzNzgsImV4cCI6MjA5NTE4OTM3OH0.29h5LQdA1_-hgLmbsABT2doAZ09QhgUJszOO7Q5vXVw';

SupabaseClient get supabase => Supabase.instance.client;
