import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pickme_mobile/components/cachedImage.dart';
import 'package:pickme_mobile/components/ratingStar.dart';
import 'package:pickme_mobile/components/textField.dart';
import 'package:pickme_mobile/pages/modules/vendors/widget/vendorsAppBar.dart';
import 'package:pickme_mobile/spec/colors.dart';
import 'package:pickme_mobile/spec/images.dart';
import 'package:pickme_mobile/spec/styles.dart';

Widget vendorsWidget({
  @required BuildContext? context,
  @required FocusNode? searchFocusNode,
  @required void Function(String text)? onSearchChange,
  @required void Function()? onVentorFilter,
}) {
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
      return <Widget>[const VendorAppBar()];
    },
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            textFormField(
              hintText: "Search shoes, groceries, etc...",
              controller: null,
              focusNode: searchFocusNode,
              onTextChange: (String text) => onSearchChange!(text),
              backgroundColor: BColors.assDeep1,
              borderColor: BColors.assDeep1,
              icon: FeatherIcons.sliders,
              onIconTap: onVentorFilter,
            ),
            const SizedBox(height: 20),
            for (int x = 0; x < 6; ++x) ...[
              _layout(
                context: context!,
                title: "Amarazi Supermarket",
                subtitle: "Groceries",
                address: "Adabraka Junction",
                location: "Accra",
                rating: 4,
                onCall: () {},
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    ),
  );
}

Widget _layout({
  required BuildContext context,
  @required String? title,
  @required String? subtitle,
  @required String? address,
  @required String? location,
  @required double? rating,
  @required void Function()? onCall,
}) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: cachedImage(
            context: context,
            image:
                "https://tds-images.thedailystar.net/sites/default/files/styles/amp_metadata_content_image_min_696px_wide/public/images/2022/05/02/shopping.jpg",
            height: 60,
            width: 60,
            placeholder: Images.imageLoadingError,
          ),
        ),
        title: Text(title!, style: Styles.h4BlackBold),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle!, style: Styles.h6Black),
            const SizedBox(height: 5),
            Text(address!, style: Styles.h6Black),
          ],
        ),
        trailing: Column(
          children: [
            CircleAvatar(
              backgroundColor: BColors.primaryColor1,
              radius: 20,
              child: IconButton(
                onPressed: onCall,
                icon: const Icon(Icons.call),
                color: BColors.white,
                iconSize: 20,
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 70),
          SizedBox(
            width: MediaQuery.of(context).size.width * .35,
            child: Text(location!, style: Styles.h6Black),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ratingStar(
                rate: rating,
                function: null,
                size: 20,
                itemCount: 5,
                itemPadding: 1,
                unratedColor: BColors.assDeep,
              ),
              const SizedBox(width: 5),
              Text("4.5", style: Styles.h6BlackBold),
            ],
          ),
        ],
      ),
      const Divider(),
    ],
  );
}
