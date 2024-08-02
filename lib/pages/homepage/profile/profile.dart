import 'package:flutter/material.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/config/sharePreference.dart';
import 'package:pickme_mobile/pages/homepage/profile/widget/profileWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final VoidCallback onWallet;
  final VoidCallback onMyBookings;
  const Profile({
    super.key,
    required this.onMyBookings,
    required this.onWallet,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isWorkerMode = false;

  @override
  void initState() {
    super.initState();
    _getWorkerStatus();
  }

  Future<void> _getWorkerStatus() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isWorker")) {
      _isWorkerMode = prefs.getBool("isWorker")!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: profileWidget(
        context: context,
        onEditProfile: () {},
        onContactUs: () {},
        onWallet: widget.onWallet,
        onEmergency: () {},
        onVendors: () => navigation(context: context, pageName: "vendors"),
        onMyBookings: widget.onMyBookings,
        onBusinessProfile: () => navigation(
          context: context,
          pageName: "applicationstatus",
        ),
        onMyCart: () {},
        onNotifications: () => navigation(
          context: context,
          pageName: "notifications",
        ),
        onFavoriteSp: () {},
        onBecomeWorker: () => navigation(
          context: context,
          pageName: "driverregistration",
        ),
        isWorkerMode: _isWorkerMode,
        onWorkerMode: (bool value) => _onWorkerMode(value),
        onEnableFaceID: () {},
        onSettings: () => navigation(
          context: context,
          pageName: "accountsettings",
        ),
      ),
    );
  }

  Future<void> _onWorkerMode(bool value) async {
    _isWorkerMode = value;
    await saveBoolShare(key: "isWorker", data: value);
    setState(() {});
    if (!mounted) return;
    navigation(context: context, pageName: "homepage");
  }
}
