import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notizen/features/ai-chat/screens/ai_screen.dart';

class BottomNavigationLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final int currentIndex;
  final Function(int) onTabChanged;
  final bool isFloatingActionButton;
  final String floatingButtonImgUrl;
  final Function()? onFloatingButtonPressed;

  const BottomNavigationLayout({
    super.key,
    required this.child,
    required this.appBar,
    required this.currentIndex,
    required this.onTabChanged,
    this.isFloatingActionButton = false,
    this.floatingButtonImgUrl = "assets/images/icons/floating-chat-icon.png",
    this.onFloatingButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: child),
      ),
      floatingActionButton:
          isFloatingActionButton
              ? Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    elevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    disabledElevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                child: FloatingActionButton(
                  onPressed:
                      onFloatingButtonPressed ??
                      () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          isDismissible: true,
                          useRootNavigator: true,
                          anchorPoint: Offset(0, 0),
                          builder: (_) => ChatModal(userId: user!.uid),
                        );
                      },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: ImageIcon(
                    AssetImage(floatingButtonImgUrl),
                    color: Color(0xFF5CA99F),
                    size: 40,
                  ),
                ),
              )
              : null,
      bottomNavigationBar: BottomBar(
        currentIndex: currentIndex,
        onTabChanged: onTabChanged,
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  final int currentIndex;
  final Function(int p1) onTabChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: const Color(0XFF110E1F),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Color(0X80FFFFFF),
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          onTap: onTabChanged,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/icons/home-icon.png"),
                color: currentIndex == 0 ? Colors.white : Color(0X80FFFFFF),
                size: 30,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/icons/music-icon.png"),
                color: currentIndex == 1 ? Colors.white : Color(0X80FFFFFF),
                size: 30,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0XFF3B3372), Color(0XFF7061D8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: currentIndex == 3 ? Colors.white : Color(0X80FFFFFF),
                size: 36,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/icons/ai-agent-icon.png"),
                color: currentIndex == 4 ? Colors.white : Color(0X80FFFFFF),
                size: 30,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
