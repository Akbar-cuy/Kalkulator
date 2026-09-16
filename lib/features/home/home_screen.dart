import 'package:flutter/material.dart';
import 'package:nando/core/constants/app_data.dart';
import 'package:nando/core/widgets/shared_widgets.dart';
import 'package:nando/features/age_hijri/age_hijri_screen.dart';
import 'package:nando/features/culture_calendar/culture_calendar_screen.dart';
import 'package:nando/features/fitness_calculator/fitness_calculator_screen.dart';
import 'package:nando/features/team/data_kelompok_screen.dart';
import 'package:nando/features/workout/workout_crud_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [kPrimaryColor, kPrimaryDark]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $username!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Semangat berlatih hari ini.',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  children: [
                  MenuCard(
                    icon: Icons.group,
                    label: 'Data Kelompok',
                    color: kPrimaryColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DataKelompokScreen()));
                    },
                  ),
                  const SizedBox(height: 16),
                  MenuCard(
                    icon: Icons.fitness_center,
                    label: 'Komputasi Kebugaran',
                    color: kAccentColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FitnessCalculatorScreen()));
                    },
                  ),
                  const SizedBox(height: 16),
                  MenuCard(
                    icon: Icons.event_note,
                    label: 'Jadwal Workout',
                    color: kSuccessColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutCrudScreen()));
                    },
                  ),
                  const SizedBox(height: 16),
                  MenuCard(
                    icon: Icons.calendar_month,
                    label: 'Kalender Hijriah dan Umur',
                    color: kPrimaryDark,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AgeHijriScreen()));
                    },
                  ),
                  const SizedBox(height: 16),
                  MenuCard(
                    icon: Icons.public,
                    label: 'Kalender Budaya',
                    color: kPrimaryColor,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CultureCalendarScreen()));
                    },
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}