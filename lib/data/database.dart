import 'package:isar/isar.dart';
import 'package:medimate/data/visit.dart';

class Database {
  final _isar = Isar.getInstance('visits')!.visits;

  Future<List<Visit>> getRecentVisits(String date) async {
    return _isar.filter().doaEqualTo(date).findAll();
  }

  Future<List<Visit>> getAllPatients() async {
    return _isar
        .where()
        .distinctByName(caseSensitive: false)
        .distinctByContact()
        .findAll();
  }

  Future<List<Visit>> getPatientHistory(String name, String contact) async {
    return _isar
        .filter()
        .nameEqualTo(name)
        .and()
        .contactEqualTo(contact)
        .findAll();
  }

  Future<List<Visit>> searchPatient(String name) async {
    return _isar.filter().nameContains(name, caseSensitive: false).findAll();
  }

  Future<void> updateVisit(Visit visit) async {
    final isar = Isar.getInstance('visits');
    await isar?.writeTxn(() async {
      await _isar.put(visit);
    });
  }
}
