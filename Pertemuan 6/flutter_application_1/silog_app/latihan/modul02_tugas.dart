








const double faktorVolumetrik = 6000;

final List<Map<String, Object>> daftarKiriman = [
  {
    'resi': 'SLG-T001',
    'kota': 'Bandung',
    'beratAktual': 3.0,
    'panjang': 20.0,
    'lebar': 15.0,
    'tinggi': 10.0,
  },
  {
    'resi': 'SLG-T002',
    'kota': 'Surabaya',
    'beratAktual': 12.5,
    'panjang': 45.0,
    'lebar': 30.0,
    'tinggi': 25.0,
  },
  {
    'resi': 'SLG-T003',
    'kota': 'Makassar',
    'beratAktual': 7.2,
    'panjang': 35.0,
    'lebar': 25.0,
    'tinggi': 20.0,
  },
  {
    'resi': 'SLG-T004',
    'kota': 'Surabaya',
    'beratAktual': 4.8,
    'panjang': 30.0,
    'lebar': 20.0,
    'tinggi': 15.0,
  },
  {
    'resi': 'SLG-T005',
    'kota': 'Jayapura',
    'beratAktual': 18.0,
    'panjang': 60.0,
    'lebar': 40.0,
    'tinggi': 30.0,
  },
  {
    'resi': 'SLG-T006',
    'kota': 'Bandung',
    'beratAktual': 1.5,
    'panjang': 15.0,
    'lebar': 10.0,
    'tinggi': 8.0,
  },
  {
    'resi': 'SLG-T007',
    'kota': 'Makassar',
    'beratAktual': 25.0,
    'panjang': 80.0,
    'lebar': 60.0,
    'tinggi': 50.0,
  },
  {
    'resi': 'SLG-T008',
    'kota': 'Jayapura',
    'beratAktual': 9.3,
    'panjang': 40.0,
    'lebar': 30.0,
    'tinggi': 25.0,
  },
];

final Map<String, double> tarifZona = {
  'Bandung': 6000,
  'Surabaya': 8500,
  'Makassar': 14000,
  'Jayapura': 21000,
};





double hitungBeratVolumetrik(double p, double l, double t) =>
    (p * l * t) / faktorVolumetrik;

double hitungBeratTertagih(double aktual, double volumetrik) =>
    aktual > volumetrik ? aktual : volumetrik;

String tentukanKategori(double berat) {
  if (berat <= 5) return 'Paket Kecil';
  if (berat <= 20) return 'Paket Sedang';
  return 'Kargo';
}

double hitungTotalBerat(List<double> beratList) {
  return beratList.fold(0.0, (sum, b) => sum + b);
}

double hitungRataRataBerat(List<double> beratList) {
  if (beratList.isEmpty) return 0;
  return hitungTotalBerat(beratList) / beratList.length;
}

Map<String, Object> cariKirimanTerberat(List<Map<String, Object>> kiriman) {
  return kiriman.reduce(
    (a, b) =>
        (a['beratTertagih'] as double) > (b['beratTertagih'] as double) ? a : b,
  );
}

Map<String, Object> cariKirimanTeringan(List<Map<String, Object>> kiriman) {
  return kiriman.reduce(
    (a, b) =>
        (a['beratTertagih'] as double) < (b['beratTertagih'] as double) ? a : b,
  );
}

Map<String, int> hitungJumlahPerKategori(List<String> kategoriList) {
  final Map<String, int> rekap = {
    'Paket Kecil': 0,
    'Paket Sedang': 0,
    'Kargo': 0,
  };
  for (final k in kategoriList) {
    rekap[k] = (rekap[k] ?? 0) + 1;
  }
  return rekap;
}

List<Map<String, Object>> prosesSemuaKiriman(
  List<Map<String, Object>> kiriman,
) {
  return kiriman.map((item) {
    final aktual = item['beratAktual'] as double;
    final p = item['panjang'] as double;
    final l = item['lebar'] as double;
    final t = item['tinggi'] as double;
    final volumetrik = hitungBeratVolumetrik(p, l, t);
    final tertagih = hitungBeratTertagih(aktual, volumetrik);
    final kategori = tentukanKategori(tertagih);
    return {
      ...item,
      'beratVolumetrik': volumetrik,
      'beratTertagih': tertagih,
      'kategori': kategori,
    };
  }).toList();
}

void tampilkanHasil(List<Map<String, Object>> hasil) {
  print('=' * 75);
  print('REKAPITULASI KIRIMAN - SiLog');
  print('Nama  : Hasan Zubeir Pohan  |  NIM : 714240045  |  Kelas : 3C');
  print('=' * 75);
  print(
    '${'Resi'.padRight(12)} ${'Kota'.padRight(12)} ${'B.Aktual'.padLeft(10)} ${'B.Volumetrik'.padLeft(14)} ${'B.Tertagih'.padLeft(12)} ${'Kategori'.padLeft(14)}',
  );
  print('-' * 75);

  for (final item in hasil) {
    final resi = item['resi'] as String;
    final kota = item['kota'] as String;
    final aktual = (item['beratAktual'] as double).toStringAsFixed(2);
    final volumetrik = (item['beratVolumetrik'] as double).toStringAsFixed(2);
    final tertagih = (item['beratTertagih'] as double).toStringAsFixed(2);
    final kategori = item['kategori'] as String;
    print(
      '${resi.padRight(12)} ${kota.padRight(12)} ${aktual.padLeft(10)} ${volumetrik.padLeft(14)} ${tertagih.padLeft(12)} ${kategori.padLeft(14)}',
    );
  }

  final beratList = hasil.map((e) => e['beratTertagih'] as double).toList();
  final total = hitungTotalBerat(beratList);
  final rata = hitungRataRataBerat(beratList);
  final terberat = cariKirimanTerberat(hasil);
  final teringan = cariKirimanTeringan(hasil);
  final kategoriList = hasil.map((e) => e['kategori'] as String).toList();
  final perKategori = hitungJumlahPerKategori(kategoriList);

  print('=' * 75);
  print('STATISTIK');
  print('-' * 75);
  print('Total berat tertagih   : ${total.toStringAsFixed(2)} kg');
  print('Rata-rata berat        : ${rata.toStringAsFixed(2)} kg');
  print(
    'Kiriman terberat       : ${terberat['resi']} (${(terberat['beratTertagih'] as double).toStringAsFixed(2)} kg)',
  );
  print(
    'Kiriman teringan       : ${teringan['resi']} (${(teringan['beratTertagih'] as double).toStringAsFixed(2)} kg)',
  );
  print('\nJumlah kiriman per kategori:');
  perKategori.forEach((kat, jml) {
    print('  $kat : $jml kiriman');
  });
  print('=' * 75);
}





void main() {
  final hasil = prosesSemuaKiriman(daftarKiriman);
  tampilkanHasil(hasil);
}
