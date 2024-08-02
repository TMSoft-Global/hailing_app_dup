import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/coolAlertDialog.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/config/auth/googleService.dart';
import 'package:pickme_mobile/config/deleteCache.dart';
import 'package:pickme_mobile/config/firebase/firebaseAuth.dart';
import 'package:pickme_mobile/config/http/httpActions.dart';
import 'package:pickme_mobile/config/http/httpChecker.dart';
import 'package:pickme_mobile/config/http/httpRequester.dart';
import 'package:pickme_mobile/config/http/httpServices.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/config/sharePreference.dart';
import 'package:pickme_mobile/pages/modules/others/accountSettings/widget/accountSettingsWidget.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final FireAuth _fireAuth = new FireAuth();
  final GoogleService _googleService = new GoogleService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: BColors.white),
        backgroundColor: BColors.primaryColor,
        title: Text("Settings", style: Styles.h4WhiteBold),
      ),
      body: Stack(
        children: [
          accountSettingsWidget(
            context: context,
            onEdit: () {},
            onResetPassword: () => navigation(
              context: context,
              pageName: 'resetpasswordloggedin',
            ),
            onSetPaymentPincode: () {},
            onRate: () {},
            onFeedback: () {},
            onTerms: () {},
            onLogout: () => _onLogoutDialog(),
            onDeleteAccount: () => navigation(
              context: context,
              pageName: 'deleteAccount',
            ),
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  void _onLogoutDialog() {
    coolAlertDialog(
      context: context,
      text: 'Do you want to logout',
      onConfirmBtnTap: () async {
        navigation(context: context, pageName: "back");
        _onLogout();
      },
      confirmBtnText: "Logout",
      closeOnConfirmBtnTap: false,
    );
  }

  Future<void> _onLogout() async {
    setState(() => _isLoading = true);
    await httpChecker(
      httpRequesting: () => httpRequesting(
        endPoint: HttpServices.auth,
        method: HttpMethod.post,
        httpPostBody: {
          "action": HttpActions.logout,
        },
      ),
      showToastMsg: false,
    );
    await deleteCache();
    await _fireAuth.signOut();
    await _googleService.googleSignOut();
    saveBoolShare(key: 'auth', data: false);
    setState(() => _isLoading = false);
    if (!mounted) return;
    navigation(context: context, pageName: 'login');
  }
}
