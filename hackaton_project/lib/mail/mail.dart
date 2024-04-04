// ignore_for_file: prefer_const_constructors

import 'package:mailer/mailer.dart';
import 'package:hackaton_project/model/adventure.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:hackaton_project/properties/properties.dart';
import 'dart:core';

//https://stackoverflow.com/questions/58731933/flutter-mailer-isnt-working-due-to-these-errors
//https://support.google.com/accounts/answer/6010255?hl=en
//https://www.youtube.com/watch?v=q6yu9iS5dks&ab_channel=FlutterWithUsama
//(password no es el mio, es otro)

class Mail {
  const Mail({required this.adventure});
  final Adventure adventure;

  void sendMail(String msg) async {
    // ignore: avoid_print
    print('[MAIL] send mail!');
    String name = adventure.name;
    PropertyFile file = await PropertyFile().loadPropertyFileSync();
    // ignore: avoid_print
    String username = file.getAttribute("username-email");
    String password = file.getAttribute("password-email");
    // ignore: avoid_print
    final smtpServer = gmail(username, password);
    // ignore: avoid_print
    final message = Message()
      ..from = Address(username, adventure.name)
      ..recipients.add('recipient-email@gmail.com')
      ..subject = 'your story $name'
      ..text = msg;
    try {
      final sendReport =
          await send(message, smtpServer, timeout: Duration(seconds: 5));
      // ignore: avoid_print
      print('[MAIL] Message sent: $sendReport');
    } on MailerException catch (e) {
      // ignore: avoid_print
      print('[MAIL] Message not sent. $e');
      for (var p in e.problems) {
        //ignore: avoid_print
        print('[MAIL] Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
