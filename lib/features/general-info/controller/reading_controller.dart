import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/general_info_model.dart';

final topicDetailControllerProvider =
    StateNotifierProvider.family<TopicDetailController, int, TopicDetailArgs>((
      ref,
      args,
    ) {
      return TopicDetailController(args.topics, args.initialIndex);
    });

class TopicDetailController extends StateNotifier<int> {
  final List<Topic> topics;

  TopicDetailController(this.topics, int initialIndex) : super(initialIndex);

  void next() {
    if (state < topics.length - 1) {
      state++;
    }
    print("object: $state");
  }

  void previous() {
    if (state > 0) {
      state--;
    }
  }

  Topic get currentTopic => topics[state];

  bool get hasNext => state < topics.length - 1;
  bool get hasPrevious => state > 0;
}

class TopicDetailArgs {
  final List<Topic> topics;
  final int initialIndex;

  TopicDetailArgs({required this.topics, required this.initialIndex});
}

final currentTopicsProvider = Provider<List<Topic>>((ref) => []);
