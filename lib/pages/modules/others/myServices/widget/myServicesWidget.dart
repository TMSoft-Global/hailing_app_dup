import 'package:flutter/material.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget myServicesWidget({
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        ListTile(
          title: Text("My main service ", style: Styles.h5Black),
        ),
        _layout(
          title: "PICKME Worker Driver",
          isCheck: true,
          onChange: (bool value) {},
        ),
        const SizedBox(height: 20),
        ListTile(
          title: Text("Other services ", style: Styles.h5Black),
        ),
        for (int x = 0; x < 3; ++x)
          _layout(
            title: "Personal Shopper",
            isCheck: false,
            onChange: (bool value) {},
          ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget _layout({
  required String title,
  required bool isCheck,
  required void Function(bool value) onChange,
}) {
  return SwitchListTile(
    title: Text(title, style: Styles.h4BlackBold),
    value: isCheck,
    onChanged: (bool value) => onChange(value),
    activeColor: BColors.primaryColor1,
  );
}
