import 'package:shared_preferences/shared_preferences.dart';

/// Pengelola preferensi aplikasi menggunakan SharedPreferences (Modul 08).
///
/// Menyimpan:
/// - Gudang terakhir yang dipilih.
/// - Nama petugas.
/// - Preferensi mode gelap.
class Preferensi {
  static const _keyGudangTerakhir = 'gudang_terakhir';
  static const _keyNamaPetugas = 'nama_petugas';
  static const _keyModeGelap = 'mode_gelap';

  /// Menyimpan kode gudang terakhir yang dipilih.
  static Future<void> simpanGudangTerakhir(String kodeGudang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGudangTerakhir, kodeGudang);
  }

  /// Mengambil kode gudang terakhir. Mengembalikan null jika belum disimpan.
  static Future<String?> ambilGudangTerakhir() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGudangTerakhir);
  }

  /// Menyimpan nama petugas.
  static Future<void> simpanNamaPetugas(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNamaPetugas, nama);
  }

  /// Mengambil nama petugas. Mengembalikan string kosong jika belum disimpan.
  static Future<String> ambilNamaPetugas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNamaPetugas) ?? '';
  }

  /// Menyimpan preferensi mode gelap.
  static Future<void> simpanModeGelap(bool aktif) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyModeGelap, aktif);
  }

  /// Mengambil preferensi mode gelap. Mengembalikan false (terang) jika belum disimpan.
  static Future<bool> ambilModeGelap() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyModeGelap) ?? false;
  }
}

