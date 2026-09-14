class WorkoutModel {
  final String? id;
  final String namaLatihan;
  final String kategori;
  final DateTime tanggal;
  final int durasiMenit;
  final String catatan;

  const WorkoutModel({
    this.id,
    required this.namaLatihan,
    required this.kategori,
    required this.tanggal,
    required this.durasiMenit,
    this.catatan = '',
  });

  factory WorkoutModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return WorkoutModel(
      id: id,
      namaLatihan: map['namaLatihan'] as String? ?? '',
      kategori: map['kategori'] as String? ?? 'Lainnya',
      tanggal: (map['tanggal'] as DateTime?) ?? DateTime.now(),
      durasiMenit: (map['durasiMenit'] as num?)?.toInt() ?? 0,
      catatan: map['catatan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaLatihan': namaLatihan,
      'kategori': kategori,
      'tanggal': tanggal,
      'durasiMenit': durasiMenit,
      'catatan': catatan,
    };
  }
}
