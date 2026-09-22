import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/general-info/controller/reading_controller.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class TopicDetailScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const TopicDetailScreen({super.key, required this.initialIndex});

  @override
  ConsumerState<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends ConsumerState<TopicDetailScreen> {
  late final TopicDetailArgs _args;

  @override
  void initState() {
    super.initState();
    _args = TopicDetailArgs(
      topics: ref.read(currentTopicsProvider),
      initialIndex: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(topicDetailControllerProvider(_args));
    final controller = ref.read(topicDetailControllerProvider(_args).notifier);
    final topic = controller.currentTopic;

    return BottomNavigationLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      isFloatingActionButton: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 19.0,
            centerTitle: false,
            title: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 28,
              backgroundImage: const ExactAssetImage(
                'assets/images/nappily-logo.png',
              ),
            ),
            actions: [TimeIconButton()],
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          minWidth:
              MediaQuery.of(context).size.width -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                topic.title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: const Color(0X1A5CA99F),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Text(
                    topic.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topicChangeButton(
                    () => controller.hasPrevious ? controller.previous() : null,
                    "Previous Topic",
                  ),
                  const SizedBox(width: 10),

                  _topicChangeButton(
                    () => controller.hasNext ? controller.next() : null,
                    "Next Topic",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: CustomButtonWidget(
                  onPressed: () => GoRouter.of(context).pop(),
                  text: "Back to Overview",
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _topicChangeButton(VoidCallback onPressed, String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF5CA99F),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class TimeIconButton extends StatelessWidget {
  const TimeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF5CA99F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.all(10),
        ),
        onPressed: () => {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ImageIcon(
              AssetImage("assets/images/icons/time-icon.png"),
              color: Colors.white,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              "2 Mint",
              style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
