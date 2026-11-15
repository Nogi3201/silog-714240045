import 'package:flutter/material.dart';
import 'data/preferensi.dart';
import 'tampilan/daftar_pengiriman_page.dart';

void main() => runApp(const SiLogApp());

class SiLogApp extends StatefulWidget {
  const SiLogApp({super.key});

  /// Mengizinkan widget anak mengakses state untuk mengubah tema.
  static _SiLogAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_SiLogAppState>()!;
  }

  @override
  State<SiLogApp> createState() => _SiLogAppState();
}

class _SiLogAppState extends State<SiLogApp> {
  bool _modeGelap = false;

  @override
  void initState() {
    super.initState();
    _muatPreferensiTema();
  }

  Future<void> _muatPreferensiTema() async {
    final gelap = await Preferensi.ambilModeGelap();
    if (mounted) {
      setState(() => _modeGelap = gelap);
    }
  }

  /// Dipanggil dari widget anak untuk mengubah tema.
  Future<void> ubahModeGelap(bool aktif) async {
    await Preferensi.simpanModeGelap(aktif);
    setState(() => _modeGelap = aktif);
  }

  bool get modeGelap => _modeGelap;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiLog',
      debugShowCheckedModeBanner: false,
      themeMode: _modeGelap ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const DaftarPengirimanPage(),
    );
  }
}
