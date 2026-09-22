import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/questionnaire/controller/question_controller.dart';
import 'package:notizen/features/questionnaire/widgets/continue_back_button_widget.dart';
import 'package:notizen/features/questionnaire/widgets/custom_radio_widget.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/loader.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final questions =
          await ref.read(questionServiceProvider).fetchQuestions();
      ref.read(questionStateProvider.notifier).setQuestions(questions);
    });
  }

  void submitState(value) {
    setState(() {
      isSubmitting = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionStateProvider);
    if (questions.isEmpty || ref.watch(submitLoadingProvider) == 1) {
      return Loader();
    }
    if (ref.watch(submitLoadingProvider) == 2) {
      Future.microtask(() {
        if (context.mounted) {
          bool success = ref.watch(isResponseSaved);
          if (success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Responses saved!")));
            GoRouter.of(context).push('/question-results');
            ref.read(submitLoadingProvider.notifier).state = 0;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to save. Try again!")),
            );
            ref.read(submitLoadingProvider.notifier).state = 0;
          }
        }
      });
    }
    final page = ref.watch(pageProvider);
    final controller = ref.read(questionStateProvider.notifier);

    final totalPages = (questions.length / 5).ceil();
    final start = page * 5;
    final end = (start + 5).clamp(0, questions.length);
    final currentQuestions = questions.sublist(start, end);

    final progress = (page) / totalPages;
    return BottomNavigationLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
            size: 20,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: const Text(
            'Questionnaire Part',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0XFF5CA99F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${page + 1}/$totalPages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: LinearProgressIndicator(
              minHeight: 3.0,
              value: progress,
              color: Color(0XFF5CA99F),
              backgroundColor: Color(0XFFD9D9D9),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestions.length,
                  itemBuilder: (context, index) {
                    final question = currentQuestions[index];
                    final realIndex = start + index;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 0,
                          semanticContainer: true,
                          color: Color(0X1A5CA99F),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Q${realIndex + 1}: ${question.question}',
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
                        Row(
                          children: [
                            CustomRadioButton(
                              controller: controller,
                              realIndex: realIndex,
                              question: question,
                              title: "Yes",
                              fieldValue: true,
                            ),
                            const SizedBox(width: 16),
                            CustomRadioButton(
                              controller: controller,
                              realIndex: realIndex,
                              question: question,
                              title: "No",
                              fieldValue: false,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ContinueBackButtonsWidget(
                page: page,
                totalPages: totalPages,
                ref: ref,
                isSubmitting: isSubmitting,
                setState: submitState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
