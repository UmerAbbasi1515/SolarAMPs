import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Solar Informatics, LLC (“Solar Informatics”) operates the website at https://solarinformatics.com (the "Site").  Terms such as “we,” “our” and “us” refer to Solar Informatics.   Solar Informatics values your privacy.  This Privacy Policy describes how we collect and handle information that we receive through our Site and all related and subsidiary webpages and through access to any optimized version of our Site via a wireless device.  Use of the Solar Informatics Platform and mobile application are governed by the terms and privacy policy available within the platform.\nBy accessing and using the Site, you consent to the collection, use, and storage of your information by us in the manner described in this Privacy Policy.  We reserve the right to change and update this Privacy Policy and such updated versions will be posted on the Site. In addition to this Privacy Policy, your use of our Site is governed by our Terms of Service.\nHow We Collect and Use Information\nHow We Collect and Use Information\nWe may collect personally identifiable information (“PII”) such as your name and contact information if you choose to provide it to us.  For example, you may choose to submit questions or comments by completing and submitting a Contact Us form and providing your name, e-mail and/or address. Solar Informatics maintains and uses the PII you provide in order to fulfill your requests and respond to inquiries and comments, to analyze and improve our services and to conduct marketing. Solar Informatics will not sell or rent any PII collected on this Site to third parties for their direct marketing or other purposes.\nWe may disclose your PII to third party vendors engaged by Solar Informatics to help manage our Site, provide advertising and marketing services, provide services or fulfill orders, process payments or fulfill other requests.  For example, if you purchase products or services through our website, our third party payment processors will receive credit card information as may be further described in any referenced policies of such third party processors.  In general, we require our third party service providers and vendors to restrict their use of such PII received through our Site to the intended purposes.  Notwithstanding anything the foregoing, Solar Informatics may disclose PII to comply with any legal obligation, to enforce or apply our Terms of Use or to protect our rights or those of other parties.  In addition, we may need to, and we reserve the right to, disclose or transfer any PII to third parties in connection with selling or liquidating any part of our business or assets.\nNon-Personal Information\nThe Site collects certain standard internet log information that you do not visibly enter, such as your IP address, browser type, click stream data, HTTP protocol elements, and the status of cookies placed on your computer by Solar Informatics.  In addition, in order to manage and improve our Site, we or our service providers may use cookies (small packets of information that are stored by your web browser) or web beacons (electronic images that allow us to count visitors who have accessed a webpage).  These tools do not identify you personally and allow us to track and analyze aggregated usage data about our Site and its use.   Our Site may also use third party analytics vendors and we and our third party vendors or partners use analytics data for a variety of purposes such as to improve the design and content of our Site and understand what users like to see.\nYou may choose to block or disable cookies from your device using your browser settings or options.  However, this may impact your user experience and parts of the Site may not work for you.  You cannot remove or block web beacons as they form part of the content of the web pages, however because they work in conjunction with cookies, turning off cookies will prevent web beacons from tracking your user activity on our site.  The beacon can still account for an anonymous visit, but your unique information will not be recorded.\nAll non-personal information collected through this Site may be used and shared by us without any restriction.\nDo Not Track Disclosure.  This Site does not monitor for or behave differently if your computer transmits a “do not track” or similar beacon or message.\nYour Choices; Updating your Information\nIf you do not want us to collect PII from you, you should not submit such information to us.  If you opt-in to receive updates and information from us by completing a form or submitting a request, we may send you e-mails about a variety of topics, products, promotional offers and company information.  In such cases, the contact information you provide to us may be shared externally to enable third party agents to send e-mails to you on our behalf, or may be shared in anonymous, aggregated form for generalized user analysis.\nAt any time, you may choose to unsubscribe from such mailing lists. To do so, please either follow the links or instructions on the bottom of such communication or e-mail or send us a message through the Contact Us form with your full name and e-mail and a request to unsubscribe.\nAt any time, you may request changes to the PII that you have previously provided to us by contacting us by phone or through the Contact Us form.\nSecurity\n',
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: GoogleFonts.notoSans().fontFamily),
          ),
        ),
      ),
    );
  }
}
