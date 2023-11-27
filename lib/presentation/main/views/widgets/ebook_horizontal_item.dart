import 'package:flutter/material.dart';
import 'package:lettutor/core/constants/image_constant.dart';
import 'package:lettutor/core/extensions/context_extension.dart';
import 'package:lettutor/domain/entities/common/ebook.dart';

class EbookHorizontalItem extends StatelessWidget {
  final Ebook ebook;
  final bool isFirstItem;
  const EbookHorizontalItem({
    super.key,
    required this.ebook,
    required this.isFirstItem,
  });

  EdgeInsetsGeometry get _margin => EdgeInsets.only(
      left: isFirstItem ? 10 : 0, right: 10.0, top: 10.0, bottom: 10.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.widthDevice * 0.75,
      height: double.infinity,
      margin: _margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            width: 130,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              image: DecorationImage(
                image: NetworkImage(ebook.imageUrl ?? ImageConstant.baseImageView),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ebook.name,
                    maxLines: 2,
                    style: context.titleSmall
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    ebook.description ?? '',
                    maxLines: 4,
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
