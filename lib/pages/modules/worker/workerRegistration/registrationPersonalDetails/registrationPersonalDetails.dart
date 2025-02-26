import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:pickme_mobile/config/navigation.dart';
import 'package:pickme_mobile/spec/arrays.dart';
import 'package:pickme_mobile/spec/theme.dart';
import 'package:pickme_mobile/utils/captureImage.dart';
import 'package:pickme_mobile/utils/faceCapturing.dart';

import '../registrationPersonalDetialsSummary/registrationPersonalDetialsSummary.dart';
import 'widget/registrationDocumentUploadWidget.dart';
import 'widget/registrationPersonalDetailsWidget.dart';
import 'widget/registrationPersonalWidget.dart';
import 'widget/registrationVehicleDetailsWidget.dart';

enum _DocType { license, ghanaCard, roadWorthy, insurance }

class RegistrationPersonalDetails extends StatefulWidget {
  const RegistrationPersonalDetails({super.key});

  @override
  State<RegistrationPersonalDetails> createState() =>
      _RegistrationPersonalDetailsState();
}

class _RegistrationPersonalDetailsState
    extends State<RegistrationPersonalDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = new TextEditingController();
  final _dobController = new TextEditingController();
  final _genderController = new TextEditingController();
  final _licenseController = new TextEditingController();
  final _expiryDateController = new TextEditingController();
  final _cardNoController = new TextEditingController();
  final _pickRollController = new TextEditingController();
  final _vehicletypeController = new TextEditingController();
  final _vehicleYearController = new TextEditingController();
  final _roadWorthyDateController = new TextEditingController();
  final _insuranceDateController = new TextEditingController();
  final _vehicleColorController = new TextEditingController();
  final _vehicleNumberController = new TextEditingController();
  final _vehicleModelController = new TextEditingController();
  final _vehicleMakeController = new TextEditingController();

  FocusNode? _nameFocusNode,
      _licenseFocusNode,
      _cardFocusNode,
      _pickRollFocusNode,
      _vehicleColorFocusNode,
      _vehicleNumberFocusNode,
      _vehicleModelFocusNode,
      _vehicleMakeFocusNode;

  int _currentStep = 1;
  String? _imagePath,
      _licenseImageFrontPath,
      _licenseImageBackPath,
      _ghanaCardFrontPath,
      _ghanaCardBackPath,
      _roadWorthyPath,
      _insurancePath;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = new FocusNode();
    _licenseFocusNode = new FocusNode();
    _cardFocusNode = new FocusNode();
    _pickRollFocusNode = new FocusNode();
    _vehicleColorFocusNode = new FocusNode();
    _vehicleNumberFocusNode = new FocusNode();
    _vehicleModelFocusNode = new FocusNode();
    _vehicleMakeFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode!.dispose();
    _licenseFocusNode!.dispose();
    _cardFocusNode!.dispose();
    _pickRollFocusNode!.dispose();
    _vehicleColorFocusNode!.dispose();
    _vehicleNumberFocusNode!.dispose();
    _vehicleModelFocusNode!.dispose();
    _vehicleMakeFocusNode!.dispose();
  }

  void _unFocusAllNodes() {
    _nameFocusNode!.unfocus();
    _licenseFocusNode!.unfocus();
    _cardFocusNode!.unfocus();
    _pickRollFocusNode!.unfocus();
    _vehicleColorFocusNode!.unfocus();
    _vehicleNumberFocusNode!.unfocus();
    _vehicleModelFocusNode!.unfocus();
    _vehicleMakeFocusNode!.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool invoke) {
        if (invoke) {
          return;
        }
        if (_currentStep != 1) {
          --_currentStep;
          setState(() {});
        } else {
          navigation(context: context, pageName: "back");
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: registrationPersonalWidget(
          currentStep: _currentStep,
          child: _currentStep == 1
              ? registrationPersonalDetailsWidget(
                  context: context,
                  onSnap: () => _onSnap(),
                  onDOB: () => _onDate(true),
                  onGender: () => _onGender(),
                  onNext: () => _onPersonalNext(),
                  key: _formKey,
                  nameController: _nameController,
                  dobController: _dobController,
                  genderController: _genderController,
                  nameFocusNode: _nameFocusNode!,
                  imagePath: _imagePath,
                )
              : _currentStep == 2
                  ? registrationDocumentUploadWidget(
                      context: context,
                      onExpiryDate: () => _onDate(false),
                      onNext: () => _onDocumentNext(),
                      key: _formKey,
                      licenseController: _licenseController,
                      expiryDateController: _expiryDateController,
                      cardNoController: _cardNoController,
                      licenseFocusNode: _licenseFocusNode!,
                      cardFocusNode: _cardFocusNode!,
                      licenseImageFrontPath: _licenseImageFrontPath,
                      onUploadLicense: (String side) => _onUploadDocument(
                        _DocType.license,
                        side,
                      ),
                      licenseImageBackPath: _licenseImageBackPath,
                      onUploadGhanaCard: (String side) => _onUploadDocument(
                        _DocType.ghanaCard,
                        side,
                      ),
                      ghanaCardFrontPath: _ghanaCardFrontPath,
                      ghanaCardBackPath: _ghanaCardBackPath,
                    )
                  : _currentStep == 3
                      ? registrationVehicleDetailsWidget(
                          context: context,
                          onRoadWorthyDate: () => _onDate(
                            false,
                            docType: _DocType.roadWorthy,
                          ),
                          onVehicleType: () => _onVehicleType(),
                          onVehicleYear: () => _onVehicleYear(),
                          onNext: () => _onVehicleNext(),
                          onInsuranceDate: () => _onDate(
                            false,
                            docType: _DocType.insurance,
                          ),
                          key: _formKey,
                          pickRollController: _pickRollController,
                          vehicletypeController: _vehicletypeController,
                          vehicleYearController: _vehicleYearController,
                          roadWorthyDateController: _roadWorthyDateController,
                          insuranceDateController: _insuranceDateController,
                          vehicleColorController: _vehicleColorController,
                          vehicleNumberController: _vehicleNumberController,
                          vehicleModelController: _vehicleModelController,
                          vehicleMakeController: _vehicleMakeController,
                          pickRollFocusNode: _pickRollFocusNode!,
                          vehicleColorFocusNode: _vehicleColorFocusNode!,
                          vehicleNumberFocusNode: _vehicleNumberFocusNode!,
                          vehicleModelFocusNode: _vehicleModelFocusNode!,
                          vehicleMakeFocusNode: _vehicleMakeFocusNode!,
                          roadWorthyPath: _roadWorthyPath,
                          insurancePath: _insurancePath,
                          onInsuranceImage: () => _onUploadDocument(
                            _DocType.insurance,
                            "",
                          ),
                          onRoadWorthyImage: () => _onUploadDocument(
                            _DocType.roadWorthy,
                            "",
                          ),
                        )
                      : Container(),
        ),
      ),
    );
  }

  void _onVehicleNext() {
    _unFocusAllNodes();
    Map<String, dynamic> meta = {
      "name": _nameController.text,
      "dob": _dobController.text,
      "gender": _genderController.text,
      "license": _licenseController.text,
      "expiryDate": _expiryDateController.text,
      "cardNo": _cardNoController.text,
      "pickRoll": _pickRollController.text,
      "vehicletype": _vehicletypeController.text,
      "vehicleYear": _vehicleYearController.text,
      "roadWorthyDate": _roadWorthyDateController.text,
      "insuranceDate": _insuranceDateController.text,
      "vehicleColor": _vehicleColorController.text,
      "vehicleNumber": _vehicleNumberController.text,
      "vehicleModel": _vehicleModelController.text,
      "vehicleMake": _vehicleMakeController.text,
      "imagePath": _imagePath,
      "licenseImageFrontPath": _licenseImageFrontPath,
      "licenseImageBackPath": _licenseImageBackPath,
      "ghanaCardFrontPath": _ghanaCardFrontPath,
      "ghanaCardBackPath": _ghanaCardBackPath,
      "roadWorthyPath": _roadWorthyPath,
      "insurancePath": _insurancePath,
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPersonalDetialsSummary(meta),
      ),
    );
  }

  void _onDocumentNext() {
    _unFocusAllNodes();
    _currentStep = 3;
    setState(() {});
  }

  void _onPersonalNext() {
    _unFocusAllNodes();
    _currentStep = 2;
    setState(() {});
  }

  Future<void> _onUploadDocument(_DocType docType, String side) async {
    _unFocusAllNodes();
    File imagePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ImageCapture(),
      ),
    );
    if (docType == _DocType.license) {
      side == "front"
          ? _licenseImageFrontPath = imagePath.path
          : _licenseImageBackPath = imagePath.path;
    } else if (docType == _DocType.ghanaCard) {
      side == "front"
          ? _ghanaCardFrontPath = imagePath.path
          : _ghanaCardBackPath = imagePath.path;
    } else if (docType == _DocType.roadWorthy) {
      _roadWorthyPath = imagePath.path;
    } else if (docType == _DocType.insurance) {
      _insurancePath = imagePath.path;
    }
    setState(() {});
  }

  Future<void> _onSnap() async {
    _unFocusAllNodes();
    await FaceCamera.initialize();
    if (!mounted) return;
    String imagePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FaceCapturing(),
      ),
    );
    _imagePath = imagePath;
    setState(() {});
  }

  void _onGender() {
    _unFocusAllNodes();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select gender'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _genderController.text = "Male";
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Male', style: TextStyle(fontSize: 20)),
              ),
              const Divider(),
              SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    _genderController.text = "Female";
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Female', style: TextStyle(fontSize: 20)),
              ),
            ],
          );
        });
  }

  void _onVehicleType() {
    _unFocusAllNodes();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Vehicle Type'),
            children: <Widget>[
              for (String data in Arrays.vehicleType) ...[
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      _vehicletypeController.text = data;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(data, style: const TextStyle(fontSize: 20)),
                ),
                const Divider(),
              ],
            ],
          );
        });
  }

  Future<void> _onDate(bool isDOB, {_DocType? docType}) async {
    _unFocusAllNodes();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(isDOB ? 1990 : 2024),
      firstDate: DateTime(isDOB ? 1900 : 2010),
      lastDate: DateTime(isDOB ? 2025 : 2050),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: Themes.datePickerTheme(),
          child: child!,
        );
      },
    );
    if (selected != null) {
      if (isDOB) {
        _dobController.text = selected.toIso8601String().split("T")[0];
      } else {
        if (docType == _DocType.roadWorthy) {
          _roadWorthyDateController.text =
              selected.toIso8601String().split("T")[0];
        } else if (docType == _DocType.insurance) {
          _insuranceDateController.text =
              selected.toIso8601String().split("T")[0];
        } else {
          _expiryDateController.text = selected.toIso8601String().split("T")[0];
        }
      }
      setState(() {});
    }
  }

  void _onVehicleYear() {
    _unFocusAllNodes();
    showDialog(
      context: context,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          title: const Text('Select a Year'),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: size.height / 1.3,
            width: size.width,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                ...List.generate(
                  20,
                  (index) => InkWell(
                    onTap: () {
                      _vehicleYearController.text =
                          (DateTime.now().year + index).toString();
                      Navigator.pop(context);
                    },
                    child: Chip(
                      label: Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          (DateTime.now().year + index).toString(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
