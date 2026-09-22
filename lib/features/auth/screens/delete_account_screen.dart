import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/auth/auth.dart';
import 'package:notizen/utils/user_local_storage.dart';
import 'package:notizen/widgets/custom_button_widget.dart';

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0X1A5CA99F),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            ),
            content: const Text(
              "Are you sure you want to permanently delete your account? This cannot be undone.",
              style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.white, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF5CA99F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: () async {
                  if (!context.mounted) return;
                  Navigator.pop(context, true);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await UserLocalStorage.screens(key: 'isWelcomeScreen', value: '');
          if (!context.mounted) return;
          await AppAuth.of(context).deleteAccount();

          if (!context.mounted) return;
          await AppAuth.of(context).signOut();
          if (!context.mounted) return;
          GoRouter.of(context).go("/sign-up");

          // Optional: Sign out and redirect
          // await ref.read(authServiceProvider).signOut();
          if (context.mounted) {
            // context.go('/login'); // Or your actual login route
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            await UserLocalStorage.screens(
              key: 'isWelcomeScreen',
              value: 'true',
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please reauthenticate to delete your account.",
                  ),
                ),
              );
              await AppAuth.of(context).signOut();
              if (!context.mounted) return;
              GoRouter.of(context).go("/login");
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
            }
          }
        } catch (e) {
          await UserLocalStorage.screens(key: 'isWelcomeScreen', value: '');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to delete account: $e")),
            );
            await AppAuth.of(context).signOut();
            if (!context.mounted) return;
            GoRouter.of(context).go("/sign-up");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Delete Account',
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
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      "Permanently delete your account and all related data from our system.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomButtonWidget(
                      onPressed: () => _confirmAndDelete(context, ref),
                      text: "Delete My Account",
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
