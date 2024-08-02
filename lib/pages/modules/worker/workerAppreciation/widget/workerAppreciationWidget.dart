import 'package:flutter/material.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/circular.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget workerAppreciationWidget({
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text("Worker Appreciation", style: Styles.h3BlackBold),
          const SizedBox(height: 20),
          Text(
            "These are company selected individual reward scheme to appreciate excellent performance ",
            style: Styles.h6Black,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          for (int x = 0; x < 2; ++x) ...[
            Card(
              elevation: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: BColors.assDeep.withOpacity(.06),
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
                        title: Text(
                          "Janet Jackson",
                          style: Styles.h4BlackBold,
                        ),
                        subtitle: Text(
                          "PICKME Driver",
                          style: Styles.h5Primary1,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: BColors.yellow1),
                            const SizedBox(width: 5),
                            Text("4.9", style: Styles.h6BlackBold)
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text("Rewarded", style: Styles.h6Black),
                      const SizedBox(height: 10),
                      Text(
                        "First  PICKME Driver with over 3.5 customer ratings",
                        style: Styles.h6BlackBold,
                      ),
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
  );
}
