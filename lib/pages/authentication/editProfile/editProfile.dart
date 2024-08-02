import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/customLoading.dart';
import 'package:pickme_mobile/components/toast.dart';
import 'package:pickme_mobile/config/http/httpChecker.dart';
import 'package:pickme_mobile/config/http/httpFileUploader.dart';
import 'package:pickme_mobile/config/http/httpRequester.dart';
import 'package:pickme_mobile/config/sharePreference.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/utils/captureImage.dart';

import 'widget/editProfileWidget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _editFirstNameController =
      TextEditingController();
  final TextEditingController _editLastNameController = TextEditingController();
  final TextEditingController _editPhoneController = TextEditingController();

  bool _isLoading = false, _isLocalUpload = false;

  FocusNode? _editFirstNameFocusNode,
      _editLastNameFocusNode,
      _editOccupationFocusNode,
      _editPhoneFocusNode;

  String _profilePic = "";
  String _uploadedProfileUrl = "";

  @override
  void initState() {
    super.initState();
    // _editFirstNameController.text = userModel!.user!.firstname!.toTitleCase();
    // _editLastNameController.text = userModel!.user!.lastname!.toTitleCase();
    // _editPhoneController.text = userModel!.user!.phone ?? "";
    // _profilePic = userModel!.user!.img ?? "";

    _editFirstNameFocusNode = new FocusNode();
    _editLastNameFocusNode = new FocusNode();
    _editOccupationFocusNode = new FocusNode();
    _editPhoneFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _editFirstNameFocusNode!.dispose();
    _editLastNameFocusNode!.dispose();
    _editOccupationFocusNode!.dispose();
    _editPhoneFocusNode!.dispose();
  }

  void _onFocusAllNodes() {
    _editFirstNameFocusNode!.unfocus();
    _editLastNameFocusNode!.unfocus();
    _editOccupationFocusNode!.unfocus();
    _editPhoneFocusNode!.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          editProfileWidget(
            context: context,
            firstNameFocusNode: _editFirstNameFocusNode,
            firstNameontroller: _editFirstNameController,
            lastNameFocusNode: _editLastNameFocusNode,
            lastNameontroller: _editLastNameController,
            phoneController: _editPhoneController,
            phoneFocusNode: _editPhoneFocusNode,
            onEditProfile: () => _onComplete(),
            formKey: _formKey,
            isLocalUpload: _isLocalUpload,
            onUploadProfilePicture: () => _onUploadProfilePicture(),
            profilePic: _profilePic,
          ),
          if (_isLoading) customLoadingPage(),
        ],
      ),
    );
  }

  Future<void> _onComplete() async {
    setState(() => _isLoading = true);
    if (_isLocalUpload && _profilePic != "null" && _profilePic != "") {
      _uploadedProfileUrl = await httpFileUploader(
        imageList: _profilePic,
      );
      _onEditProfile();
    } else {
      _onEditProfile();
    }
  }

  void _onEditProfile() async {
    _onFocusAllNodes();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Map<String, dynamic> httpResult = await httpChecker(
        httpRequesting: () => httpRequesting(
          endPoint: '',
          method: HttpMethod.post,
          httpPostBody: {
            "fname": _editFirstNameController.text,
            "lname": _editLastNameController.text,
            "picture": _profilePic != "" && _profilePic != "null"
                ? _uploadedProfileUrl
                : "",
          },
        ),
      );
      if (httpResult['ok']) {
        _uploadedProfileUrl = "";
        await saveStringShare(
          key: "userDetails",
          data: jsonEncode(httpResult['data']),
        );
        // userModel = UserModel.fromJson(httpResult['data']);
        toastContainer(
          text: "${httpResult["data"]["msg"]}",
          backgroundColor: BColors.green,
        );

        setState(() => _isLoading = true);
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        setState(() => _isLoading = false);
        httpResult["statusCode"] == 200
            ? toastContainer(
                text: httpResult["data"]["msg"],
                backgroundColor: BColors.red,
              )
            : toastContainer(
                text: "${httpResult["error"]}",
                backgroundColor: BColors.red,
              );
      }
    }
  }

  Future<void> _onUploadProfilePicture() async {
    File imagePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ImageCapture(),
      ),
    );
    // ignore: unnecessary_null_comparison
    if (imagePath != null) {
      setState(() {
        _profilePic = imagePath.path;
        _isLocalUpload = true;
      });
    }
  }
}
