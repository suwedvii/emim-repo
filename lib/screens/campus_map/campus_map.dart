import 'package:emim/providers/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CampusMap extends ConsumerWidget {
  const CampusMap({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(coursesProvider);
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('Add Course'),
        ),
        appBar: AppBar(
          title: const Text('Testing'),
        ),
        body: data.when(data: (_data) {
          print(_data.length);
          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: ((ctx, index) => ListTile(
                  title: Text(_data[index].code),
                  subtitle: Text(_data[index].title),
                )),
          );
        }, error: (error, s) {
          print(error.toString());
          return Center(
            child: Text(error.toString()),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
