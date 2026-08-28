import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/icon_size.dart';
import '../theme/insets.dart';

class CustomSnackBarContent extends StatelessWidget {
  const CustomSnackBarContent({
    super.key,
    required this.message,
    this.backgroundColor = AppColors.frenchRaspberry,
  });

  final String message;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(Insets.medium),
      height: 80.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.medium),
            ),
            child: SvgPicture.asset(
              'assets/icons/plant_icon.svg',
              height: IconSize.extraLarge * 1.5,
              width: IconSize.extraLarge * 1.5,
              colorFilter: ColorFilter.mode(AppColors.claret, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.culturedWhite,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
