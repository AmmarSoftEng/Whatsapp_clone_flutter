import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/provider/replay_provider.dart';
import 'package:whatsapp/features/chat/widget/type_of_messages.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: messageColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Container(
        width: 350,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    messageReply!.isMe ? 'Me' : 'Opposite',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onTap: () => cancelReply(ref),
                ),
              ],
            ),
            const SizedBox(height: 8),
            MyWidget(message: messageReply.message, type: messageReply.type)

            // DisplayTextImageGIF(
            //   message: messageReply.message,
            //   type: messageReply.messageEnum,
            // ),
          ],
        ),
      ),
    );
  }
}
