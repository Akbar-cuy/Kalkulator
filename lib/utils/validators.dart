String? requiredText(String? value, {String label = 'Field'}) {
  if (value == null || value.trim().isEmpty) {
    return '$label wajib diisi.';
  }
  return null;
}

String? positiveNumber(String? value, {String label = 'Nilai'}) {
  final number = double.tryParse(value?.replaceAll(',', '.') ?? '');
  if (number == null || number <= 0) {
    return '$label harus berupa angka positif.';
  }
  return null;
}
