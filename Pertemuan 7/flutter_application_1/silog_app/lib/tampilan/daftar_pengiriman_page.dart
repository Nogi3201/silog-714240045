
import 'package:flutter/material.dart';
import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import 'detail_pengiriman_page.dart';
import 'form_pengiriman_page.dart';

class DaftarPengirimanPage extends StatefulWidget {
  const DaftarPengirimanPage({super.key});

  @override
  State<DaftarPengirimanPage> createState() =>
      _DaftarPengirimanPageState();
}

class _DaftarPengirimanPageState
    extends State<DaftarPengirimanPage> {
  late List<Pengiriman> _daftar;
  String _filterStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _daftar = List<Pengiriman>.from(daftarPengirimanContoh);
  }

  List<Pengiriman> get _hasilSaring {
    if (_filterStatus == 'Semua') {
      return _daftar;
    }

    return _daftar
        .where((p) => p.status == _filterStatus)
        .toList();
  }

  Future<void> _bukaFormulir() async {
    final hasil = await Navigator.push<Pengiriman>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengirimanPage(
          nomorResiTerdaftar:
              _daftar.map((p) => p.resi).toList(),
        ),
      ),
    );

    if (!mounted || hasil == null) return;

    setState(() {
      _daftar.insert(0, hasil);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pengiriman ${hasil.resi} berhasil ditambahkan',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const opsi = [
      'Semua',
      'Draft',
      'Menunggu Pickup',
      'Dalam Perjalanan',
      'Tiba di Kota Tujuan',
      'Diterima',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: opsi.map((o) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(o),
                    selected: _filterStatus == o,
                    onSelected: (_) {
                      setState(() {
                        _filterStatus = o;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Text(
            'Menampilkan ${_hasilSaring.length} '
            'dari ${_daftar.length} data',
          ),

          Expanded(
            child: _hasilSaring.isEmpty
                ? const Center(
                    child: Text('Tidak ada data pengiriman'),
                  )
                : ListView.builder(
                    itemCount: _hasilSaring.length,
                    itemBuilder: (context, i) {
                      final item = _hasilSaring[i];

                      return KartuPengiriman(
                        pengiriman: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailPengirimanPage(
                                pengiriman: item,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _bukaFormulir,
        icon: const Icon(Icons.add),
        label: const Text('Pengiriman Baru'),
      ),
    );
  }
}
