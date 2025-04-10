import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

/// A "polyfix" [TextSpan] that properly renders Emoji at the correct size
/// and vertical-alignment for the given [style].
///
/// See https://github.com/flutter/flutter/issues/28894
class EmojiTextSpan extends TextSpan {
  EmojiTextSpan({
    TextStyle? style,
    String? text,
    List<TextSpan>? children,
    GestureRecognizer? recognizer,
  }) : super(
            style: style,
            children: _parse(style, text)..addAll(children ?? []),
            recognizer: recognizer);

  static final regex = RegExp(
      r"((?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|"
      r"[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|"
      r"\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|"
      r"[\ud83c\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|[\ud83c\ude32-\ude3a]|"
      r"[\ud83c\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]"
      r"|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b"
      r"|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]"
      r"|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])+)");

  static List<TextSpan> _parse(TextStyle? style, String? text) {
    /// Skip if not iOS
    if (Platform.isIOS == false) {
      return [TextSpan(style: style, text: text)];
    }

    final _style = style ?? const TextStyle(fontSize: 16, height: 1.1);

    final emojiStyle = _style.copyWith(
      fontSize: (_style.fontSize ?? 16) * 1.25,
      height: (_style.height ?? 1.1) * 0.6,
      letterSpacing: 2,
    );

    final spans = <TextSpan>[];

    text?.splitMapJoin(
      regex,
      onMatch: (m) {
        spans.add(TextSpan(text: m.group(0), style: emojiStyle));
        return '';
      },
      onNonMatch: (s) {
        spans.add(TextSpan(text: s));
        return '';
      },
    );

    return spans;
  }
}
