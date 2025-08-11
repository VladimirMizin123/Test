import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/stripe_card_model.dart';

class CreditCardWidget extends StatelessWidget {
  const CreditCardWidget({
    super.key,
    required this.card,
    this.onTap,
  });
  final StripeCard card;
  final Function()? onTap;

  String formatCardNumber(String cardNumber) {
    return cardNumber
        .replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = card.isPrimary ?? false;

    final Color color = isPrimary ? AppColors.terracotta : AppColors.lightGrey;

    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: color),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff004C63).withOpacity(0.08),
              offset: const Offset(0, 0),
              blurRadius: 16,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsUtils.creditCard),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (card.name ?? "----"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff010101),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatCardNumber(
                                (card.last4 ?? "").padLeft(16, "x"),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xff010101),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.terracotta.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.terracotta),
                              ),
                              child: const Text(
                                'default',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.terracotta,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                5.width,
                Image.asset(
                  AssetsUtils.arrowForward,
                  height: 15,
                  color: AppColors.terracotta,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
