import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/coaching-plan/controller/finishing_controller.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/loader.dart';

class FinishingScreen extends ConsumerWidget {
  const FinishingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(finishingProvider);

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
            color: Colors.transparent,
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
        data: (content) {
          if (content.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 22,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0X1A5CA99F),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,

                        children: [
                          Text(
                            content[0].description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButtonWidget(
                      text: "Reevaluate Hurdles",
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You have clicked the button!"),
                          ),
                        );
                        // GoRouter.of(context).push("/questionnaire");
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
