import '../model/barang.dart';
import '../model/gudang.dart';
import '../model/pelanggan.dart';
import '../model/pengiriman.dart';

/// Kumpulan data contoh untuk demonstrasi aplikasi SiLog Modul 06.
final List<Pengiriman> daftarPengirimanContoh = _buatDataContoh();

List<Pengiriman> _buatDataContoh() {
  // --- Barang ---
  final barangLaptop = Barang(
    kode: 'BRG-001',
    nama: 'Laptop UltraSlim 14"',
    hargaSatuan: 12500000,
    satuan: 'unit',
    beratKg: 1.5,
  );
  final barangMonitor = Barang(
    kode: 'BRG-002',
    nama: 'Monitor LED 27"',
    hargaSatuan: 3800000,
    satuan: 'unit',
    beratKg: 5.2,
  );
  final barangKursiKantor = Barang(
    kode: 'BRG-003',
    nama: 'Kursi Kantor Ergonomis',
    hargaSatuan: 2200000,
    satuan: 'unit',
    beratKg: 12.0,
  );
  final barangHeadset = Barang(
    kode: 'BRG-004',
    nama: 'Headset Wireless Pro',
    hargaSatuan: 850000,
    satuan: 'unit',
    beratKg: 0.35,
  );
  final barangMeja = Barang(
    kode: 'BRG-005',
    nama: 'Meja Kerja Standing Desk',
    hargaSatuan: 4500000,
    satuan: 'unit',
    beratKg: 28.0,
  );
  final barangKamera = Barang(
    kode: 'BRG-006',
    nama: 'Kamera Mirrorless APS-C',
    hargaSatuan: 9800000,
    satuan: 'unit',
    beratKg: 0.7,
  );

  // --- Gudang ---
  final gudangJakarta = Gudang(
    kode: 'GDG-JKT',
    nama: 'Gudang Utama Jakarta',
    kota: 'Jakarta',
    kapasitas: 5000,
  );
  final gudangSurabaya = Gudang(
    kode: 'GDG-SBY',
    nama: 'Gudang Surabaya Timur',
    kota: 'Surabaya',
    kapasitas: 3000,
  );
  final gudangBandung = Gudang(
    kode: 'GDG-BDG',
    nama: 'Gudang Bandung Selatan',
    kota: 'Bandung',
    kapasitas: 2000,
  );

  // --- Pelanggan ---
  final pelangganAdi = Pelanggan(
    kode: 'PLG-001',
    nama: 'Adi Santoso',
    nomorTelepon: '081234567890',
    alamat: 'Jl. Mawar No. 12, Kelurahan Menteng, Jakarta Pusat, DKI Jakarta 10310',
  );
  final pelangganBudi = Pelanggan(
    kode: 'PLG-002',
    nama: 'Budi Prasetyo',
    nomorTelepon: '085678901234',
    alamat: 'Jl. Kenanga No. 45, Kecamatan Rungkut, Surabaya, Jawa Timur 60293',
  );
  final pelangganCitra = Pelanggan(
    kode: 'PLG-003',
    nama: 'Citra Dewi Lestari',
    nomorTelepon: '082345678901',
    alamat: 'Jl. Dago Pojok No. 7, Bandung Utara, Jawa Barat 40135',
  );
  final pelangganDana = Pelanggan(
    kode: 'PLG-004',
    nama: 'Dana Firmansyah',
    nomorTelepon: '087890123456',
    alamat: 'Jl. Pemuda No. 88, Semarang Tengah, Jawa Tengah 50132',
  );
  final pelangganEvi = Pelanggan(
    kode: 'PLG-005',
    nama: 'Evi Kurniawati',
    nomorTelepon: '089012345678',
    alamat: 'Jl. Sudirman No. 33, Makassar, Sulawesi Selatan 90113',
  );
  final pelangganFajar = Pelanggan(
    kode: 'PLG-006',
    nama: 'Fajar Nugroho',
    nomorTelepon: '083456789012',
    alamat: 'Jl. Gajah Mada No. 21, Medan, Sumatera Utara 20111',
  );

  // --- Pengiriman ---
  final p1 = Pengiriman(
    resi: 'SLG-20241101-001',
    asal: gudangJakarta,
    kotaTujuan: 'Surabaya',
    barang: barangLaptop,
    jumlah: 2,
    tanggalKirim: DateTime(2024, 11, 1),
    pelanggan: pelangganAdi,
    status: 'Dalam Perjalanan',
  );

  final p2 = Pengiriman(
    resi: 'SLG-20241101-002',
    asal: gudangSurabaya,
    kotaTujuan: 'Bandung',
    barang: barangMonitor,
    jumlah: 3,
    tanggalKirim: DateTime(2024, 11, 1),
    pelanggan: pelangganBudi,
    status: 'Diterima',
  );

  final p3 = Pengiriman(
    resi: 'SLG-20241102-003',
    asal: gudangBandung,
    kotaTujuan: 'Semarang',
    barang: barangKursiKantor,
    jumlah: 5,
    tanggalKirim: DateTime(2024, 11, 2),
    pelanggan: pelangganCitra,
    status: 'Dalam Perjalanan',
  );

  final p4 = Pengiriman(
    resi: 'SLG-20241102-004',
    asal: gudangJakarta,
    kotaTujuan: 'Makassar',
    barang: barangHeadset,
    jumlah: 10,
    tanggalKirim: DateTime(2024, 11, 2),
    pelanggan: pelangganDana,
    status: 'Diterima',
  );

  final p5 = Pengiriman(
    resi: 'SLG-20241103-005',
    asal: gudangSurabaya,
    kotaTujuan: 'Medan',
    barang: barangMeja,
    jumlah: 1,
    tanggalKirim: DateTime(2024, 11, 3),
    pelanggan: pelangganEvi,
    status: 'Menunggu Pickup',
  );

  final p6 = Pengiriman(
    resi: 'SLG-20241103-006',
    asal: gudangJakarta,
    kotaTujuan: 'Bandung',
    barang: barangKamera,
    jumlah: 4,
    tanggalKirim: DateTime(2024, 11, 3),
    pelanggan: pelangganFajar,
    status: 'Dalam Perjalanan',
  );

  final p7 = Pengiriman(
    resi: 'SLG-20241104-007',
    asal: gudangBandung,
    kotaTujuan: 'Jakarta',
    barang: barangLaptop,
    jumlah: 1,
    tanggalKirim: DateTime(2024, 11, 4),
    pelanggan: pelangganBudi,
    status: 'Diterima',
  );

  final p8 = Pengiriman(
    resi: 'SLG-20241104-008',
    asal: gudangJakarta,
    kotaTujuan: 'Surabaya',
    barang: barangMonitor,
    jumlah: 2,
    tanggalKirim: DateTime(2024, 11, 4),
    pelanggan: pelangganAdi,
    status: 'Draft',
  );

  return [p1, p2, p3, p4, p5, p6, p7, p8];
}
