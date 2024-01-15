import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'drawer_content.dart';

/// Home AppBar
class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  _HomeAppBarState createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _HomeAppBarState extends State<HomeAppBar> {
  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: _openDrawer,
        icon: const Icon(
          Icons.apps,
          color: Colors.black,
          size: 40,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/user.png'),
          radius: 30,
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
