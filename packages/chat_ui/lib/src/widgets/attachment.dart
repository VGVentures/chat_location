import 'package:flutter/material.dart';

/// {@template attachment}
/// Adapts `stream_chat_fluttter`'s `wrapAttachmentWidget`.
/// {@endtemplate}
class Attachment extends StatelessWidget {
  /// {@macro attachment}
  const Attachment({
    Key? key,
    required Widget child,
    ShapeBorder? shapeBorder,
  })  : _child = child,
        _shapeBorder = shapeBorder,
        super(key: key);

  final ShapeBorder? _shapeBorder;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: _shapeBorder ?? const RoundedRectangleBorder(),
      type: MaterialType.transparency,
      child: _child,
    );
  }
}
