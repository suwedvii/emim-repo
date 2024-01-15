import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttachmentList extends StatelessWidget {
  const AttachmentList(
      {super.key,
      required this.attachments,
      required this.onAttachmentDeleted});

  final Function(int index) onAttachmentDeleted;
  final List<PlatformFile> attachments;
  @override
  Widget build(BuildContext context) {
    return attachments.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No attachments added, click on the + (plus button) to add new attachments!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          )
        : ListView.builder(
            itemCount: attachments.length,
            itemBuilder: (ctx, index) => Dismissible(
              key: ValueKey(attachments[index].identifier),
              onDismissed: (direction) {
                onAttachmentDeleted(index);
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(attachments[index].name)),
                      const Spacer(),
                      Text(
                        '${attachments[index].size}',
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      IconButton(
                        onPressed: () {
                          onAttachmentDeleted(index);
                        },
                        icon: const Icon(Icons.delete_forever_outlined),
                        color: Theme.of(context).colorScheme.error,
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
  }
}
