import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quranschool/core/db_links/db_links.dart';
import 'package:quranschool/pages/common_widget/simple_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simplAppbar(true, "Contactus".tr),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Got a question or need assistance? Reach out to us via your preferred method below. Whether it's through social media, a phone call, or WhatsApp, our team is here to help you!"),
            ),
            // Facebook button
            ElevatedButton.icon(
              onPressed: () {
                _launchUrl(facebookUrl);
              },
              icon: Icon(
                FontAwesomeIcons.facebook,
              ),
              label: Text('Connect on Facebook'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4267B2), // Facebook's primary color
              ),
            ),
            SizedBox(height: 20),
            // Phone number button
            ElevatedButton.icon(
              onPressed: () {
                _launchUrl('tel:' + phoneNumber);
              },
              icon: Icon(Icons.phone),
              label: Text('Call Us'),
            ),
            SizedBox(height: 20),
            // WhatsApp button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF25D366), // WhatsApp's primary color
              ),
              onPressed: () {
                _launchUrl('https://wa.me/' + phoneNumber);
              },
              icon: Icon(
                FontAwesomeIcons.whatsapp,
              ),
              label: Text('WhatsApp Us'),
            ),
          ],
        ),
      ),
    );
  }

  // // Function to launch URLs
  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}
