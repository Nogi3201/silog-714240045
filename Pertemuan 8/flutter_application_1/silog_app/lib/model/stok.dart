/// Model stok barang di gudang untuk penyimpanan lokal (Modul 08).
class Stok {
  final int? id;
  final String kodeBarang;
  final String namaBarang;
  final String kodeGudang;
  final int jumlah;
  final DateTime diperbaruiPada;

  Stok({
    this.id,
    required this.kodeBarang,
    required this.namaBarang,
    required this.kodeGudang,
    required this.jumlah,
    DateTime? diperbaruiPada,
  }) : diperbaruiPada = diperbaruiPada ?? DateTime.now();

  /// Mengubah objek Stok menjadi Map untuk disimpan ke database.
  Map<String, dynamic> toMap() {
    return {
      'kodeBarang': kodeBarang,
      'namaBarang': namaBarang,
      'kodeGudang': kodeGudang,
      'jumlah': jumlah,
      'diperbaruiPada': diperbaruiPada.toIso8601String(),
    };
  }

  /// Membuat objek Stok dari Map hasil baca database.
  factory Stok.fromMap(Map<String, dynamic> map, {int? id}) {
    return Stok(
      id: id,
      kodeBarang: map['kodeBarang'] as String,
      namaBarang: map['namaBarang'] as String,
      kodeGudang: map['kodeGudang'] as String,
      jumlah: map['jumlah'] as int,
      diperbaruiPada: DateTime.parse(map['diperbaruiPada'] as String),
    );
  }

  /// Membuat salinan objek dengan nilai yang diperbarui.
  Stok salinDengan({
    int? id,
    String? kodeBarang,
    String? namaBarang,
    String? kodeGudang,
    int? jumlah,
    DateTime? diperbaruiPada,
  }) {
    return Stok(
      id: id ?? this.id,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      kodeGudang: kodeGudang ?? this.kodeGudang,
      jumlah: jumlah ?? this.jumlah,
      diperbaruiPada: diperbaruiPada ?? DateTime.now(),
    );
  }

  @override
  String toString() =>
      '[${kodeBarang}] $namaBarang – Gudang $kodeGudang – $jumlah unit';
}

