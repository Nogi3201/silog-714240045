class DataKiriman {
  final String resi;
  final String kotaTujuan;
  final String? catatan;
  final DateTime? waktuTerima;

  DataKiriman({
    required this.resi,
    required this.kotaTujuan,
    this.catatan,
    this.waktuTerima,
  });
}

void ringkasan(DataKiriman k) {

  final catatanTampil = k.catatan ?? '(tidak ada catatan)';

  final status = k.waktuTerima != null ? 'Sudah diterima' : 'Dalam pengiriman';

  print('-----------------------------------');
  print('Resi        : ${k.resi}');
  print('Kota Tujuan : ${k.kotaTujuan}');
  print('Status      : $status');
  print('Catatan     : $catatanTampil');
  if (k.waktuTerima != null) {

    print('Waktu Terima: ${k.waktuTerima!.toLocal()}');
  }
  print('-----------------------------------');
}

class ResiTidakDitemukan implements Exception {
  final String resi;

  ResiTidakDitemukan(this.resi);

  @override
  String toString() =>
      'ResiTidakDitemukan: Resi "$resi" tidak ada dalam sistem.';
}

final Map<String, String> _dataResi = {
  'SLG-001': 'Bandung',
  'SLG-002': 'Surabaya',
  'SLG-003': 'Makassar',
  'SLG-004': 'Jayapura',
  'SLG-005': 'Medan',
};

String cariKota(String resi) {
  final kota = _dataResi[resi];
  if (kota == null) {
    throw ResiTidakDitemukan(resi);
  }
  return kota;
}

void ujiPenanganan() {
  print('\n========== UJI PENANGANAN ERROR ==========');

  final daftarUji = ['SLG-001', 'SLG-999'];

  for (final resi in daftarUji) {
    print('\nMencari resi: $resi');
    try {
      final kota = cariKota(resi);
      print('  Kota tujuan: $kota');
    } on ResiTidakDitemukan catch (e) {

      print('  [ERROR] $e');
    } catch (e) {

      print('  [ERROR TIDAK TERDUGA] $e');
    } finally {

      print('  [finally] Pencarian untuk "$resi" selesai.');
    }
  }

  print('\n==========================================');
}

void main() {
  print('========== LATIHAN 1: NULL SAFETY ==========\n');

  final kiriman1 = DataKiriman(
    resi: 'SLG-001',
    kotaTujuan: 'Bandung',

  );
  ringkasan(kiriman1);

  final kiriman2 = DataKiriman(
    resi: 'SLG-002',
    kotaTujuan: 'Surabaya',
    catatan: 'Barang fragile, harap hati-hati',
    waktuTerima: DateTime(2026, 10, 7, 14, 30),
  );
  ringkasan(kiriman2);

  ujiPenanganan();
}
