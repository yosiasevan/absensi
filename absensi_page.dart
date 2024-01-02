import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'scan_screen.dart';
import 'izin_page.dart';
import '../models/employee.dart';
import '../helpers/database_helper.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({Key? key}) : super(key: key);

  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  List<Employee> employees = [];
  final DatabaseHelper dbHelper = DatabaseHelper();
  Employee? selectedEmployee;

  List<Map<String, String>> manualSubmitOptions = [

    {'name': 'Rosa Melita Sari', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Rosa+Melita+Sari&entry.2146958867=H'},
    {'name': 'Novenilinda Wulan', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Novenilinda+Wulan&entry.2146958867=H'},
    {'name': 'Dandy Frasetya', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Dandy+Frasetya&entry.2146958867=H'},
    {'name': 'Dewani Niken', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Dewani+Niken&entry.2146958867=H'},
    {'name': 'tes sistem', 'url': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=tes+sistem&entry.2146958867=H'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await dbHelper.open();
    await dbHelper.insertInitialData();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    List<Employee> loadedEmployees = await dbHelper.getEmployees();

    setState(() {
      employees = loadedEmployees;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 200.0; // Atur sesuai dengan lebar yang diinginkan

    return Scaffold(
      appBar: AppBar(
        title: const Text('AM BANTUL WARUNG'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Ganti warna sesuai brand
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100.0, width: 100.0),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _absen('pagi');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: SizedBox(
                width: buttonWidth,
                child: Column(
                  children: [
                    Image.asset('assets/absen.png', height: 50.0, fit: BoxFit.cover),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Absen Pagi',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _absen('pulang');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: SizedBox(
                width: buttonWidth,
                child: Column(
                  children: [
                    Image.asset('assets/absen.png', height: 50.0),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Absen Pulang',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _navigateToIzinPage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: SizedBox(
                width: buttonWidth,
                child: Column(
                  children: [
                    Image.asset('assets/izin.png', height: 50.0),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Izin',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _absen(String jenisAbsen) async {
    DateTime currentTime = DateTime.now();
    int cutoffMorningStartHour = 7;
    int cutoffMorningEndHour = 9;
    int cutoffEveningStartHour = 21;
    int cutoffEveningEndHour = 23;

    if (jenisAbsen == 'pagi' &&
        (currentTime.hour < cutoffMorningStartHour ||
            currentTime.hour >= cutoffMorningEndHour)) {
      if (currentTime.hour < cutoffMorningStartHour) {

      } else {
        _showAlertDialog(
          'Absen Pagi',
          'Bukan Waktu Absen Pagi, Absen Pagi Pukul 07.00-09.00. Untuk Melanjutkan klik tombol Scan.',
        );
      }
      return;
    } else if (jenisAbsen == 'pulang' &&
        (currentTime.hour < cutoffEveningStartHour ||
            currentTime.hour >= cutoffEveningEndHour)) {
      if (currentTime.hour < cutoffEveningStartHour) {
        _showAlertDialog(
          'Absen Pulang',
          'Bukan Waktu Absen Pulang, Absen pulang pukul 21.00 - 23.00 WIB. Untuk Melanjutkan Klik Tombol Scan.',

        );
      } else {
        _showAlertDialog(
          'Absen Pulang',
          'Absen pulang hanya dapat dilakukan antara pukul 21.00 WIB hingga 23.00 WIB.',
        );
      }
      return;
    }

    _scanQRCode(context);
  }


  void _scanQRCode(BuildContext context) async {
    try {
      String? qrCode = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScanScreen(),
        ),
      );

      if (qrCode != null) {
        _processAbsen(qrCode);
      } else {
        // Tindakan untuk QR Code null
        _showManualSubmitOptions(); // Panggil fungsi ini langsung
      }
    } catch (e) {
      _showAlertDialog(
        'Kesalahan',
        'Terjadi kesalahan selama pemindaian kode QR.',
      );
    }
  }

  void _showManualSubmitOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('SCAN QR GAGAL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Memastikan tombol memenuhi lebar layar
            children: [
              const SizedBox(height: 10.0),
              const Text(
                'Untuk Melanjutkan Absen, Silahkan Klik Tombol Yang Tersedia',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              // Tombol untuk setiap karyawan manualSubmitOptions
              ...manualSubmitOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _redirectToUrl(option['url']!);
                      Navigator.pop(context);
                    },
                    child: Text(' ${option['name']}'),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }



  void _processAbsen(String qrCode) async {
    Employee? employee = employees.firstWhereOrNull(
          (e) => e.qrCode == qrCode,
    );

    if (employee != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informasi Absen'),
            content: Column(
              children: [
                Text('Nama Karyawan: ${employee.name}'),
                Text('ID Karyawan: ${employee.id}'),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _redirectToUrl(qrCode);
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _delayedPop(context);
                },
                child: const Text('BATAL'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data karyawan tidak ditemukan.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _delayedPop(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  void _redirectToUrl(String qrCode) async {
    String dynamicUrl = qrCode;

    if (await canLaunchUrlString(dynamicUrl)) {
      await launchUrlString(dynamicUrl);
    } else {
      throw 'Tidak dapat membuka URL: $dynamicUrl';
    }
  }

  void _navigateToIzinPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IzinPage()),
    );
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _scanQRCode(context);
              },
              child: const Text('Scan'),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
