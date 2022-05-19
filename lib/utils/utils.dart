import 'package:flutter/material.dart';

class Utils {
  Utils._();

  static Widget messageWidget(BuildContext context,
      {String? msg, bool useScaffold = true}) {
    return useScaffold
        ? Scaffold(
            body: _messageWidget(context, msg: msg),
          )
        : _messageWidget(context, msg: msg);
  }

  static Widget circularLoadingWidget() {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget _messageWidget(BuildContext context, {String? msg}) {
    return Center(
      child: SelectableText(
        (msg ?? 'Something Went Wrong!'),
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.w600, color: Colors.red),
      ),
    );
  }
}
