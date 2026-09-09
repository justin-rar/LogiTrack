import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Menampilkan profil anggota tim pengembang LogiTrack.
class DataKelompokScreen extends StatelessWidget {
  const DataKelompokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Kelompok"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAnggotaCard("1", "Justin Muhammad Rasyid", "124240074", "Lead Dev"),
          const SizedBox(height: 8),
          _buildAnggotaCard("2", "Kanza Widi Bagaskara", "124240059", "Core Logic 1"),
          const SizedBox(height: 8),
          _buildAnggotaCard("3", "Daniel Roby Maldini", "124240044", "Core Logic 2"),
          const SizedBox(height: 8),
          _buildAnggotaCard("4", "Ahmad Iqbal Kholid", "124240029", "UI/UX"),
        ],
      ),
    );
  }

  /// Membuat card profil anggota tim.
  Widget _buildAnggotaCard(String nomor, String nama, String nim, String peran) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.warnaUtama,
          child: Text(nomor, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(nama),
        subtitle: Text("NIM: $nim"),
        trailing: Text(
          peran,
          style: const TextStyle(
            color: AppTheme.warnaUtama,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}