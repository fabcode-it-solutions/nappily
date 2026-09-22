import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/privacy-policy/controller/privacy_controller.dart';
import 'package:notizen/models/privacy_model.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(privacyPolicyOptionsProvider);
    final controller = ref.read(privacyPolicyOptionsProvider.notifier);

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
          'Privacy Policy',
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "We want to respect your privacy. In order to provide you with the best possible app experience, we collect some data about your child's sleep habits (e.g. sleep duration, time to fall asleep, operating system, usage patterns).",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  "We use this data exclusively to:",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Color(0X1A5CA99F),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _Bullet(text: "Improve the app,"),
                        _Bullet(text: "Show you personalized recommendations,"),
                        _Bullet(text: "Support research on baby sleep,"),
                        _Bullet(
                          text:
                              "Occasionally send information about our app updates via email (no spam!),",
                        ),
                        _Bullet(
                          text:
                              "And to evaluate them statistically anonymously in order to recognize patterns and connections – without drawing conclusions about individuals.",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "All data is stored securely (e.g. on servers in the EU), transmitted in encrypted form and never passed on to unauthorized third parties.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Please agree to continue:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 8),

                _checkboxConsent(options, controller),
                const SizedBox(height: 24),

                Row(
                  children: [
                    rowButton(
                      "View Details",
                      onPress: () {
                        GoRouter.of(context).go('/settings');
                      },
                    ),
                    const SizedBox(width: 10),
                    rowButton(
                      "Decline",
                      onPress: () {
                        GoRouter.of(context).go('/home');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                CustomButtonWidget(
                  height: 50,
                  onPressed: () async {
                    await controller.save();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Preferences saved")),
                    );
                    GoRouter.of(context).go('/home');
                  },
                  text: "Agree & Start",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded rowButton(String text, {VoidCallback? onPress}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPress,
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

  Card _checkboxConsent(
    List<PrivacyPolicyOption> options,
    PrivacyPolicyController controller,
  ) {
    return Card(
      elevation: 0,
      color: Color(0X1A5CA99F),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children:
              options.map((e) {
                return ListTileTheme(
                  horizontalTitleGap: 0.0,
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Color(0XFF5CA99F),
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    value: e.accepted,
                    title: Text(
                      e.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onChanged: (_) => controller.toggle(e.id),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 6),
            child: Icon(Icons.circle, size: 6, color: Color(0XFF5CA99F)),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
