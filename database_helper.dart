import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee.dart';

class DatabaseHelper {
  late Database _db;

  Future<void> open() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'employees_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id INTEGER PRIMARY KEY, name TEXT, qrCode TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertEmployee(Employee employee) async {
    await _db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> getEmployees() async {
    final List<Map<String, dynamic>> maps = await _db.query('employees');

    return List.generate(maps.length, (i) {
      return Employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        qrCode: maps[i]['qrCode'],
      );
    });
  }

  Future<void> insertInitialData() async {
    await _db.transaction((txn) async {
      Batch batch = txn.batch();


      batch.insert('employees', {'name': 'Rosa Melita Sari', 'qrCode': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Rosa+Melita+Sari&entry.2146958867=H'});
      batch.insert('employees', {'name': 'Novenilinda Wulan', 'qrCode': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Novenilinda+Wulan&entry.2146958867=H'});
      batch.insert('employees', {'name': 'Dandy Frasetya', 'qrCode': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Dandy+Frasetya&entry.2146958867=H'});
      batch.insert('employees', {'name': 'Dewani Niken', 'qrCode': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=Dewani+Niken&entry.2146958867=H'});
      batch.insert('employees', {'name': 'tes sistem', 'qrCode': 'https://docs.google.com/forms/d/e/1FAIpQLScB3HRJRM5kKOVEhtv5_Z7hZfo6_SfogsaNRCkZIR4_4ecNdA/formResponse?usp=pp_url&entry.181292323=tes+sistem&entry.2146958867=H'});




      await batch.commit();
    });
  }

}