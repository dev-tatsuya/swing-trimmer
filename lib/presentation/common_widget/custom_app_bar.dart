import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    String title = '',
    Widget? leading,
    List<Widget>? actions,
  }) : super(
          key: key,
          title: Text(title),
          leading: leading,
          actions: actions,
        );

  @override
  Size get preferredSize => const Size.fromHeight(44);
}
