import '../lib/layanan/layanan_pengiriman.dart';
import '../lib/layanan/moda.dart';

void main() {
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(
      kodeLayanan: 'TRK-REG',
      jarakKm: 780,
      beratKg: 1200,
    ),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP',
      jarakKm: 780,
      beratKg: 1200,
      ekspres: true,
    ),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    PengirimanUdara(
      kodeLayanan: 'UDR-CARGO',
      jarakKm: 780,
      beratKg: 80,
      panjangCm: 120,
      lebarCm: 100,
      tinggiCm: 100,
    ),
  ];

  print('=== Perbandingan Layanan Pengiriman ===');
  for (final layanan in daftarLayanan) {
    print(layanan.ringkasan());
  }

  daftarLayanan.sort(
    (a, b) => a.hitungTarif().compareTo(b.hitungTarif()),
  );

  print('\nLayanan termurah : ${daftarLayanan.first.kodeLayanan}');
  print(
    'Layanan tercepat : '
    '${daftarLayanan.reduce(
      (a, b) => a.estimasiHari() <= b.estimasiHari() ? a : b,
    ).kodeLayanan}',
  );

  // Pengujian mixin Terlacak.
  final truk = daftarLayanan.whereType<PengirimanTruk>().first;
  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');

  print('\nRiwayat posisi ${truk.kodeLayanan}:');
  for (final r in truk.riwayat) {
    print(' $r');
  }
  print('Posisi terakhir: ${truk.posisiTerakhir()}');

  // Pengujian Tugas F: Terasuransi hanya pada kapal dan udara.
  final kapal = daftarLayanan.whereType<PengirimanKapal>().first;
  final udara = daftarLayanan.whereType<PengirimanUdara>().first;
  const nilaiBarang = 10000000.0;

  print('\n=== Pengujian Mixin Terasuransi ===');
  print(
    'Persentase premi kapal: '
    '${(kapal.persentasePremi * 100).toStringAsFixed(0)}%',
  );
  print(
    'Premi kapal untuk nilai barang Rp${nilaiBarang.toStringAsFixed(0)}: '
    'Rp${kapal.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );
  print(
    'Persentase premi udara: '
    '${(udara.persentasePremi * 100).toStringAsFixed(0)}%',
  );
  print(
    'Premi udara untuk nilai barang Rp${nilaiBarang.toStringAsFixed(0)}: '
    'Rp${udara.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  print('\n=== Pengujian PengirimanTruk ===');
  try {
    // dynamic dipakai untuk menguji pemanggilan metode saat runtime.
    // Terlacak tetap dimiliki truk, tetapi Terasuransi tidak dipasang pada truk.
    (truk as dynamic).hitungPremi(nilaiBarang);
    print('PengirimanTruk memiliki metode hitungPremi().');
  } on NoSuchMethodError {
    print('PengirimanTruk tidak memiliki metode hitungPremi().');
  }
}
