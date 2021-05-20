import 'package:flutter/material.dart';

class MyTextEditingController extends TextEditingController {
  MyTextEditingController({
    String? text,
    TextStyle editingTextStyle =
        const TextStyle(backgroundColor: Colors.black12),
  })  : _editingTextStyle = editingTextStyle,
        super(text: text);

  TextStyle _editingTextStyle;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    assert(!value.composing.isValid ||
        !withComposing ||
        value.isComposingRangeValid);
    if (!value.composing.isValid || !withComposing) {
      return TextSpan(style: style, text: text);
    }
    final TextStyle composingStyle = style!.merge(_editingTextStyle);
    return TextSpan(style: style, children: <TextSpan>[
      TextSpan(text: value.composing.textBefore(value.text)),
      TextSpan(
        style: composingStyle,
        text: value.composing.textInside(value.text),
      ),
      TextSpan(text: value.composing.textAfter(value.text)),
    ]);
  }
}
