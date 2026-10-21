import '../lib/model/barang.dart';
import '../lib/model/gudang.dart';
import '../lib/model/pengiriman.dart';
import '../lib/model/pelanggan.dart';

void main() {
  // === Membuat Objek Barang ===
  final sepatu = Barang(
    kode: 'B-1024',
    nama: 'Sepatu Lari Pria',
    hargaSatuan: 450000,
    beratKg: 0.9,
  );
  final kaos = Barang.dariPemindaian('B-2048;Kaos Katun;85000');

  // === Membuat Objek Gudang ===
  final gudangBandung = Gudang(
    kode: 'GD-BDG',
    nama: 'Gudang Utama Bandung',
    kota: 'Bandung',
    kapasitas: 500,
  );

  // === Menerima Barang ke Gudang ===
  gudangBandung.terimaBarang(sepatu, 120);
  gudangBandung.terimaBarang(kaos, 300);
  print(gudangBandung);
  print('Rincian stok: ${gudangBandung.stok}');

  // === Membuat Objek Pelanggan ===
  final pelanggan = Pelanggan(
    kode: 'PLG-001',
    nama: 'Ahmad Fauzi',
    nomorTelepon: '081234567890',
    alamat: 'Jl. Raya Darmo No. 45, Surabaya, Jawa Timur',
  );
  print('\nData Pelanggan:');
  print(pelanggan);
  print('Alamat Ringkas: ${pelanggan.alamatRingkas()}');

  // === Membuat Pengiriman Baru ===
  final kirim = Pengiriman.baru(
    resi: 'SLG-2026-0007',
    asal: gudangBandung,
    kotaTujuan: 'Surabaya',
    barang: sepatu,
    jumlah: 10,
    pelanggan: pelanggan,
  );

  gudangBandung.keluarkanBarang(sepatu, kirim.jumlah);
  print('\n=== Detail Pengiriman ===');
  print(kirim);
  print('Nilai barang: Rp${kirim.nilaiBarang.toStringAsFixed(0)}');

  // === Perubahan Status ===
  kirim.ubahStatus('Dalam Perjalanan');
  print('Status terbaru: ${kirim.status}');

  // === Uji Penolakan: Status mundur ===
  print('\n=== Uji Penolakan Operasi ===');
  try {
    kirim.ubahStatus('Draft');
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  // === Uji Penolakan: Stok tidak cukup ===
  try {
    gudangBandung.keluarkanBarang(sepatu, 9999);
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  // === Uji Penolakan: Harga negatif ===
  try {
    sepatu.hargaSatuan = -1000;
  } on ArgumentError catch (e) {
    print('Ditolak: ${e.message}');
  }
}
