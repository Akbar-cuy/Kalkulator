import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../widgets/shared_widgets.dart';

class GanjilGenapScreen extends StatefulWidget {
  const GanjilGenapScreen({super.key});

  @override
  State<GanjilGenapScreen> createState() => _GanjilGenapScreenState();
}

class _GanjilGenapScreenState extends State<GanjilGenapScreen> {
  final TextEditingController _angkaController = TextEditingController();
  String? _hasil;
  bool _genap = false;
  String? _errorMessage;

  @override
  void dispose() {
    _angkaController.dispose();
    super.dispose();
  }

  void _cekAngka() {
    final String teks = _angkaController.text.trim().replaceAll(' ', '');

    if (teks.isEmpty) {
      setState(() {
        _errorMessage = 'Kolom angka harus diisi.';
        _hasil = null;
      });
      return;
    }

    if (!RegExp(r'^[+-]?\d+$').hasMatch(teks)) {
      setState(() {
        _errorMessage = 'Input tidak valid. Ganjil/genap hanya berlaku untuk '
            'bilangan bulat (boleh negatif & besar), bukan desimal.';
        _hasil = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _genap = '02468'.contains(teks[teks.length - 1]);
      _hasil = '$teks adalah bilangan ${_genap ? 'GENAP' : 'GANJIL'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('Cek Ganjil / Genap'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _angkaController,
                keyboardType: TextInputType.numberWithOptions(signed: true),
                decoration: buildInputDecoration('Masukkan bilangan bulat', prefixIcon: const Icon(Icons.numbers)),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                ErrorBox(message: _errorMessage!),
              ],
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _cekAngka,
                style: kPrimaryButtonStyle,
                child: const Text('Cek Angka', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              if (_hasil != null) ...[
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _genap ? kSuccessColor.withOpacity(0.1) : kAccentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: _genap ? kSuccessColor : kAccentColor, size: 46),
                      const SizedBox(height: 12),
                      Text(
                        _genap ? 'GENAP' : 'GANJIL',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _genap ? kSuccessColor : kAccentColor),
                      ),
                      const SizedBox(height: 6),
                      Text(_hasil!, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}