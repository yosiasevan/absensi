import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);



  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  String webViewUrl = ''; // URL yang akan dimuat di WebView

  List<Map<String, String>> manualSubmitOptions = [
    {'name': 'Muhammad Al Habib', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Muhammad+Al+Habib&entry.2146958867=H'},
    {'name': 'Rosa Melita Sari', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Rosa+Melita+Sari&entry.2146958867=H'},
    {'name': 'Novenilinda Wulan', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Novenilinda+Wulan&entry.2146958867=H'},
    {'name': 'Dandy Frasetya', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Dandy+Frasetya&entry.2146958867=H'},
    {'name': 'Dewani Niken', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Dewani+Niken&entry.2146958867=H'},
    {'name': 'tes sistem', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=tes+sistem&entry.2146958867=H'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: (controller) {
              _controller = controller;
              _controller.scannedDataStream.listen((scanData) {
                _processQRCode(scanData.code);
              });
            },
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Text('Arahkan kamera ke QR code'),
          ),
        ],
      ),
    );
  }

  void _processQRCode(String? qrCode) {
    if (qrCode != null) {
      setState(() {
        webViewUrl = qrCode;
      });

      // Tambahkan logika lain jika diperlukan sebelum atau setelah pemindaian QR code
      _openWebView();
    } else {
      // Tindakan jika hasil scan QR code null
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('QR Code tidak terdeteksi.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _openWebView() async {
    // Cek apakah URL ada dalam daftar manualSubmitOptions
    bool isManualSubmitOption = manualSubmitOptions.any((option) => option['url'] == webViewUrl);

    if (isManualSubmitOption) {
      // Lakukan pengecekan karyawan sesuai dengan logika yang ada di absensi_page.dart
      bool isEmployee = checkIfEmployee(webViewUrl);

      if (isEmployee) {
        // Jika QR code sesuai dengan data karyawan, tampilkan notifikasi "Absen Berhasil"
        _showNotification('Absen Berhasil', 'Anda berhasil melakukan absen.');
        // Setelah pengecekan, buka WebView
        await launchUrlString(webViewUrl);
      } else {
        // Jika QR code tidak sesuai dengan data karyawan, tampilkan notifikasi "Data Karyawan Tidak Ditemukan"
        _showNotification('Data Karyawan Tidak Ditemukan', 'QR code tidak sesuai dengan data karyawan.');
      }
    } else {
      // Jika URL tidak ada dalam daftar manualSubmitOptions
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Data Karyawan Tidak Ditemukan'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showNotification(String title, String message) {
    // Implementasi notifikasi di sini, misalnya dengan menggunakan package flutter_local_notifications
  }

  bool checkIfEmployee(String url) {
    // Implementasikan logika pengecekan karyawan sesuai dengan kebutuhan Anda
    // Anda mungkin perlu mengakses data karyawan dari absensi_page.dart
    // dan membandingkannya dengan QR code atau URL yang diterima dari _openWebView
    return true; // Ganti dengan logika pengecekan yang sesuai
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
