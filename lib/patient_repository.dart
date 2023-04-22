import 'dart:convert';
import 'package:http/http.dart' as http;

class PatientRepository
{
  final dummyList =
  [
    [
      {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', '__v': 0},
      {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', '__v': 0},
      {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', '__v': 0},
      {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', '__v': 0},
      {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', '__v': 0},
      {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', '__v': 0},
      {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', '__v': 0},
      {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', '__v': 0},
      {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', '__v': 0},
      {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', '__v': 0},
      {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', '__v': 0},
      {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', '__v': 0},
      {'_id': '6437ad4ea478f6654a5da5a0', 'name': 'Ujjwal Singh', 'contact': '7900047968', 'illness': 'Fever', 'prescription': 'Paracetamol', 'period': '3 days', 'DOA': '2023-04-13T00:00:00.000Z', '__v': 0},
      {'_id': '6437c3a44b929692afdac123', 'name': 'Hitt Bahal', 'contact': '3516975236', 'illness': 'Stomach ache', 'prescription': 'Zenflox Oz', 'period': '2 days', 'DOA': '2020-05-16T00:00:00.000Z', '__v': 0},
      {'_id': '6437c43f4b929692afdac12d', 'name': 'Swetha Balamurugan', 'contact': '9527611240', 'illness': 'Cold and Cough', 'prescription': 'Cetzine', 'period': '4 days', 'DOA': '2019-11-14T00:00:00.000Z', '__v': 0}
    ],
    [
      {'_id': '6437ad4ea478f6654a5da59e', 'name': 'Ujjwal Singh', 'contact': 7900047968, 'age': 19, 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437c3a44b929692afdac125', 'name': 'Hitt Bahal', 'contact': 3516975236, 'age': 19, 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 150, '__v': 0},
      {'_id': '6437c43f4b929692afdac12b', 'name': 'Swetha Balamurugan', 'contact': 9527611240, 'age': 21, 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437ad4ea478f6654a5da59e', 'name': 'Ujjwal Singh', 'contact': 7900047968, 'age': 19, 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437c3a44b929692afdac125', 'name': 'Hitt Bahal', 'contact': 3516975236, 'age': 19, 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 150, '__v': 0},
      {'_id': '6437c43f4b929692afdac12b', 'name': 'Swetha Balamurugan', 'contact': 9527611240, 'age': 21, 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437ad4ea478f6654a5da59e', 'name': 'Ujjwal Singh', 'contact': 7900047968, 'age': 19, 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437c3a44b929692afdac125', 'name': 'Hitt Bahal', 'contact': 3516975236, 'age': 19, 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 150, '__v': 0},
      {'_id': '6437c43f4b929692afdac12b', 'name': 'Swetha Balamurugan', 'contact': 9527611240, 'age': 21, 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437ad4ea478f6654a5da59e', 'name': 'Ujjwal Singh', 'contact': 7900047968, 'age': 19, 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437c3a44b929692afdac125', 'name': 'Hitt Bahal', 'contact': 3516975236, 'age': 19, 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 150, '__v': 0},
      {'_id': '6437c43f4b929692afdac12b', 'name': 'Swetha Balamurugan', 'contact': 9527611240, 'age': 21, 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437ad4ea478f6654a5da59e', 'name': 'Ujjwal Singh', 'contact': 7900047968, 'age': 19, 'DOA': '2023-04-13T00:00:00.000Z', 'fee': 100, '__v': 0},
      {'_id': '6437c3a44b929692afdac125', 'name': 'Hitt Bahal', 'contact': 3516975236, 'age': 19, 'DOA': '2020-05-16T00:00:00.000Z', 'fee': 150, '__v': 0},
      {'_id': '6437c43f4b929692afdac12b', 'name': 'Swetha Balamurugan', 'contact': 9527611240, 'age': 21, 'DOA': '2019-11-14T00:00:00.000Z', 'fee': 100, '__v': 0}
    ]
  ];

  final dummyList2 =
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
      'illness': 'Cold and cough',
      'prescription': 'Paracetamol, MacBerry',
      'fee': 200,
      'DOA': '2023-04-02'
    },
    {
      'illness': 'Stomach infection',
      'prescription': 'Cetrizin, Azithromicen',
      'fee': 200,
      'DOA': '2023-03-15'
    },
    {
      'illness': 'Cold and cough',
      'prescription': 'Paracetamol, MacBerry',
      'fee': 200,
      'DOA': '2023-02-24'
    },
    {
      'illness': 'Diarrhea',
      'prescription': 'Ondem, Azithromicen',
      'fee': 200,
      'DOA': '2023-04-02'
    }
  ];

  final baseUrl = '10.100.158.104:3000';
  // final baseUrl = '192.168.1.76:3000';

  final client = http.Client();

  Future<List> getRecentPatientList(String date) async
  {
    // final uri = Uri.http(baseUrl, '/searchByDate');
    //
    // var regBody =
    // {
    //   "date": date,
    // };
    //
    // final response = await client.post
    //   (
    //     uri,
    //     headers: {"Content-Type":"application/json"},
    //     body: jsonEncode(regBody)
    // );
    //
    // final json = jsonDecode(response.body);
    // return json;

    return dummyList;
  }

  Future<List> getAllPatientList() async
  {
    // final uri = Uri.http(baseUrl, '/fetchInfo');
    // final response = await client.get(uri);
    // final json = jsonDecode(response.body);
    // // print(json);
    // return json;

    return dummyList;
  }

  Future<void> updatePatient(Map patient) async
  {
    final url = Uri.http(baseUrl, '/update');
    final response = await client.post
      (
        url,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(patient)
    );

    // print(response);
  }

  Future<List> getPatientHistory(String name, String contact) async
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
    // // print(json);
    // return json;

    return dummyList2;
  }

  Future<List> searchPatient(String name) async
  {
    var regBody =
    {
      "name": name,
    };

    final uri = Uri.http(baseUrl, '/getPatients');
    final response = await client.post
      (
        uri,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );
    final json = jsonDecode(response.body);
    // print(json);
    return json;
  }

  Future<void> addPatient(Map patient) async
  {
    final url = Uri.http(baseUrl, '/register');
    final response = await client.post
      (
        url,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(patient)
    );

    // print(response);
  }
}