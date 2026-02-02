import 'package:lpinyin/lpinyin.dart';
import 'package:string_validator/string_validator.dart';

class User {
  final String userID;
  final String nickname;

  User({required this.userID, required this.nickname});
}

String getTag(User user) {
  String fistChar = user.nickname.split('').first;
  return isNumeric(fistChar) ? "#" : PinyinHelper.getShortPinyin(fistChar).toUpperCase();
}
