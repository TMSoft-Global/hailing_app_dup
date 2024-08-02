import 'package:flutter/material.dart';
import 'package:pickme_mobile/pages/modules/others/support/widget/supportWidget.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final _messageController = new TextEditingController();

  final _messageFocusNode = new FocusNode();
  final _searchFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: BColors.white),
        backgroundColor: BColors.primaryColor,
        title: Text("Support", style: Styles.h4WhiteBold),
      ),
      body: supportWidget(
        onSendMessage: () {},
        onSearch: (String text) {},
        messageController: _messageController,
        messageFocusNode: _messageFocusNode,
        searchFocusNode: _searchFocusNode,
        onCall: () {},
        onWhatsapp: () {},
        onEmail: () {},
      ),
    );
  }
}
