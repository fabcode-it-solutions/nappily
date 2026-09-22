import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/coaching-plan/controller/coaching_controller.dart';
import 'package:notizen/features/coaching-plan/widgets/custom_radio_widget.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/loader.dart';

class CoachingPlanScreen extends ConsumerWidget {
  const CoachingPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(coachingProvider);
    final successAnswer = ref.watch(successStateProvider);

    return BottomNavigationLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      isFloatingActionButton: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => GoRouter.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
            size: 20,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        title: const Text(
          'Daily Coaching Plan',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: resultAsync.when(
        loading: () => const Loader(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (suggestions) {
          if (suggestions.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Try Step 1",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children:
                          suggestions.map((s) {
                            return Expanded(
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 20,
                                  ),
                                  child: Text(
                                    s.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      elevation: 0,
                      semanticContainer: true,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Was this successful?',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CustomRadioWidget(
                          successAnswer: successAnswer,
                          onTap: () {
                            ref.read(successStateProvider.notifier).state =
                                true;
                            GoRouter.of(context).push('/finishing');
                          },
                          value: true,
                          title: "Yes",
                        ),
                        const SizedBox(width: 16),
                        CustomRadioWidget(
                          successAnswer: successAnswer,
                          onTap: () {
                            ref.read(successStateProvider.notifier).state =
                                false;
                          },
                          value: false,
                          title: "No",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      color: Color(0X1A5CA99F),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 28,
                        ),
                        child: Text(
                          "If you use expert advice and AI advice at the same time, make sure you feel comfortable with it. A mix of both can be a good choice.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    CustomButtonWidget(
                      text: "Upgrade to AI Feedback",
                      onPressed: () {
                        GoRouter.of(context).push('/subscribe-now');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
