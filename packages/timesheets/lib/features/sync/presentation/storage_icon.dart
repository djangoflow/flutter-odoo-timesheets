import 'package:flutter/cupertino.dart';

class StorageIcon extends Icon {
  const StorageIcon(this.isExternal, {super.key})
      : super(
          isExternal ? CupertinoIcons.cloud_fill : CupertinoIcons.floppy_disk,
        );
  final bool isExternal;
}
