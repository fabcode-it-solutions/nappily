import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notizen/features/auth/auth.dart';
import 'package:notizen/utils/user_local_storage.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/custom_popup_modal.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen>
    with WidgetsBindingObserver {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  bool loading = false;
  bool isMinimized = false;
  Map<String, dynamic>? userData;
  String? userEmail;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadUserData();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
    WidgetsBinding.instance.addObserver(this);
    startEmailVerificationChecker();
  }

  void startEmailVerificationChecker() {
    if (!isMinimized) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      setState(() {
        isMinimized = true;
      });
      _timer?.cancel();
    }
    if (state == AppLifecycleState.resumed) {
      setState(() {
        isMinimized = false;
      });
      checkEmailVerified();
    }
  }

  Future<void> loadUserData() async {
    final data = await UserLocalStorage.getUserData();
    setState(() {
      userData = data;
      loading = false;
      if (userData != null) {
        userEmail = userData?['email'];
      }
    });
  }

  Future sendVerificationEmail() async {
    try {
      setState(() {
        loading = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to send verification. ${e.toString()}. Please try again.",
            ),
          ),
        );
      }
    }
  }

  Future checkEmailVerified() async {
    // setState(() => loading = true);
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      loading = false;
    });

    if (isEmailVerified) {
      _timer?.cancel();
      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return;
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
                title: "Your Email is Verified!",
                message:
                    "Thank you! Your email address has been successfully verified.",
                planDetails: false,
                buttonText: "Continue",
                onButtonPressed: () {
                  Navigator.pop(dialogContext, true);
                },
              ),
            ),
      ).then((confirmed) async {
        if (confirmed == true) {
          if (!mounted) return;
          await AppAuth.of(context).signIn();
          if (!mounted) return;
          GoRouter.of(context).go("/settings");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
          ),
        ),
        child: Center(
          widthFactor: double.infinity,
          heightFactor: double.infinity,
          child: SingleChildScrollView(
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
              child: IntrinsicHeight(
                child:
                    loading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0XFF5CA99F),
                          ),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 25,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0XFF5CA99F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SvgPicture.asset(
                                'assets/images/email-oulined.svg',
                                height: 58,
                                width: 58,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Verify Your Email",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "A verification email has been sent to $userEmail. Please verify to continue.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            CustomButtonWidget(
                              text: "I have verified",
                              backgroundColor: Color(0XFF5CA99F),
                              textColor: Colors.black,
                              onPressed: () {
                                checkEmailVerified();
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Don’t receive the email?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0X80FFFFFF),
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap:
                                  canResendEmail ? sendVerificationEmail : null,

                              child: const Text(
                                "Click to resend",
                                style: TextStyle(
                                  color: Color(0XFFFFFFFF),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0XFFFFFFFF),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                GoRouter.of(context).go("/sign-up");
                              },
                              child: const Text(
                                "Back to sign up",
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
