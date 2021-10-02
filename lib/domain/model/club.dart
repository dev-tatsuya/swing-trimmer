enum Club {
  w1,
  w3,
  w4,
  w5,
  w7,
  w9,
  u2,
  u3,
  u4,
  u5,
  u6,
  i2,
  i3,
  i4,
  i5,
  i6,
  i7,
  i8,
  i9,
  pw,
  aw,
  sw,
  pt,
  none,
}

extension ClubExt on Club {
  String get displayName {
    switch (this) {
      case Club.w1:
        return '1W';
      case Club.w3:
        return '3W';
      case Club.w4:
        return '4W';
      case Club.w5:
        return '5W';
      case Club.w7:
        return '7W';
      case Club.w9:
        return '9W';
      case Club.u2:
        return '2U';
      case Club.u3:
        return '3U';
      case Club.u4:
        return '4U';
      case Club.u5:
        return '5U';
      case Club.u6:
        return '6U';
      case Club.i2:
        return '2I';
      case Club.i3:
        return '3I';
      case Club.i4:
        return '4I';
      case Club.i5:
        return '5I';
      case Club.i6:
        return '6I';
      case Club.i7:
        return '7I';
      case Club.i8:
        return '8I';
      case Club.i9:
        return '9I';
      case Club.pw:
        return 'PW';
      case Club.aw:
        return 'AW';
      case Club.sw:
        return 'SW';
      case Club.pt:
        return 'PT';
      case Club.none:
        return '未設定';
    }
  }
}
