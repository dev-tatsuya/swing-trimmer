import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    String title = '',
    Widget? leading,
    List<Widget>? actions,
    Color? backgroundColor,
  }) : super(
          key: key,
          title: Text(title),
          leading: leading,
          actions: actions,
          backgroundColor: backgroundColor,
        );

  @override
  Size get preferredSize => const Size.fromHeight(44);
}
