import 'package:flutter/material.dart';
import '../model/pengiriman.dart';

/// Widget kartu untuk menampilkan ringkasan satu data pengiriman.
///
/// Digunakan dalam daftar pengiriman pada [DaftarPengirimanPage].
/// Menampilkan nomor resi, nama barang, rute, status, dan nilai barang.
class KartuPengiriman extends StatelessWidget {
  final Pengiriman pengiriman;

  /// Callback dipanggil ketika kartu diketuk.
  final VoidCallback? onTap;

  const KartuPengiriman({
    super.key,
    required this.pengiriman,
    this.onTap,
  });

  /// Mengembalikan warna latar label status sesuai nilai status.
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

  /// Mengembalikan warna teks label status sesuai nilai status.
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

  /// Memformat angka sebagai mata uang Rupiah tanpa desimal.
  String _formatRupiah(double nilai) {
    final parts = nilai.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(parts[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final p = pengiriman;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris pertama: Resi dan badge status
              Row(
                children: [
                  const Icon(Icons.receipt_long, size: 16, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      p.resi,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.indigo,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _warnaStatus(p.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      p.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _warnaTeksStatus(p.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Nama barang dan jumlah
              Text(
                '${p.barang.nama} × ${p.jumlah} ${p.barang.satuan}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              // Rute pengiriman
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${p.asal.kota}  →  ${p.kotaTujuan}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Pelanggan
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      p.pelanggan.nama,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatRupiah(p.nilaiBarang),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
