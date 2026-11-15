import 'package:flutter/material.dart';
import '../model/pengiriman.dart';

/// Halaman detail untuk satu pengiriman.
///
/// Menampilkan informasi pengiriman, informasi pelanggan, dan rincian barang.
class DetailPengirimanPage extends StatelessWidget {
  final Pengiriman pengiriman;

  const DetailPengirimanPage({super.key, required this.pengiriman});

  /// Memformat angka sebagai mata uang Rupiah.
  String _formatRupiah(double nilai) {
    final angka = nilai.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < angka.length; i++) {
      if (i > 0 && (angka.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(angka[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  /// Memformat tanggal menjadi dd/MM/yyyy.
  String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green.shade100;
      case 'Dalam Perjalanan':
        return Colors.blue.shade100;
      case 'Tiba di Kota Tujuan':
        return Colors.teal.shade100;
      case 'Menunggu Pickup':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _warnaTeksStatus(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green.shade800;
      case 'Dalam Perjalanan':
        return Colors.blue.shade800;
      case 'Tiba di Kota Tujuan':
        return Colors.teal.shade800;
      case 'Menunggu Pickup':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = pengiriman;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.resi),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_long),
                        const SizedBox(width: 8),
                        const Text(
                          'Nomor Resi',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.resi,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _warnaStatus(p.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        p.status,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _warnaTeksStatus(p.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _KartuSeksi(
              judul: 'Informasi Pengiriman',
              ikon: Icons.local_shipping_outlined,
              children: [
                _BarisSeksi(
                  label: 'Gudang Asal',
                  nilai: '${p.asal.nama} (${p.asal.kota})',
                ),
                _BarisSeksi(label: 'Kota Tujuan', nilai: p.kotaTujuan),
                _BarisSeksi(
                  label: 'Tanggal Kirim',
                  nilai: _formatTanggal(p.tanggalKirim),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _KartuSeksi(
              judul: 'Informasi Pelanggan',
              ikon: Icons.person_outline,
              children: [
                _BarisSeksi(
                  label: 'Kode Pelanggan',
                  nilai: p.pelanggan.kode,
                ),
                _BarisSeksi(label: 'Nama', nilai: p.pelanggan.nama),
                _BarisSeksi(
                  label: 'Telepon',
                  nilai: p.pelanggan.nomorTelepon,
                ),
                _BarisSeksi(label: 'Alamat', nilai: p.pelanggan.alamat),
              ],
            ),
            const SizedBox(height: 12),
            _KartuSeksi(
              judul: 'Rincian Barang',
              ikon: Icons.inventory_2_outlined,
              children: [
                _BarisSeksi(label: 'Kode Barang', nilai: p.barang.kode),
                _BarisSeksi(label: 'Nama Barang', nilai: p.barang.nama),
                _BarisSeksi(label: 'Satuan', nilai: p.barang.satuan),
                _BarisSeksi(
                  label: 'Berat Satuan',
                  nilai: '${p.barang.beratKg} kg',
                ),
                _BarisSeksi(
                  label: 'Harga Satuan',
                  nilai: _formatRupiah(p.barang.hargaSatuan),
                ),
                _BarisSeksi(
                  label: 'Jumlah',
                  nilai: '${p.jumlah} ${p.barang.satuan}',
                ),
                const Divider(),
                _BarisSeksi(
                  label: 'Total Nilai Barang',
                  nilai: _formatRupiah(p.nilaiBarang),
                  tebal: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Daftar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu seksi dengan judul dan daftar baris informasi.
class _KartuSeksi extends StatelessWidget {
  final String judul;
  final IconData ikon;
  final List<Widget> children;

  const _KartuSeksi({
    required this.judul,
    required this.ikon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikon, size: 20),
                const SizedBox(width: 8),
                Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Satu baris label dan nilai pada kartu informasi.
class _BarisSeksi extends StatelessWidget {
  final String label;
  final String nilai;
  final bool tebal;

  const _BarisSeksi({
    required this.label,
    required this.nilai,
    this.tebal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              nilai,
              style: TextStyle(
                fontSize: 13,
                fontWeight: tebal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
