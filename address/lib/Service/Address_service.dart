import 'dart:convert';
import 'package:address/model/address_model.dart';
import 'package:address/model/country_model.dart';
import 'package:address/model/district_model.dart';
import 'package:address/model/division_model.dart';
import 'package:address/model/police_station_model.dart';
import 'package:http/http.dart' as http;


class AddressService {

  static const String baseUrl = 'http://localhost:8085/api';


  Future<bool> addAddress(Address address) async {


    final response = await http.post(
      Uri.parse(baseUrl+'/addresses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(address.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      return false;
    }
  }



  Future<List<Country>> getCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/countries/'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Country.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries');
  }



  Future<List<Division>> getDivisionsByCountry(int countryId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/division/by-country/$countryId'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Division.fromJson(e)).toList();
    }
    throw Exception('Failed to load divisions');
  }

  Future<List<District>> getDistrictsByDivision(int divisionId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/district/by-division/$divisionId'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => District.fromJson(e)).toList();
    }
    throw Exception('Failed to load districts');
  }

  Future<List<PoliceStation>> getPoliceStationsByDistrict(int districtId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/policestation/by-district/$districtId'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => PoliceStation.fromJson(e)).toList();
    }
    throw Exception('Failed to load police stations');
  }
}
