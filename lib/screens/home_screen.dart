import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../widgets/shared_widgets.dart';
import 'login_screen.dart';
import 'data_kelompok_screen.dart';
import 'aritmatika_screen.dart';
import 'ganjil_genap_screen.dart';
import 'jumlah_total_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang, $username!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryDark),
              ),
              const SizedBox(height: 4),
              const Text(namaApl, style: TextStyle(fontSize: 13, color: kTextMuted)),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.05,
                children: [
                  MenuCard(
                    icon: Icons.group,
                    label: 'Data Kelompok',
                    color: kPrimaryColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DataKelompokScreen()));
                    },
                  ),
                  MenuCard(
                    icon: Icons.calculate,
                    label: 'Operasi Aritmatika',
                    color: kAccentColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AritmatikaScreen()));
                    },
                  ),
                  MenuCard(
                    icon: Icons.numbers,
                    label: 'Ganjil / Genap',
                    color: kSuccessColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GanjilGenapScreen()));
                    },
                  ),
                  MenuCard(
                    icon: Icons.functions,
                    label: 'Jumlah Angka dalam Teks',
                    color: kPrimaryDark,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const JumlahTotalScreen()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}