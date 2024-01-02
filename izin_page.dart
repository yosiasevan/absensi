import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';



class IzinPage extends StatelessWidget {
  final String googleFormUrl =
      'https://forms.gle/EyoWXBonRzHAQ5ZX8';

  const IzinPage({super.key}); // Ganti dengan tautan formulir Google Anda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Izin'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Untuk Melanjutkan Silahkan Klik Tombol Di Bawah',
                style: TextStyle(
                  fontSize: 16.0, // Sesuaikan ukuran teks sesuai kebutuhan
                  fontWeight: FontWeight.bold, // Sesuaikan gaya teks sesuai kebutuhan
                ),
              ),
              const SizedBox(height: 20.0), // Jarak antara teks dan tombol
              // Formulir izin di sini
              ElevatedButton(
                onPressed: () {
                  _openGoogleForm(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Kirim Izin',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openGoogleForm(BuildContext context) async {
    if (await canLaunchUrlString(googleFormUrl)) {
      await launchUrlString(googleFormUrl);
    } else {
      // Jika gagal membuka formulir, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka formulir izin.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
