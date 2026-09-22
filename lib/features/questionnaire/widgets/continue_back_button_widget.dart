import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/features/questionnaire/controller/question_controller.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class ContinueBackButtonsWidget extends StatelessWidget {
  const ContinueBackButtonsWidget({
    super.key,
    required this.page,
    required this.totalPages,
    required this.ref,
    this.isSubmitting = false,
    required this.setState,
  });

  final int page;
  final int totalPages;
  final WidgetRef ref;
  final bool isSubmitting;
  final Function(bool) setState;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButtonWidget(
          onPressed: () async {
            if (page < totalPages - 1) {
              ref.read(pageProvider.notifier).state++;
            } else {
              ref.read(submitLoadingProvider.notifier).state = 1;

              final success = await ref
                  .read(questionServiceProvider)
                  .saveUserResponses(ref.read(questionStateProvider));
              if (success) {
                ref.read(submitLoadingProvider.notifier).state = 2;
                ref.read(isResponseSaved.notifier).state = true;
              } else {
                ref.read(submitLoadingProvider.notifier).state = 2;
                ref.read(isResponseSaved.notifier).state = false;
              }
            }
          },
          text: page < totalPages - 1 ? "Continue" : "Submit",
        ),
        if (page > 0)
          Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => ref.read(pageProvider.notifier).state--,
                child: const Text(
                  "Back",
                  style: TextStyle(
                    color: Color(0X80FFFFFF),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
