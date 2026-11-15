import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart' as sembast_io;
import 'package:sembast_web/sembast_web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../model/stok.dart';

/// Repository stok barang gudang menggunakan Sembast (Modul 08).
///
/// Mendukung penyimpanan lokal pada platform web maupun platform lain (Android,
/// iOS, Windows, macOS, Linux).
class StokRepository {
  static const _namaDb = 'silog_stok.db';
  static const _namaStore = 'stok';

  static StokRepository? _instance;
  static Database? _db;

  StokRepository._();

  /// Singleton: gunakan instance yang sama di seluruh aplikasi.
  static StokRepository get instance {
    _instance ??= StokRepository._();
    return _instance!;
  }

  /// Membuka (atau membuat) database Sembast.
  Future<Database> get _database async {
    if (_db != null) return _db!;

    if (kIsWeb) {
      _db = await databaseFactoryWeb.openDatabase(_namaDb);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, _namaDb);
      _db = await sembast_io.databaseFactoryIo.openDatabase(path);
    }

    return _db!;
  }

  StoreRef<int, Map<String, dynamic>> get _store =>
      intMapStoreFactory.store(_namaStore);

  // ───────────────────────────────── CRUD ──────────────────────────────────

  /// Menyimpan data stok baru. Mengembalikan objek Stok dengan id dari database.
  Future<Stok> simpan(Stok stok) async {
    final db = await _database;
    final id = await _store.add(db, stok.toMap());
    return stok.salinDengan(id: id);
  }

  /// Mengambil seluruh data stok, diurutkan berdasarkan nama barang.
  Future<List<Stok>> ambilSemua() async {
    final db = await _database;
    final finder = Finder(sortOrders: [SortOrder('namaBarang')]);
    final records = await _store.find(db, finder: finder);
    return records
        .map((r) => Stok.fromMap(r.value, id: r.key))
        .toList();
  }

  /// Mengambil satu data stok berdasarkan id.
  Future<Stok?> ambilSatu(int id) async {
    final db = await _database;
    final record = await _store.record(id).get(db);
    if (record == null) return null;
    return Stok.fromMap(record, id: id);
  }

  /// Memperbarui data stok yang sudah ada.
  Future<void> perbarui(Stok stok) async {
    if (stok.id == null) return;
    final db = await _database;
    await _store.record(stok.id!).update(db, stok.toMap());
  }

  /// Menghapus data stok berdasarkan id.
  Future<void> hapus(int id) async {
    final db = await _database;
    await _store.record(id).delete(db);
  }

  /// Menghitung total jumlah stok untuk satu kode gudang.
  Future<int> totalStokGudang(String kodeGudang) async {
    final db = await _database;
    final finder = Finder(
      filter: Filter.equals('kodeGudang', kodeGudang),
    );
    final records = await _store.find(db, finder: finder);
    return records.fold<int>(0, (total, r) => total + (r.value['jumlah'] as int));
  }

  /// Mencari stok berdasarkan nama barang menggunakan ekspresi reguler.
  Future<List<Stok>> cariNamaBarang(String kata) async {
    final db = await _database;
    final finder = Finder(
      filter: Filter.matchesRegExp(
        'namaBarang',
        RegExp(kata, caseSensitive: false),
      ),
      sortOrders: [SortOrder('namaBarang')],
    );
    final records = await _store.find(db, finder: finder);
    return records
        .map((r) => Stok.fromMap(r.value, id: r.key))
        .toList();
  }

  /// Menghapus seluruh data stok dari database.
  Future<void> kosongkan() async {
    final db = await _database;
    await _store.delete(db);
  }
}

