import 'package:flutter/material.dart';
import '../../core/constants/app_data.dart';
import '../../core/widgets/shared_widgets.dart';

double? parseAngka(String teks) {
  String bersih = teks.trim().replaceAll(' ', '');
  if (bersih.isEmpty) return null;

  if (bersih.contains(',') && !bersih.contains('.')) {
    bersih = bersih.replaceAll(',', '.');
  }

  return double.tryParse(bersih);
}

String formatAngka(double nilai) {
  if (nilai.isNaN) return 'tidak terdefinisi';
  if (nilai.isInfinite) return nilai > 0 ? 'tak terhingga' : '-tak terhingga';
  if (nilai == nilai.truncateToDouble()) {
    return nilai.toStringAsFixed(0);
  }
  return nilai.toStringAsFixed(4);
}

enum TipeOperasi { tambah, kurang, kali, bagi }

class AritmatikaScreen extends StatefulWidget {
  const AritmatikaScreen({super.key});

  @override
  State<AritmatikaScreen> createState() => _AritmatikaScreenState();
}

class _AritmatikaScreenState extends State<AritmatikaScreen> {
  final TextEditingController _angkaAController = TextEditingController();
  final TextEditingController _angkaBController = TextEditingController();

  TipeOperasi _operasiTerpilih = TipeOperasi.tambah;

  double? _a;
  double? _b;
  String? _errorMessage;

  @override
  void dispose() {
    _angkaAController.dispose();
    _angkaBController.dispose();
    super.dispose();
  }

  void _hitung() {
    final String teksA = _angkaAController.text;
    final String teksB = _angkaBController.text;

    if (teksA.trim().isEmpty || teksB.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Kedua kolom angka harus diisi.';
        _a = null;
        _b = null;
      });
      return;
    }

    final double? a = parseAngka(teksA);
    final double? b = parseAngka(teksB);

    if (a == null || b == null) {
      setState(() {
        _errorMessage = 'Input tidak valid. Isi hanya dengan angka (boleh '
            'negatif & desimal), contoh: -150000000000 atau 12.5';
        _a = null;
        _b = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _a = a;
      _b = b;
    });
  }

  Widget _buildHasilWidget(double a, double b) {
    String label;
    String hasil;

    switch (_operasiTerpilih) {
      case TipeOperasi.tambah:
        label = 'Penjumlahan (a + b)';
        hasil = formatAngka(a + b);
        break;
      case TipeOperasi.kurang:
        label = 'Pengurangan (a - b)';
        hasil = formatAngka(a - b);
        break;
      case TipeOperasi.kali:
        label = 'Perkalian (a x b)';
        hasil = formatAngka(a * b);
        break;
      case TipeOperasi.bagi:
        if (b == 0) {
          return const ErrorBox(message: 'Pembagian (a : b) tidak terdefinisi karena b = 0');
        }
        label = 'Pembagian (a : b)';
        hasil = formatAngka(a / b);
        break;
    }

    return _HasilRow(label: label, value: hasil);
  }

  // Fungsi untuk membuat tombol pilihan operasi
  Widget _buildTombolOperasi(TipeOperasi operasi, String simbol) {
    final bool isSelected = _operasiTerpilih == operasi;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _operasiTerpilih = operasi;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            simbol,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double? a = _a;
    final double? b = _b;

    return Scaffold(
      appBar: buildAppBar('Operasi Aritmatika'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 14),
              
              TextField(
                controller: _angkaAController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: buildInputDecoration('Angka pertama (a)', prefixIcon: const Icon(Icons.looks_one)),
              ),
              
              const SizedBox(height: 18),
              
              // Barisan tombol operasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTombolOperasi(TipeOperasi.tambah, '+'),
                  _buildTombolOperasi(TipeOperasi.kurang, '-'),
                  _buildTombolOperasi(TipeOperasi.kali, 'x'),
                  _buildTombolOperasi(TipeOperasi.bagi, ':'),
                ],
              ),
              
              const SizedBox(height: 18),
              
              TextField(
                controller: _angkaBController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: buildInputDecoration('Angka kedua (b)', prefixIcon: const Icon(Icons.looks_two)),
              ),
              
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                ErrorBox(message: _errorMessage!),
              ],
              
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _hitung,
                style: kPrimaryButtonStyle,
                child: const Text('Hitung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              
              if (a != null && b != null) ...[
                const SizedBox(height: 24),
                _buildHasilWidget(a, b),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HasilRow extends StatelessWidget {
  final String label;
  final String value;

  const _HasilRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: kTextMuted)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryDark)),
        ],
      ),
    );
  }
}