import 'package:flutter/material.dart';
import 'package:timesheets/features/odoo/odoo.dart';

extension ProjectColorExtensions on int? {
  Color get toColorFromColorIndex {
    switch (this) {
      case 0:
        return OdooColors.white.color;
      case 1:
        return OdooColors.green.color;
      case 2:
        return OdooColors.red.color;
      case 3:
        return OdooColors.yellow.color;
      case 4:
        return OdooColors.orange.color;
      case 5:
        return OdooColors.lightBlue.color;
      case 6:
        return OdooColors.mediumBlue.color;
      case 7:
        return OdooColors.darkBlue.color;
      case 8:
        return OdooColors.purple.color;
      case 11:
        return OdooColors.darkPurple.color;
      case 12:
        return OdooColors.fushia.color;
      case 13:
        return OdooColors.salmonPink.color;
      default:
        return OdooColors.white.color;
    }
  }

  OdooColors get toOdooColorFromColorIndex {
    switch (this) {
      case 0:
        return OdooColors.white;
      case 1:
        return OdooColors.green;
      case 2:
        return OdooColors.red;
      case 3:
        return OdooColors.yellow;
      case 4:
        return OdooColors.orange;
      case 5:
        return OdooColors.lightBlue;
      case 6:
        return OdooColors.mediumBlue;
      case 7:
        return OdooColors.darkBlue;
      case 8:
        return OdooColors.purple;
      case 11:
        return OdooColors.darkPurple;
      case 12:
        return OdooColors.fushia;
      case 13:
        return OdooColors.salmonPink;
      default:
        return OdooColors.white;
    }
  }
}
