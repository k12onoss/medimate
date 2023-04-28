import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medimate/data/visits.dart';

class PatientRepository
{
  final dummyPatientList =
  [
    {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'age': 19, 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'age': 19, 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'age': 21, 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'age': 19, 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'age': 19, 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'age': 19, 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'age': 19, 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'age': 19, 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'age': 19, 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'age': 19, 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'age': 19, 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240','age': 19, 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'age': 19, 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'age': 19, 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 100, '__v': 0},
    {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'age': 19, 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0}
  ];

  final dummyPatientDetailsList =
  [
    {
      'name': 'Ujjwal Singh',
      'contact': '7900047968',
      'illness': 'Cold and cough',
      'prescription': 'Paracetamol, MacBerry, Ondem, Azithromicen, Ondem, Azithromicen, Ondem, Azithromicen, Ondem, Azithromicen',
      'fee': 200,
      'DOA': '2023-04-02'
    },
    {
      'name': 'Ujjwal Singh',
      'contact': '7900047968',
      'illness': 'Cold and cough',
      'prescription': 'Paracetamol, MacBerry',
      'fee': 200,
      'DOA': '2023-04-02'
    },
    {
      'name': 'Ujjwal Singh',
      'contact': '7900047968',
      'illness': 'Stomach infection',
      'prescription': 'Cetrizin, Azithromicen',
      'fee': 200,
      'DOA': '2023-03-15'
    },
    {
      'name': 'Ujjwal Singh',
      'contact': '7900047968',
      'illness': 'Cold and cough',
      'prescription': 'Paracetamol, MacBerry',
      'fee': 200,
      'DOA': '2023-02-24'
    },
    {
      'name': 'Ujjwal Singh',
      'contact': '7900047968',
      'illness': 'Diarrhea',
      'prescription': 'Ondem, Azithromicen',
      'fee': 200,
      'DOA': '2023-04-02'
    }
  ];

  final baseUrl = '10.100.158.104:3000';
  // final baseUrl = '192.168.1.76:3000';

  final client = http.Client();

  Future<List<Visits>> getRecentPatientList(String date) async
  {
    // final uri = Uri.http(baseUrl, '/searchByDate');
    //
    // final response = await client.post
    //   (
    //   uri,
    //   headers: {"Content-Type":"application/json"},
    //   body: jsonEncode({"date": date})
    // );
    //
    // final json = jsonDecode(response.body);
    //
    // return List.generate
    //   (
    //   json.length,
    //   (index) => Visits
    //     (
    //     json[index]['name'],
    //     json[index]['contact'],
    //     json[index]['age'],
    //     json[index]['illness'],
    //     json[index]['prescription'],
    //     json[index]['period'],
    //     json[index]['DOA'],
    //     json[index]['fee']
    //   )
    // );

    return List.generate
      (
      dummyPatientList.length,
      (index) => Visits
        (
        dummyPatientList[index]['name'].toString(),
        dummyPatientList[index]['contact'].toString(),
        int.parse(dummyPatientList[index]['age'].toString()),
        dummyPatientList[index]['illness'].toString(),
        dummyPatientList[index]['prescription'].toString(),
        dummyPatientList[index]['period'].toString(),
        dummyPatientList[index]['DOA'].toString(),
        int.parse(dummyPatientList[index]['fee'].toString())
      )
    );
  }

  Future<List<Visits>> getAllPatientList() async
  {
    // final uri = Uri.http(baseUrl, '/fetchInfo');
    // final response = await client.get(uri);
    // final json = jsonDecode(response.body);
    // return List.generate
    //   (
    //   json.length,
    //   (index) => Visits
    //     (
    //     json[index]['name'],
    //     json[index]['contact'],
    //     json[index]['age'],
    //     json[index]['illness'],
    //     json[index]['prescription'],
    //     json[index]['period'],
    //     json[index]['DOA'],
    //     json[index]['fee']
    //   )
    // );

    return List.generate
      (
      dummyPatientList.length,
      (index) => Visits
        (
        dummyPatientList[index]['name'].toString(),
        dummyPatientList[index]['contact'].toString(),
        int.parse(dummyPatientList[index]['age'].toString()),
        dummyPatientList[index]['illness'].toString(),
        dummyPatientList[index]['prescription'].toString(),
        dummyPatientList[index]['period'].toString(),
        dummyPatientList[index]['DOA'].toString(),
        int.parse(dummyPatientList[index]['fee'].toString())
      )
    );
  }

  Future<void> updatePatient(Map visit) async
  {
    // final url = Uri.http(baseUrl, '/update');
    // await client.post
    //   (
    //   url,
    //   headers: {"Content-Type":"application/json"},
    //   body: jsonEncode(visit)
    // );
  }

  Future<List<Visits>> getPatientHistory(String name, String contact) async
  {
    // var regBody =
    // {
    //   "name": name,
    //   "contact": contact
    // };
    //
    // final uri = Uri.http(baseUrl, '/getPres');
    // final response = await client.post
    //   (
    //   uri,
    //   headers: {"Content-Type":"application/json"},
    //   body: jsonEncode(regBody)
    // );
    // final json = jsonDecode(response.body);
    // return List.generate
    //   (
    //   json.length,
    //   (index) => Visits
    //     (
    //     json[index]['name'],
    //     json[index]['contact'],
    //     json[index]['age'],
    //     json[index]['illness'],
    //     json[index]['prescription'],
    //     json[index]['period'],
    //     json[index]['DOA'],
    //     json[index]['fee']
    //   )
    // );

    return List.generate
      (
      dummyPatientDetailsList.length,
      (index) => Visits
        (
        dummyPatientDetailsList[index]['name'].toString(),
        dummyPatientDetailsList[index]['contact'].toString(),
        0,
        dummyPatientDetailsList[index]['illness'].toString(),
        dummyPatientDetailsList[index]['prescription'].toString(),
        '',
        dummyPatientDetailsList[index]['DOA'].toString(),
        int.parse(dummyPatientDetailsList[index]['fee'].toString())
      )
    );
  }

  Future<List<Visits>> searchPatient(String name) async
  {
    final uri = Uri.http(baseUrl, '/getPatients');
    final response = await client.post
      (
        uri,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({"name": name})
    );
    final json = jsonDecode(response.body);
    return List.generate
      (
      json.length,
      (index) => Visits
        (
        json[index]['name'],
        json[index]['contact'],
        json[index]['age'],
        json[index]['illness'],
        json[index]['prescription'],
        json[index]['period'],
        json[index]['DOA'],
        json[index]['fee']
      )
    );
  }

  Future<void> addPatient(Map visitDetails) async
  {
    // final url = Uri.http(baseUrl, '/register');
    // await client.post
    //   (
    //   url,
    //   headers: {"Content-Type":"application/json"},
    //   body: jsonEncode(visitDetails)
    // );
  }
}