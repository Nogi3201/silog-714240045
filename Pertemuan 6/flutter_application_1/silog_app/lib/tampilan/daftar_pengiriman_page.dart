import 'package:flutter/material.dart';
import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import 'detail_pengiriman_page.dart';

/// Halaman daftar pengiriman dengan TabBar (Semua / Dalam Perjalanan / Diterima)
/// dan widget ringkasan jumlah pengiriman serta total nilai barang.
class DaftarPengirimanPage extends StatelessWidget {
  const DaftarPengirimanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengiriman'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Cari resi',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Dalam Perjalanan'),
              Tab(text: 'Diterima'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PanelDaftar(daftar: daftarPengirimanContoh),
            _PanelDaftar(
              daftar: daftarPengirimanContoh
                  .where((p) => p.status == 'Dalam Perjalanan')
                  .toList(),
            ),
            _PanelDaftar(
              daftar: daftarPengirimanContoh
                  .where((p) => p.status == 'Diterima')
                  .toList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Pengiriman Baru'),
        ),
      ),
    );
  }
}

/// Panel internal yang menampilkan ringkasan dan daftar pengiriman
/// untuk satu tab.
class _PanelDaftar extends StatelessWidget {
  final List<Pengiriman> daftar;

  const _PanelDaftar({required this.daftar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RingkasanPengiriman(daftar: daftar),
        Expanded(
          child: daftar.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tidak ada pengiriman',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: daftar.length,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    final pengiriman = daftar[index];
                    return KartuPengiriman(
                      pengiriman: pengiriman,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPengirimanPage(
                              pengiriman: pengiriman,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Widget ringkasan yang menampilkan jumlah pengiriman dan total nilai barang.
class _RingkasanPengiriman extends StatelessWidget {
  final List<Pengiriman> daftar;

  const _RingkasanPengiriman({required this.daftar});

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
    final jumlahPengiriman = daftar.length;
    final totalNilai = daftar.fold<double>(
      0,
      (sum, p) => sum + p.nilaiBarang,
    );

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ItemRingkasan(
              ikon: Icons.local_shipping_outlined,
              label: 'Jumlah Pengiriman',
              nilai: '$jumlahPengiriman kiriman',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(60),
          ),
          Expanded(
            child: _ItemRingkasan(
              ikon: Icons.attach_money,
              label: 'Total Nilai Barang',
              nilai: _formatRupiah(totalNilai),
            ),
          ),
        ],
      ),
    );
  }
}

/// Satu item dalam widget ringkasan.
class _ItemRingkasan extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;

  const _ItemRingkasan({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(ikon, color: Theme.of(context).colorScheme.onPrimaryContainer),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          nilai,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
