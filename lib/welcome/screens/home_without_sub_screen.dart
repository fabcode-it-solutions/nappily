import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/ai-chat/screens/ai_screen.dart';
import 'package:notizen/welcome/provider/home_without_sub_provider.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/loader.dart';
import 'package:notizen/widgets/main_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeWithoutSubScreen extends ConsumerWidget {
  const HomeWithoutSubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncContent = ref.watch(homeWithoutSubProvider);

    return MainLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
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
          child: asyncContent.when(
            loading: () => const Loader(),
            error: (err, _) => Center(child: Text("Error: $err")),
            data:
                (content) => SingleChildScrollView(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0X1A5CA99F),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content.description,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              content.question,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomButtonWidget(
                        text: "Questionnaire",
                        onPressed: () {
                          GoRouter.of(context).push("/questionnaire");
                        },
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

Function(int) onTabChanged(BuildContext context) {
  return (int index) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    switch (index) {
      case 0:
        GoRouter.of(context).push("/home");
        break;
      case 1:
        GoRouter.of(context).push("/music");
        break;
      case 2:
        GoRouter.of(context).push("/add-post");
        break;
      case 3:
        GoRouter.of(context).push("/recent-notifications");
        break;
      case 4:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          isDismissible: true,
          useRootNavigator: true,
          anchorPoint: Offset(0, 0),
          builder: (_) => ChatModal(userId: user!.uid),
        );
        break;
    }
  };
}
