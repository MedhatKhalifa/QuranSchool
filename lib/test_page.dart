// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CountryCitySelectionPage extends GetView<CountryCitySelectionController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Country City Selection'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Country selection dropdown
//             Obx(() {
//               if (controller.countries.value.isNotEmpty) {
//                 return DropdownButton<CountryModel>(
//                   value: controller.selectedCountry.value,
//                   items: controller.countries.map((country) => DropdownMenuItem(
//                     value: country,
//                     child: Text(controller.getCurrentCountryName(country)),
//                   )).toList(),
//                   onChanged: (country) {
//                     controller.selectedCountry.value = country;
//                     controller.loadCities();
//                   },
//                 );
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             }),

//             // City selection dropdown
//             Obx(() {
//               if (controller.selectedCountry.value != null &&
//                   controller.cities.value.isNotEmpty) {
//                 return DropdownButton<CityModel>(
//                   value: controller.selectedCity.value,
//                   items: controller.cities.map((city) => DropdownMenuItem(
//                     value: city,
//                     child: Text(controller.getCurrentCityName(city)),
//                   )).toList(),
//                   onChanged: (city) => controller.selectedCity.value = city,
//                 );
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             }),

//             // Language selection buttons
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () => controller.switchLanguage('en'),
//                   child: Text('English'),
//                 ),
//                 const SizedBox(width: 16.0),
//                 ElevatedButton(
//                   onPressed: () => controller.switchLanguage('ar'),
//                   child: Text('Arabic'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
