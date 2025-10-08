
import 'package:address/Service/Address_service.dart';
import 'package:address/model/address_model.dart';
import 'package:address/model/country_model.dart';
import 'package:address/model/district_model.dart';
import 'package:address/model/division_model.dart';
import 'package:address/model/police_station_model.dart';
import 'package:flutter/material.dart';


class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {

  final AddressService addressService = AddressService();

  List<Country> countries = [];
  List<Division> divisions = [];
  List<District> districts = [];
  List<PoliceStation> policeStations = [];

  Country? selectedCountry;
  Division? selectedDivision;
  District? selectedDistrict;
  PoliceStation? selectedPoliceStation;

  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> loadCountries() async {
    countries = await addressService.getCountries();
    print(countries.toString());
    setState(() {});
  }

  Future<void> loadDivisions(int countryId) async {
    divisions = await addressService.getDivisionsByCountry(countryId);
    setState(() {
      selectedDivision = null;
      selectedDistrict = null;
      selectedPoliceStation = null;
      districts.clear();
      policeStations.clear();
    });
  }

  Future<void> loadDistricts(int divisionId) async {
    districts = await addressService.getDistrictsByDivision(divisionId);

    print(districts.toString());
    setState(() {
      selectedDistrict = null;
      selectedPoliceStation = null;
      policeStations.clear();
    });
  }

  Future<void> loadPoliceStations(int districtId) async {
    policeStations = await addressService.getPoliceStationsByDistrict(districtId);

    print(policeStations.toString());
    setState(() {
      selectedPoliceStation = null;
    });
  }

  Future<void> saveAddress() async {
    if (selectedCountry == null ||
        selectedDivision == null ||
        selectedDistrict == null ||
        selectedPoliceStation == null ||
        _line1Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all required fields properly')));
      return;
    }

    final address = Address(
      addressLine1: _line1Controller.text,
      addressLine2: _line2Controller.text,
      countryId: selectedCountry!.id,
      divisionId: selectedDivision!.id,
      districtId: selectedDistrict!.id,
      policeStationId: selectedPoliceStation!.id,
    );

    bool success = await addressService.addAddress(address);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'Address Saved Successfully' : 'Failed to Save'),
      backgroundColor: success ? Colors.green : Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Address")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<Country>(
              value: selectedCountry,
              decoration: const InputDecoration(labelText: 'Country'),
              items: countries.map((c) {
                return DropdownMenuItem(value: c, child: Text(c.name));
              }).toList(),
              onChanged: (val) {
                setState(() => selectedCountry = val);
                if (val != null) loadDivisions(val.id);
              },
            ),
            DropdownButtonFormField<Division>(
              value: selectedDivision,
              decoration: const InputDecoration(labelText: 'Division'),
              items: divisions.map((d) {
                return DropdownMenuItem(value: d, child: Text(d.name));
              }).toList(),
              onChanged: (val) {
                setState(() => selectedDivision = val);
                if (val != null) loadDistricts(val.id);
              },
            ),
            DropdownButtonFormField<District>(
              value: selectedDistrict,
              decoration: const InputDecoration(labelText: 'District'),
              items: districts.map((d) {
                return DropdownMenuItem(value: d, child: Text(d.name));
              }).toList(),
              onChanged: (val) {
                setState(() => selectedDistrict = val);
                if (val != null) loadPoliceStations(val.id);
              },
            ),
            DropdownButtonFormField<PoliceStation>(
              value: selectedPoliceStation,
              decoration: const InputDecoration(labelText: 'Police Station'),
              items: policeStations.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.name));
              }).toList(),
              onChanged: (val) {
                setState(() => selectedPoliceStation = val);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _line1Controller,
              decoration: const InputDecoration(labelText: 'Address Line 1'),
            ),
            TextField(
              controller: _line2Controller,
              decoration: const InputDecoration(labelText: 'Address Line 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveAddress,
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}

