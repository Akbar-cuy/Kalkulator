import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../widgets/shared_widgets.dart';

class JumlahTotalScreen extends StatefulWidget {
  const JumlahTotalScreen({super.key});

  @override
  State<JumlahTotalScreen> createState() => _JumlahTotalScreenState();
}

class _JumlahTotalScreenState extends State<JumlahTotalScreen> {
  final TextEditingController _teksController = TextEditingController();
  int? _jumlahAngka;
  List<String> _daftarAngkaDitemukan = [];

  @override
  void dispose() {
    _teksController.dispose();
    super.dispose();
  }

  void _hitungAngka() {
    final String teks = _teksController.text;
    final RegExp polaAngka = RegExp(r'\d+');
    final List<String> ditemukan = polaAngka.allMatches(teks).map((m) => m.group(0)!).toList();

    setState(() {
      _daftarAngkaDitemukan = ditemukan;
      _jumlahAngka = ditemukan.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int? jumlah = _jumlahAngka;

    return Scaffold(
      appBar: buildAppBar('Jumlah Angka dalam Teks'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            const SizedBox(height: 16),
            TextField(
              controller: _teksController,
              maxLines: 3,
              decoration: buildInputDecoration('Masukkan teks di sini'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _hitungAngka,
              style: kPrimaryButtonStyle,
              child: const Text('Hitung Jumlah Angka', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            if (jumlah != null) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const Text('JUMLAH ANGKA DITEMUKAN', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
                    const SizedBox(height: 6),
                    Text('$jumlah', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (_daftarAngkaDitemukan.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Angka yang ditemukan: ${_daftarAngkaDitemukan.join(', ')}',
                  style: const TextStyle(fontSize: 13, color: kTextMuted),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}