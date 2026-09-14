class CultureDateResult {
  final String weton;
  final int neptu;
  final int tahunSaka;

  const CultureDateResult({required this.weton, required this.neptu, required this.tahunSaka});
}

CultureDateResult calculateCultureDate(DateTime date) {
  const pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  const neptuPasaran = [5, 9, 7, 4, 8];
  const neptuHari = [5, 4, 3, 7, 8, 6, 9];
  final reference = DateTime(2024, 1, 1);
  final days = date.difference(reference).inDays;
  final pasaranIndex = (days % 5 + 5) % 5;
  final hariIndex = date.weekday - 1;
  return CultureDateResult(
    weton: '${_hari(date.weekday)} ${pasaran[pasaranIndex]}',
    neptu: neptuHari[hariIndex] + neptuPasaran[pasaranIndex],
    tahunSaka: date.year - (date.month < 3 ? 79 : 78),
  );
}

String _hari(int weekday) => const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'][weekday - 1];
