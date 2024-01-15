import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key, this.appBarTitle});

  final String? appBarTitle;

  @override
  ConsumerState<ChatsScreen> createState() {
    return _ChatsScreennState();
  }
}

class _ChatsScreennState extends ConsumerState<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text('Opps, nothing here!')],
      ),
    );

    if (widget.appBarTitle == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.appBarTitle}'),
      ),
      body: content,
    );
  }
}
