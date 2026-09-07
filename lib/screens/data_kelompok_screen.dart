import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Halaman Data Kelompok: menampilkan identitas Tim Supervisor / Shift
// Tim Pengembang Sistem (Nama, NIM, dan peran dalam shift).
//
// Ini StatelessWidget karena isinya cuma menampilkan data, tidak ada
// input dari user yang bisa mengubah tampilan (tidak butuh setState).

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
          // Anggota 1
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.warnaUtama,
                child: Text("1", style: TextStyle(color: Colors.white)),
              ),
              title: const Text("Justin Muhammad Rasyid"),
              subtitle: const Text("NIM: 124240074"),
              trailing: const Text(
                "Lead Dev",
                style: TextStyle(
                  color: AppTheme.warnaUtama,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Anggota 2
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.warnaUtama,
                child: Text("2", style: TextStyle(color: Colors.white)),
              ),
              title: const Text("Kanza Widi Bagaskara"),
              subtitle: const Text("NIM: 124240059"),
              trailing: const Text(
                "Core Logic 1",
                style: TextStyle(
                  color: AppTheme.warnaUtama,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Anggota 3
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.warnaUtama,
                child: Text("3", style: TextStyle(color: Colors.white)),
              ),
              title: const Text("Daniel Roby Maldini"),
              subtitle: const Text("NIM: 124240044"),
              trailing: const Text(
                "Core Logic 2",
                style: TextStyle(
                  color: AppTheme.warnaUtama,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Anggota 4
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.warnaUtama,
                child: Text("4", style: TextStyle(color: Colors.white)),
              ),
              title: const Text("Ahmad Iqbal Kholid"),
              subtitle: const Text("NIM: 124240029"),
              trailing: const Text(
                "UI/UX",
                style: TextStyle(
                  color: AppTheme.warnaUtama,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}