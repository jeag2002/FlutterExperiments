import 'package:hackaton_project/model/adventure.dart';
import 'package:hackaton_project/properties/properties.dart';
import 'dart:core';
import 'package:emailjs/emailjs.dart';

class MailWeb {
  const MailWeb({required this.adventure});
  final Adventure adventure;

  Future<String> sendMailWeb(String mail) async {
    String msg = "";

    try {
      PropertyFile file = await PropertyFile().loadPropertyFileSync();

      String pubkey = file.getAttribute("emailjs-publickey");
      String privkey = file.getAttribute("emailjs-privatekey");

      String serviceid = file.getAttribute("emailjs-serviceid");
      String templateid = file.getAttribute("emailjs-templateid");

      Map<String, dynamic> templateParams = {
        'name': adventure.name,
        'story': mail
      };

      // ignore: prefer_const_constructors
      Options options = Options(publicKey: pubkey, privateKey: privkey);
      await EmailJS.send(serviceid, templateid, templateParams, options);

      msg = "Message sent!";
    } on Exception catch (e) {
      // ignore: avoid_print
      print('[MAIL] Message not sent. $e');
      msg = "(ERROR) Message not sent!";
    }
    return msg;
  }
}
