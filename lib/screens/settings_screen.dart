import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final bool isSoundEnabled;
  final Function(bool) onToggleSound;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.isSoundEnabled,
    required this.onToggleSound,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Variabel lokal agar toggle langsung merespon klik
  late bool _localIsDark;
  late bool _localIsSound;

  @override
  void initState() {
    super.initState();
    _localIsDark = widget.isDarkMode;
    _localIsSound = widget.isSoundEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _localIsDark ? const Color(0xFF121214) : const Color(0xFFF5F6F9),
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Tampilan"),
          Card(
            elevation: _localIsDark ? 0 : 2,
            color: _localIsDark ? const Color(0xFF1E1E24) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: Icon(_localIsDark ? Icons.dark_mode : Icons.light_mode, color: Colors.amber),
              title: const Text("Mode Gelap"),
              subtitle: Text(_localIsDark ? "Aktif" : "Nonaktif"),
              value: _localIsDark,
              onChanged: (val) {
                setState(() {
                  _localIsDark = val;
                });
                widget.onToggleTheme(); // Panggil fungsi utama
              },
              activeColor: Colors.indigoAccent,
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Suara & Getaran"),
          Card(
            elevation: _localIsDark ? 0 : 2,
            color: _localIsDark ? const Color(0xFF1E1E24) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: Icon(_localIsSound ? Icons.volume_up : Icons.volume_off, color: Colors.indigoAccent),
              title: const Text("Suara Tombol"),
              subtitle: Text(_localIsSound ? "Suara aktif saat menekan tombol" : "Suara dimatikan"),
              value: _localIsSound,
              onChanged: (val) {
                setState(() {
                  _localIsSound = val;
                });
                widget.onToggleSound(val); // Panggil fungsi utama
              },
              activeColor: Colors.indigoAccent,
            ),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              "Kalkulator Pintar v1.1.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
