import 'package:flutter/material.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/core/extensions/string_extension.dart';
import 'package:lettutor/core/widgets/image_custom.dart';
import 'package:url_launcher/url_launcher.dart';

class EbookItem extends StatelessWidget {
  const EbookItem({
    super.key,
    required this.item,
  });

  final Ebook item;

  void _launcherURl() async {
    if (item.fileUrl?.isNotEmpty ?? false) {
      final Uri url = Uri.parse(item.fileUrl!);
      if (!await launchUrl(url)) {
        throw Exception("Could not launch url $url");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launcherURl,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 5.0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(5.0)),
                child: ImageCustom(
                  imageUrl: item.imageUrl ?? ImageConstant.baseImageView,
                  isNetworkImage: true,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: context.titleMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  RichText(
                    text: TextSpan(
                      style: context.titleSmall
                          .copyWith(fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: 'Level ',
                          style:
                          TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        TextSpan(
                          text: (item.level ?? '0').renderExperienceText,
                        )
                      ],
                    ),
                  ),
                  Text(
                    item.description ?? '',
                    style: context.titleSmall
                        .copyWith(color: Theme.of(context).hintColor),
                  ),
                ].expand((e) => [e, const SizedBox(height: 5.0)]).toList()
                  ..removeLast(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
