double beratVolumetrik(double p, double l, double t, {double faktor = 6000}) =>
    (p * l * t) / faktor;

double beratTertagih({required double aktual, required double volumetrik}) =>
    aktual > volumetrik ? aktual : volumetrik;

double hitungOngkir({
  required double berat,
  required double tarifPerKg,
  bool asuransi = false,
  double persenAsuransi = 0.005,
  double nilaiBarang = 0,
}) {
  double biaya = berat * tarifPerKg;
  if (asuransi) {
    biaya += nilaiBarang * persenAsuransi;
  }
  return biaya;
}

String rupiah(double nilai) => 'Rp${nilai.toStringAsFixed(0)}';

int estimasiHariSampai(String kota) {
  switch (kota.toLowerCase()) {
    case 'bandung':
      return 1;
    case 'surabaya':
      return 2;
    case 'makassar':
      return 3;
    case 'jayapura':
      return 5;
    default:
      return 7;
  }
}

void main() {
  final volumetrik = beratVolumetrik(45, 30, 25);
  final tertagih = beratTertagih(aktual: 12.4, volumetrik: volumetrik);

  final ongkir = hitungOngkir(
    berat: tertagih,
    tarifPerKg: 8500,
    asuransi: true,
    nilaiBarang: 2500000,
  );

  print('Berat tertagih : ${tertagih.toStringAsFixed(2)} kg');
  print('Ongkos kirim   : ${rupiah(ongkir)}');

  
  final kotaUji = ['Bandung', 'Surabaya', 'Makassar', 'Jayapura', 'Medan'];
  print('\n--- Estimasi Hari Sampai ---');
  for (final kota in kotaUji) {
    print('$kota : ${estimasiHariSampai(kota)} hari');
  }
}
