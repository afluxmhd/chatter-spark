import 'dart:ui';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(types.User user) => '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

String convertToLastSeenString(int? timestamp) {
  if (timestamp == null) return 'Loading.....';
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes == 1) {
    return '1m ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours == 1) {
    return '1h ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    return difference.inDays ~/ 7 == 1 ? '1w ago' : '${difference.inDays ~/ 7}w ago';
  } else if (difference.inDays < 365) {
    return difference.inDays ~/ 30 == 1 ? '1mo ago' : '${difference.inDays ~/ 30}mo ago';
  } else {
    return difference.inDays ~/ 365 == 1 ? '1y ago' : '${difference.inDays ~/ 365}y ago';
  }
}
