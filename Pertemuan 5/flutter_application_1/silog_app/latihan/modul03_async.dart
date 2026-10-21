class ResiTidakDitemukan implements Exception {
  final String resi;

  ResiTidakDitemukan(this.resi);

  @override
  String toString() =>
      'ResiTidakDitemukan: Resi "$resi" tidak ada dalam sistem.';
}

final Map<String, Map<String, dynamic>> _dataStatus = {
  'SLG-001': {
    'status': 'Paket telah diterima di gudang Bandung',
    'ongkir': 18000.0,
  },
  'SLG-002': {'status': 'Dalam perjalanan menuju Surabaya', 'ongkir': 106250.0},
  'SLG-003': {
    'status': 'Paket tiba di hub Makassar, menunggu kurir',
    'ongkir': 100800.0,
  },
  'SLG-004': {
    'status': 'Sedang dikirim ke alamat tujuan Jayapura',
    'ongkir': 100800.0,
  },
  'SLG-005': {
    'status': 'Paket telah diterima oleh penerima di Medan',
    'ongkir': 126000.0,
  },
};

Future<String> ambilStatusKiriman(String resi) async {

  await Future.delayed(const Duration(seconds: 2));

  final formatSah = RegExp(r'^SLG-\d+$');
  if (!formatSah.hasMatch(resi)) {
    throw FormatException(
      'Format resi tidak valid: "$resi". Gunakan format SLG-XXX.',
    );
  }

  final data = _dataStatus[resi];
  if (data == null) {
    throw ResiTidakDitemukan(resi);
  }

  return data['status'] as String;
}

Future<double> ambilOngkir(String resi) async {

  await Future.delayed(const Duration(seconds: 1));

  final data = _dataStatus[resi];
  if (data == null) {
    throw ResiTidakDitemukan(resi);
  }

  return data['ongkir'] as double;
}

Future<void> bandingkanWaktu() async {
  print('\n========== LATIHAN 4: FUTURE.WAIT ==========');

  print('Mengambil status & ongkir SLG-001 secara SEKUENSIAL...');
  final mulaiSeq = DateTime.now();
  final statusSeq = await ambilStatusKiriman('SLG-001');
  final ongkirSeq = await ambilOngkir('SLG-001');
  final durasiSeq = DateTime.now().difference(mulaiSeq);

  print('Status  : $statusSeq');
  print('Ongkir  : Rp${ongkirSeq.toStringAsFixed(0)}');
  print('Durasi  : ${durasiSeq.inMilliseconds} ms (berjalan sekuensial)\n');

  print('Mengambil status & ongkir SLG-001 secara PARALEL...');
  final mulaiPar = DateTime.now();

  final hasil = await Future.wait([
    ambilStatusKiriman('SLG-001'),
    ambilOngkir('SLG-001').then((v) => v.toStringAsFixed(0)),
  ]);

  final durasiPar = DateTime.now().difference(mulaiPar);

  print('Status  : ${hasil[0]}');
  print('Ongkir  : Rp${hasil[1]}');
  print('Durasi  : ${durasiPar.inMilliseconds} ms (berjalan paralel)');
  print('=============================================\n');
}

Future<void> pantauBanyakResi(List<String> daftarResi) async {
  print('--- Memproses ${daftarResi.length} resi secara paralel ---\n');

  final futures = daftarResi.map((resi) async {
    try {
      final status = await ambilStatusKiriman(resi);
      print('[OK]   $resi → $status');
    } on FormatException catch (e) {
      print('[GAGAL] $resi → FORMAT ERROR: ${e.message}');
    } on ResiTidakDitemukan catch (e) {
      print('[GAGAL] $resi → $e');
    } catch (e) {
      print('[GAGAL] $resi → Error tidak terduga: $e');
    }
  }).toList();

  await Future.wait(futures);

  print('\n--- Seluruh daftar selesai diproses ---');
}

Future<void> main() async {

  print('========== LATIHAN 3: ASYNC / AWAIT ==========\n');
  print('Mengambil status kiriman SLG-002...');

  try {
    final status = await ambilStatusKiriman('SLG-002');
    print('Status kiriman : $status');

    final ongkir = await ambilOngkir('SLG-002');
    print('Ongkos kirim   : Rp${ongkir.toStringAsFixed(0)}');
  } on FormatException catch (e) {
    print('[FormatException] ${e.message}');
  } on ResiTidakDitemukan catch (e) {
    print('[ResiTidakDitemukan] $e');
  } catch (e) {
    print('[Error] $e');
  }

  print('\n==============================================\n');

  await bandingkanWaktu();

  print('========== TUGAS PRAKTIKUM 2 ==========');
  print('\nSKENARIO 1 – SELURUH RESI VALID\n');
  final mulai1 = DateTime.now();
  await pantauBanyakResi([
    'SLG-001',
    'SLG-002',
    'SLG-003',
    'SLG-004',
    'SLG-005',
  ]);
  final durasi1 = DateTime.now().difference(mulai1);
  print('Durasi total: ${durasi1.inMilliseconds} ms\n');

  print('\nSKENARIO 2 – ADA RESI TIDAK VALID\n');
  final mulai2 = DateTime.now();
  await pantauBanyakResi([
    'SLG-001',
    'SLG-002',
    'XYZ-999',
    'SLG-004',
    'SLG-005',
  ]);
  final durasi2 = DateTime.now().difference(mulai2);
  print('Durasi total: ${durasi2.inMilliseconds} ms\n');

  print('========== SELESAI ==========');
}
