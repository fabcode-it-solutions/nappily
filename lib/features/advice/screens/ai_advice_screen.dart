import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/features/advice/controller/ai_advice_controller.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/loader.dart';

class AiAdviceScreen extends ConsumerWidget {
  const AiAdviceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(aiPlansProvider);

    return BottomNavigationLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      child: plansAsync.when(
        loading: () => const Loader(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data:
            (plans) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        return Center(
                          child: Card(
                            color: Color(0X1A5CA99F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 50,
                                left: 20,
                                right: 20,
                                bottom: 100,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plan.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Text(
                                        plan.price,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "INR/",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Text(
                                        plan.planCycle,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    plan.billingCycle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.center,
                                    child: FractionallySizedBox(
                                      widthFactor: 1.12,
                                      child: Divider(
                                        indent: 0,
                                        endIndent: 0,
                                        thickness: 1,
                                        color: Color(0XFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _subHeading('Rates starting at'),
                                  const SizedBox(height: 8),
                                  ...plan.rates.map((r) => _buildCheck(r)),
                                  const SizedBox(height: 20),
                                  _subHeading('Standout features'),
                                  const SizedBox(height: 8),
                                  ...plan.features.map((f) => _buildCheck(f)),
                                  const SizedBox(height: 20),
                                  CustomButtonWidget(
                                    text: "Subscribe Now",
                                    onPressed: () {},
                                    height: 50,
                                    buttonTextSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Text _subHeading(String heading) {
    return Text(
      heading,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "Poppins",
      ),
    );
  }

  Widget _buildCheck(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
