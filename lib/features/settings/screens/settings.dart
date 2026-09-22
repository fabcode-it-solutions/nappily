import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/auth/auth.dart';
import 'package:notizen/features/auth/controller/auth_controller.dart';
import 'package:notizen/utils/user_local_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await UserLocalStorage.getUserData();
    setState(() {
      userData = data;
    });
  }

  final List<Map<String, dynamic>> entries = [
    {
      'title': 'Baby Profile',
      'iconPath': 'assets/images/icons/user-icon.png',
      'route': '/baby-profile',
    },
    {
      'title': 'Notifications',
      'iconPath': 'assets/images/icons/notification-icon.png',
      'route': '/notifications',
    },
    {
      'title': 'Subscription Plan',
      'iconPath': 'assets/images/icons/subscription-icon.png',
      'route': '/subscription-plans',
    },
    {
      'title': 'Payment Method',
      'iconPath': 'assets/images/icons/payment-icon.png',
      'route': '/payment-method',
    },
    {
      'title': 'Privacy / Terms',
      'iconPath': 'assets/images/icons/privacy-icon.png',
      'route': '/privacy-policy',
    },
    {
      'title': 'Delete Account',
      'iconPath': 'assets/images/icons/delete-icon.png',
      'route': '/delete-account',
    },
    {
      'title': 'Log Out',
      'iconPath': 'assets/images/icons/logout-icon.png',
      'route': '/log-out',
      'isLogout': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          'Settings',
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => GoRouter.of(context).push('/edit-profile'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0X1A5CA99F),
                      border: Border.all(color: Color(0xFF6256B1), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color(0xFF5CA99F),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xD90F0D1D),
                            child: SizedBox(
                              width: 65,
                              height: 65,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/icons/user-profile-icon.png',
                                ),
                                color: Color(0X99D9D9D9),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['name'] ?? '_',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                userData?['email'] ?? '_',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF5CA99F),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final item = entries[index];
                      final isLogout = item['isLogout'] == true;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ImageIcon(
                          AssetImage(item['iconPath']),
                          color: Colors.white,
                          size: 20,
                        ),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Poppins",
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF5CA99F),
                          size: 16,
                        ),
                        onTap: () {
                          if (isLogout) {
                            _showLogoutConfirmationDialog(context);
                          } else {
                            GoRouter.of(context).push(item['route']);
                          }
                        },
                      );
                    },
                    separatorBuilder:
                        (context, index) => Divider(color: Color(0X1AFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            elevation: 0,
            backgroundColor: const Color(0xD90F0D1D),
            title: const Text(
              "Confirm Logout",
              style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            ),
            content: const Text(
              "Are you sure you want to logout?",
              style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            ),
            actions: [
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: Colors.white, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF5CA99F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: () async {
                  await UserLocalStorage.clearUserData();
                  if (!context.mounted) return;
                  Navigator.pop(context, true);
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
    ).then((confirmed) async {
      if (confirmed == true) {
        final authController = AuthController();
        await authController.signOut();
        if (!context.mounted) return;
        AppAuth.of(context).signOut();
        GoRouter.of(context).go("/login");
      }
    });
  }
}
