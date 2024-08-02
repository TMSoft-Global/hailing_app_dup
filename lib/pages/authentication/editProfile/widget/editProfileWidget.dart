import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/button.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/components/textField.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/strings.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget editProfileWidget({
  required BuildContext context,
  required TextEditingController? firstNameontroller,
  required TextEditingController? lastNameontroller,
  required TextEditingController? phoneController,
  required FocusNode? firstNameFocusNode,
  required FocusNode? lastNameFocusNode,
  required FocusNode? phoneFocusNode,
  required Function()? onEditProfile,
  required GlobalKey<FormState>? formKey,
  @required String? profilePic,
  @required bool? isLocalUpload,
  @required void Function()? onUploadProfilePicture,
}) {
  return SingleChildScrollView(
    child: Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Text("Profile Picture", style: Styles.h5Black),
          const SizedBox(height: 10),
          Center(
            child: circular(
              child: isLocalUpload!
                  ? Image.file(
                      File(profilePic!),
                      height: 160,
                      width: 160,
                      fit: BoxFit.fitWidth,
                    )
                  : cachedImage(
                      context: context,
                      image: profilePic,
                      height: 160,
                      width: 160,
                      placeholder: Images.defaultProfilePicOffline,
                      fit: BoxFit.fitWidth,
                    ),
              size: 160,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: button(
              onPressed: onUploadProfilePicture,
              text: 'Upload',
              color: BColors.white,
              context: context,
              useWidth: false,
              textColor: BColors.black,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                textFormField(
                  hintText: '',
                  controller: firstNameontroller,
                  focusNode: firstNameFocusNode,
                  labelText: 'First Name',
                  validate: true,
                  validateMsg: Strings.requestField,
                ),
                const SizedBox(height: 10),
                textFormField(
                  hintText: '',
                  controller: lastNameontroller,
                  focusNode: lastNameFocusNode,
                  labelText: 'Last Name',
                  validate: true,
                  validateMsg: Strings.requestField,
                ),
                const SizedBox(height: 10),
                textFormField(
                  hintText: '',
                  controller: phoneController,
                  focusNode: phoneFocusNode,
                  validate: false,
                  labelText: 'Phone Number',
                ),
                const SizedBox(height: 20),
                button(
                  onPressed: onEditProfile,
                  text: 'Update',
                  color: BColors.primaryColor,
                  context: context,
                  divideWidth: .8,
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
