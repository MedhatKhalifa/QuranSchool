// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:country_picker/country_picker.dart';
// import 'package:city_picker/city_picker.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Country _selectedCountry;
//   City _selectedCity;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Country and City Picker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Country: ${_selectedCountry?.name ?? 'Select a Country'}'),
//             ElevatedButton(
//               onPressed: _selectCountry,
//               child: Text('Select Country'),
//             ),
//             SizedBox(height: 20),
//             Text('City: ${_selectedCity?.name ?? 'Select a City'}'),
//             ElevatedButton(
//               onPressed: _selectCity,
//               child: Text('Select City'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _selectCountry() {
//     showCountryPicker(
//       context: context,
//       showPhoneCode: false,
//       onSelect: (Country country) {
//         setState(() {
//           _selectedCountry = country;
//           _selectedCity = null; // Reset city when country changes
//         });
//       },
//     );
//   }

//   void _selectCity() {
//     if (_selectedCountry == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a country first!')),
//       );
//       return;
//     }

//     showCityPicker(
//       context: context,
//       defaultCountryCode: _selectedCountry.countryCode,
//       onSelect: (City city) {
//         setState(() {
//           _selectedCity = city;
//         });
//       },
//     );
//   }
// }
