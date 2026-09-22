import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/questionnaire/controller/subscription_controller.dart';
import 'package:notizen/features/subscription-plan/screens/subscription_screen.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class SubscribeNowScreen extends ConsumerStatefulWidget {
  const SubscribeNowScreen({super.key});

  @override
  ConsumerState<SubscribeNowScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscribeNowScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(subscriptionControllerProvider);

    return BottomNavigationLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) => onTabChanged(context)(screenNumber),
      isFloatingActionButton: false,
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
          'Subscribe to Unlock More!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0X1A5CA99F),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: const Text(
                  "Multiple sleeping barriers detected. Let's tackle them together to get your baby and yourself a good sleep.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  _buildTabButton('Experts Advice', 0),
                  _buildTabButton('AI Advice', 1),
                ],
              ),
            ),
            const SizedBox(height: 32),

            subscription.when(
              data:
                  (data) => Column(
                    children: List.generate(data.length, (index) {
                      final plan = data[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                plan.billingCycle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    plan.price,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "/${capitalize(plan.planCycle)}",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Divider(color: Colors.white),
                            const SizedBox(height: 8),

                            _subHeading('Rates starting at'),
                            const SizedBox(height: 8),
                            ...plan.rates.map((r) => _buildCheck(r)),
                            const SizedBox(height: 20),
                            _subHeading('Standout features'),
                            const SizedBox(height: 8),
                            ...plan.features.map((f) => _buildCheck(f)),
                          ],
                        ),
                      );
                    }),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),

            const SizedBox(height: 20),
            CustomButtonWidget(
              text: "Subscribe Now",
              onPressed: () {
                GoRouter.of(context).push("/subscription-plans");
              },
            ),
          ],
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

  Widget _buildTabButton(String text, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
            final type = index == 0 ? 'expert-plan' : 'ai-plan';
            ref
                .read(subscriptionControllerProvider.notifier)
                .fetchSubscription(type);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [Color(0xFF3B3372), Color(0xFF7061D8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                    : null,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
