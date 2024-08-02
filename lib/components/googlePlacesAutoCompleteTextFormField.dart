import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/properties.dart';

Widget googlePlacesAutoCompleteTextFormField({
  Function()? function,
  @required String? hintText,
  String? labelText,
  String? validateMsg,
  IconData? icon,
  IconData? prefixIcon,
  Color iconColor = BColors.black,
  Color prefixIconColor = BColors.black,
  Color? cursorColor,
  Color textColor = BColors.black,
  Color labelColor = BColors.assDeep,
  Color backgroundColor = BColors.white,
  required TextEditingController controller,
  bool validate = true,
  bool suggestion = false,
  TextInputType inputType = TextInputType.text,
  int? maxLine = 1,
  int minLine = 1,
  bool validateEmail = false,
  double? width,
  enable = true,
  bool removeBorder = false,
  void Function()? onIconTap,
  TextInputAction? inputAction,
  void Function()? onEditingComplete,
  void Function(String text)? onTextChange,
  @required FocusNode? focusNode,
  bool readOnly = false,
  bool showBorderRound = true,
  Color borderColor = BColors.assDeep,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
  int? maxLength,
  double borderWidth = 1,
  double borderRadius = 10,
  bool isDense = false,
  double? iconSize,
  TextStyle hintTextStyle = const TextStyle(
    color: BColors.assDeep,
    fontSize: 13,
  ),
  EdgeInsets padding = EdgeInsets.zero,
  Color? containerColor,
  List<String>? countries = const ["gh"],
  required String googleAPIKey,
  required void Function(Prediction prediction) getPlaceDetailWithLatLng,
  void Function(Prediction)? itmClick,
}) {
  return Container(
    width: width,
    padding: padding,
    color: containerColor,
    child: GooglePlacesAutoCompleteTextFormField(
      googleAPIKey: googleAPIKey,
      debounceTime: 400,
      countries: countries,
      isLatLngRequired: true,
      onTap: function,
      getPlaceDetailWithLatLng: (Prediction prediction) =>
          getPlaceDetailWithLatLng(prediction),
      itmClick: itmClick != null
          ? (Prediction prediction) => itmClick(prediction)
          : null,
      readOnly: readOnly,
      enableInteractiveSelection: true,
      enabled: enable,
      enableSuggestions: suggestion,
      keyboardType: inputType,
      textEditingController: controller,
      minLines: minLine,
      maxLines: maxLine,
      maxLength: maxLength,
      focusNode: focusNode,
      autofocus: false,
      textInputAction: inputAction,
      cursorColor: cursorColor,
      textCapitalization:
          validateEmail ? TextCapitalization.none : textCapitalization,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      onEditingComplete: () {
        if (kDebugMode) {
          print(controller.text);
        }
        focusNode!.unfocus();
        // onEditingComplete();
      },
      onChanged: onTextChange == null ? null : (text) => onTextChange(text),
      decoration: InputDecoration(
        isDense: isDense,
        hintText: hintText,
        hintStyle: hintTextStyle,
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        filled: true,
        fillColor: backgroundColor,
        suffixIcon: icon == null
            ? null
            : IconButton(
                onPressed: onIconTap,
                icon: Icon(icon, color: iconColor, size: iconSize),
              ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: prefixIconColor),
        enabledBorder: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        disabledBorder: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        focusedBorder: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        border: removeBorder
            ? InputBorder.none
            : showBorderRound
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
      ),
      validator: (value) {
        RegExp regex = RegExp(Properties.emailValidatingPattern);
        if (value!.isEmpty && validate) {
          return validateMsg;
        } else if (validateEmail && !regex.hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      },
    ),
  );
}
