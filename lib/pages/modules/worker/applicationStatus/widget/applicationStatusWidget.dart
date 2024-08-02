import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/styles.dart';

import 'applicationStatusAppBar.dart';

Widget applicationStatusWidget({
  required BuildContext context,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[const ApplicationStatusAppBar()];
    },
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            for (int x = 0; x < 4; ++x) ...[
              Card(
                elevation: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: BColors.assDeep1,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: circular(
                            child: cachedImage(
                              context: context,
                              image: "",
                              height: 60,
                              width: 60,
                              placeholder: Images.defaultProfilePicOffline,
                            ),
                            size: 60,
                          ),
                          title:
                              Text("Janet Jackson", style: Styles.h4BlackBold),
                          trailing: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: BColors.primaryColor,
                            ),
                            child: Text("Processing", style: Styles.h6White),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                        Text("Choosen Services", style: Styles.h6Black),
                        const SizedBox(height: 10),
                        Text("Pickme Driver", style: Styles.h6BlackBold),
                        const SizedBox(height: 5),
                        Text("Personal Shopper", style: Styles.h6BlackBold),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    ),
  );
}
