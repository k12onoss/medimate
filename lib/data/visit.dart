import 'package:isar/isar.dart';

part 'visit.g.dart';

@collection
class Visit {
  Id? id;
  String name;
  String contact;
  int age;
  String gender;
  String? symptom;
  String? medicine;
  String? prescription;
  String? advice;
  String? period;
  String doa;
  int fee;

  Visit({
    this.id,
    required this.name,
    required this.contact,
    required this.age,
    required this.gender,
    this.symptom,
    this.medicine,
    this.prescription,
    this.advice,
    this.period,
    required this.doa,
    required this.fee,
  });

  factory Visit.fromMap(Map visit) {
    return Visit(
      id: int.tryParse(visit['id'].toString()) ?? Isar.autoIncrement,
      name: visit['name'].toString(),
      contact: visit['contact'].toString(),
      age: int.parse(visit['age'].toString()),
      gender: visit['gender'].toString(),
      symptom: visit['symptom']?.toString(),
      medicine: visit['medicine']?.toString(),
      prescription: visit['prescription']?.toString(),
      advice: visit['advice']?.toString(),
      period: visit['period']?.toString(),
      doa: visit['doa'].toString(),
      fee: int.parse(visit['fee'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'age': age,
      'gender': gender,
      'symptom': symptom,
      'medicine': medicine,
      'prescription': prescription,
      'advice': advice,
      'period': period,
      'doa': doa,
      'fee': fee,
    };
  }
}
