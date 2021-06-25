import 'package:flutter/material.dart';
import 'package:smartsocietyadvertisement/Common/constant.dart' as cnst;
import 'package:smartsocietyadvertisement/Component/TermsOfServiceComponent.dart' as tm;

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: cnst.appPrimaryMaterialColor,
          title: Text("Privacy Policy"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title(txt: "SECTION 1 - WHAT DO WE DO WITH YOUR INFORMATION?",),
                para(txt: "When you purchase something from our store, as part of the buying and selling process, we collect the personal information you give us such as your name, address and email address.\n\nWhen you browse our store, we also automatically receive your computer’s internet protocol (IP) address in order to provide us with information that helps us learn about your browser and operating system.\n\nEmail marketing (if applicable): With your permission, we may send you emails about our store, new products and other updates.",),

                title(txt: "SECTION 2 - CONSENT",),
                para(txt: "How do you get my consent?\n\nWhen you provide us with personal information to complete a transaction, verify your credit card, place an order, arrange for a delivery or return a purchase, we imply that you consent to our collecting it and using it for that specific reason only.\n\nIf we ask for your personal information for a secondary reason, like marketing, we will either ask you directly for your expressed consent, or provide you with an opportunity to say no.\n\n\nHow do I withdraw my consent?\n\nIf after you opt-in, you change your mind, you may withdraw your consent for us to contact you, for the continued collection, use or disclosure of your information, at anytime, by contacting us at info@myjini.in or mailing us at: 112, 3rd Floor, Someshwar Square, Vesu, Surat - 395 007, Gujarat, India",),

                title(txt: "SECTION 3 - DISCLOSURE",),
                para(txt: "We may disclose your personal information if we are required by law to do so or if you violate our Terms of Service.",),

                title(txt: "SECTION 4 - PAYMENT",),
                para(txt: "We use Razorpay for processing payments. We/Razorpay do not store your card data on their servers. The data is encrypted through the Payment Card Industry Data Security Standard (PCI-DSS) when processing payment. Your purchase transaction data is only used as long as is necessary to complete your purchase transaction. After that is complete, your purchase transaction information is not saved.\n\nOur payment gateway adheres to the standards set by PCI-DSS as managed by the PCI Security Standards Council, which is a joint effort of brands like Visa, MasterCard, American Express and Discover.\n\nPCI-DSS requirements help ensure the secure handling of credit card information by our store and its service providers.\n\nFor more insight, you may also want to read terms and conditions of razorpay on https://razorpay.com",),

                title(txt: "SECTION 5 - THIRD-PARTY SERVICES",),
                para(txt: "In general, the third-party providers used by us will only collect, use and disclose your information to the extent necessary to allow them to perform the services they provide to us.\n\nHowever, certain third-party service providers, such as payment gateways and other payment transaction processors, have their own privacy policies in respect to the information we are required to provide to them for your purchase-related transactions.\n\nFor these providers, we recommend that you read their privacy policies so you can understand the manner in which your personal information will be handled by these providers.\n\nIn particular, remember that certain providers may be located in or have facilities that are located a different jurisdiction than either you or us. So if you elect to proceed with a transaction that involves the services of a third-party service provider, then your information may become subject to the laws of the jurisdiction(s) in which that service provider or its facilities are located.\n\nOnce you leave our store’s website or are redirected to a third-party website or application, you are no longer governed by this Privacy Policy or our website’s Terms of Service.\n\nLinks\n\nWhen you click on links on our store, they may direct you away from our site. We are not responsible for the privacy practices of other sites and encourage you to read their privacy statements.",),

                title(txt: "SECTION 6 - SECURITY",),
                para(txt: "To protect your personal information, we take reasonable precautions and follow industry best practices to make sure it is not inappropriately lost, misused, accessed, disclosed, altered or destroyed.",),

                title(txt: "SECTION 7 - COOKIES",),
                para(txt: "We use cookies to maintain session of your user. It is not used to personally identify you on other websites.",),

                title(txt: "SECTION 8 - AGE OF CONSENT",),
                para(txt: "By using this site, you represent that you are at least the age of majority in your state or province of residence, or that you are the age of majority in your state or province of residence and you have given us your consent to allow any of your minor dependents to use this site.",),

                title(txt: "SECTION 9 - CHANGES TO THIS PRIVACY POLICY",),
                para(txt:"We reserve the right to modify this privacy policy at any time, so please review it frequently. Changes and clarifications will take effect immediately upon their posting on the website. If we make material changes to this policy, we will notify you here that it has been updated, so that you are aware of what information we collect, how we use it, and under what circumstances, if any, we use and/or disclose it.\n\nIf our store is acquired or merged with another company, your information may be transferred to the new owners so that we may continue to sell products to you."),

                title(txt: "QUESTIONS AND CONTACT INFORMATION",),
                para(txt: "If you would like to: access, correct, amend or delete any personal information we have about you, register a complaint, or simply want more information contact our Privacy Compliance Officer at info@myjini.in or by mail at 112, 3rd Floor, Someshwar Square, Vesu, Surat - 395 007, Gujarat, India\n\n[Re: Privacy Compliance Officer]\n\n[622 Manglam Electronic Market Jaipur Rajasthan India 302001]\n\n___",)
              ],
            ),
          ),
        ));
  }
}

class para extends StatelessWidget {
  para({this.txt});
  String txt;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${txt}",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class title extends StatelessWidget {
  String txt;
  title({this.txt});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          txt,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
