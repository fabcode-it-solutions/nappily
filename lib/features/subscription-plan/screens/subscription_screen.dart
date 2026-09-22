import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:notizen/features/subscription-plan/controller/subscription_controller.dart';
import 'package:notizen/models/subscription_plan_model.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/custom_popup_modal.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscriptionController()..loadSubscriptionPlans(),
      child: const SubscriptionScreenBody(),
    );
  }
}

class SubscriptionScreenBody extends StatelessWidget {
  const SubscriptionScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SubscriptionController>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
          'Subscription Plan',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
          ),
        ),
        child:
            controller.isLoading
                ? Center(
                  child: CircularProgressIndicator(color: Color(0XFF5CA99F)),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                      minWidth:
                          MediaQuery.of(context).size.width -
                          MediaQuery.of(context).padding.right -
                          MediaQuery.of(context).padding.left,
                    ),
                    child: Column(
                      children: [
                        Flexible(
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.plans.length,
                            itemBuilder: (_, index) {
                              final plan = controller.plans[index];
                              final isSelected =
                                  controller.selectedPlan?.name == plan.name;

                              return GestureDetector(
                                onTap: () => controller.selectPlan(plan),

                                child: Container(
                                  height: 106,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0X1A5CA99F),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Color(0XFF5CA99F)
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: _cardBody(plan),
                                ),
                              );
                            },
                          ),
                        ),
                        _subscribeButton(controller, context),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  CustomButtonWidget _subscribeButton(
    SubscriptionController controller,
    BuildContext context,
  ) {
    return CustomButtonWidget(
      text: "Subscribe",
      backgroundColor: Color(0XFF5CA99F),
      onPressed: () async {
        try {
          await controller.saveSelectedPlan(context);
          if (controller.selectedPlan == null) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a plan')),
            );
            return;
          }
          if (context.mounted) {
            showDialog(
              useSafeArea: false,
              context: context,
              barrierDismissible: true,
              builder:
                  (dialogContext) => Dialog(
                    elevation: 0,
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Color(0XCC110E1F),
                    child: CustomPopupModal(
                      title: "Thank You for Subscribing!",
                      message:
                          "Your subscription is now active.\nWe’re excited to have you on board!",
                      planDetails: true,
                      plan: capitalize(controller.selectedPlan?.name ?? ""),
                      renewalDate: DateFormat(
                        "dd-MM-yyyy",
                      ).format(DateTime.now()),
                      buttonText: "Continue",
                      onButtonPressed: () {
                        Navigator.pop(dialogContext, true);
                      },
                    ),
                  ),
            ).then((confirmed) async {
              if (confirmed == true) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscription saved successfully!'),
                  ),
                );
                GoRouter.of(context).pop();
              }
            });
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
    );
  }

  Row _cardBody(SubscriptionPlanModel plan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          capitalize(plan.name),
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${plan.price}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            if (plan.popular)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Color(0XFF5CA99F),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
