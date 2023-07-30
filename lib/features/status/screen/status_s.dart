// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';

import 'package:whatsapp/model/status_modle.dart';

class StatusS extends ConsumerStatefulWidget {
  static const String routeName = '/status-screens';
  Status status;
  StatusS({
    required this.status,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatusSState();
}

class _StatusSState extends ConsumerState<StatusS> {
  final controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItem();
  }

  void initStoryPageItem() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: controller));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoryView(
        storyItems: storyItems,
        controller: controller,
        onComplete: () {
          Navigator.pop(context);
        },
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        });
  }
}
