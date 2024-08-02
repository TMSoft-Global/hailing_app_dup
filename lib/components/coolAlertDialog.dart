import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import '../spec/colors.dart';

void coolAlertDialog({
  @required BuildContext? context,
  CoolAlertType type = CoolAlertType.info,
  @required String? text,
  String confirmBtnText = "Ok",
  String cancelBtnText = "Cancel",
  @required void Function()? onConfirmBtnTap,
  void Function()? onCancelBtnTap,
  bool barrierDismissible = true,
  bool showCancelBtn = false,
  bool closeOnConfirmBtnTap = true,
  Color? confirmBtnColor,
  Color? backgroundColor,
  TextStyle? confirmBtnTextStyle,
  TextStyle? cancelBtnTextStyle,
}) {
  CoolAlert.show(
    context: context!,
    type: type,
    backgroundColor: backgroundColor ?? BColors.primaryColor,
    text: text,
    confirmBtnText: confirmBtnText,
    cancelBtnText: cancelBtnText,
    confirmBtnColor: confirmBtnColor ?? BColors.primaryColor,
    onConfirmBtnTap: onConfirmBtnTap,
    onCancelBtnTap: onCancelBtnTap,
    loopAnimation: true,
    barrierDismissible: barrierDismissible,
    showCancelBtn: showCancelBtn,
    closeOnConfirmBtnTap: closeOnConfirmBtnTap,
    confirmBtnTextStyle: confirmBtnTextStyle,
    cancelBtnTextStyle: cancelBtnTextStyle,
  );
}
