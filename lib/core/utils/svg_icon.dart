import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/icon_size.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    super.key,
    required this.path,
    this.colorFilter,
    this.iconSize = IconSize.small,
    this.semanticsLabel,
  });

  final String path;
  final ColorFilter? colorFilter;
  final double iconSize;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: colorFilter,
      height: iconSize,
      semanticsLabel: semanticsLabel,
      width: iconSize,
    );
  }
}
