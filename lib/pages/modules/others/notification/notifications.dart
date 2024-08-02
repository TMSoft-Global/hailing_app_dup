import 'package:flutter/material.dart';
import 'package:pickme_mobile/pages/modules/others/notification/widget/notificationsWidget.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: BColors.white),
        backgroundColor: BColors.primaryColor,
        title: Text("Notification", style: Styles.h4WhiteBold),
      ),
      body: notificationsWidget(
        context: context,
        onMarkAsRead: () {},
      ),
    );
  }
}
