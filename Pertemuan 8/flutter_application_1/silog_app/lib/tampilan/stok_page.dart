import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/stok_repository.dart';
import '../model/stok.dart';

/// Halaman Stok Gudang – Modul 08.
///
/// Menampilkan daftar stok barang, total stok, tombol tambah stok,
/// tombol tambah/kurang jumlah, dan hapus dengan konfirmasi.
class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final _repo = StokRepository.instance;

  List<Stok> _daftar = [];
  List<Stok> _hasilCari = [];
  bool _sedangMuat = true;
  String _kataCari = '';

  final _cariC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  @override
  void dispose() {
    _cariC.dispose();
    super.dispose();
  }

  Future<void> _muatData() async {
    setState(() => _sedangMuat = true);
    try {
      final data = _kataCari.isEmpty
          ? await _repo.ambilSemua()
          : await _repo.cariNamaBarang(_kataCari);
      setState(() {
        _daftar = await _repo.ambilSemua();
        _hasilCari = data;
        _sedangMuat = false;
      });
    } catch (_) {
      setState(() => _sedangMuat = false);
    }
  }

  Future<void> _muatUlang() async {
    final data = _kataCari.isEmpty
        ? await _repo.ambilSemua()
        : await _repo.cariNamaBarang(_kataCari);
    final semua = await _repo.ambilSemua();
    if (!mounted) return;
    setState(() {
      _daftar = semua;
      _hasilCari = data;
    });
  }

  int get _totalStok =>
      _daftar.fold(0, (total, s) => total + s.jumlah);

  // ─────────────────────────── Dialog Tambah Stok ───────────────────────────

  Future<void> _bukaFormTambah() async {
    final formKey = GlobalKey<FormState>();
    final kodeBarangC = TextEditingController();
    final namaBarangC = TextEditingController();
    final kodeGudangC = TextEditingController();
    final jumlahC = TextEditingController();

    String? _wajib(String? v, String label) {
      if (v == null || v.trim().isEmpty) return '$label wajib diisi';
      return null;
    }

    String? _validasiJumlah(String? v) {
      final dasar = _wajib(v, 'Jumlah');
      if (dasar != null) return dasar;
      final angka = int.tryParse(v!.trim());
      if (angka == null) return 'Jumlah harus berupa bilangan bulat';
      if (angka < 1) return 'Jumlah minimal 1';
      return null;
    }

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Stok Barang'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: kodeBarangC,
                    decoration: const InputDecoration(
                      labelText: 'Kode Barang',
                      hintText: 'Contoh: BRG-001',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) => _wajib(v, 'Kode barang'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: namaBarangC,
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => _wajib(v, 'Nama barang'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: kodeGudangC,
                    decoration: const InputDecoration(
                      labelText: 'Kode Gudang',
                      hintText: 'Contoh: GDG-JKT',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) => _wajib(v, 'Kode gudang'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: jumlahC,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: _validasiJumlah,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final stok = Stok(
                  kodeBarang: kodeBarangC.text.trim().toUpperCase(),
                  namaBarang: namaBarangC.text.trim(),
                  kodeGudang: kodeGudangC.text.trim().toUpperCase(),
                  jumlah: int.parse(jumlahC.text.trim()),
                );
                await _repo.simpan(stok);
                if (ctx.mounted) Navigator.pop(ctx);
                await _muatUlang();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stok berhasil ditambahkan')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────── Tambah / Kurang Jumlah ───────────────────────────

  Future<void> _ubahJumlah(Stok stok, int delta) async {
    final jumlahBaru = stok.jumlah + delta;
    if (jumlahBaru < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah stok tidak boleh negatif')),
      );
      return;
    }
    final diperbarui = stok.salinDengan(jumlah: jumlahBaru);
    await _repo.perbarui(diperbarui);
    await _muatUlang();
  }

  // ─────────────────────────── Hapus dengan Konfirmasi ─────────────────────

  Future<void> _konfirmasiHapus(Stok stok) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Stok'),
        content: Text(
          'Yakin ingin menghapus "${stok.namaBarang}" '
          '(${stok.kodeGudang})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && stok.id != null) {
      await _repo.hapus(stok.id!);
      await _muatUlang();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${stok.namaBarang} dihapus'),
          ),
        );
      }
    }
  }

  // ────────────────────────────── Build ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Gudang'),
      ),
      body: Column(
        children: [
          // ── Ringkasan total stok ──
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warehouse_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 10),
                Text(
                  'Total Stok Semua Gudang',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const Spacer(),
                Text(
                  '$_totalStok unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // ── Kolom pencarian ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: TextField(
              controller: _cariC,
              decoration: InputDecoration(
                hintText: 'Cari nama barang...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _kataCari.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _cariC.clear();
                          setState(() => _kataCari = '');
                          _muatUlang();
                        },
                      ),
              ),
              onChanged: (v) {
                setState(() => _kataCari = v.trim());
                _muatUlang();
              },
            ),
          ),

          // ── Keterangan jumlah ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                Text(
                  'Menampilkan ${_hasilCari.length} dari ${_daftar.length} data',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // ── Daftar stok ──
          Expanded(
            child: _sedangMuat
                ? const Center(child: CircularProgressIndicator())
                : _hasilCari.isEmpty
                    ? const Center(
                        child: Text('Belum ada data stok'),
                      )
                    : ListView.builder(
                        itemCount: _hasilCari.length,
                        itemBuilder: (context, i) {
                          final stok = _hasilCari[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  // Info barang
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stok.namaBarang,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${stok.kodeBarang}  •  ${stok.kodeGudang}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Tombol kurang
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    color: Colors.orange,
                                    tooltip: 'Kurangi stok',
                                    onPressed: () => _ubahJumlah(stok, -1),
                                  ),

                                  // Jumlah
                                  SizedBox(
                                    width: 42,
                                    child: Text(
                                      '${stok.jumlah}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),

                                  // Tombol tambah
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: Colors.green,
                                    tooltip: 'Tambah stok',
                                    onPressed: () => _ubahJumlah(stok, 1),
                                  ),

                                  // Tombol hapus
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red,
                                    tooltip: 'Hapus',
                                    onPressed: () => _konfirmasiHapus(stok),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Stok'),
      ),
    );
  }
}

