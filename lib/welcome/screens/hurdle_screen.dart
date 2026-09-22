import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/models/home_model.dart';
import 'package:notizen/welcome/controller/hurdle_controller.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';

class HurdleDetailScreen extends ConsumerWidget {
  final String id;

  const HurdleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hurdle = GoRouterState.of(context).extra as HomeModel;
    final checklist = ref.watch(hurdleChecklistControllerProvider(hurdle));
    final controller = ref.read(
      hurdleChecklistControllerProvider(hurdle).notifier,
    );

    final completed = checklist.where((e) => e.isChecked).length;
    final total = checklist.length;

    return BottomNavigationLayout(
      currentIndex: 3,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      isFloatingActionButton: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: EdgeInsets.only(top: 24),
          child: AppBar(
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0.0,
            centerTitle: false,
            title: Text(
              "Hurdle of the Day",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _whiteText(hurdle.title, 18, FontWeight.w600),
              const SizedBox(height: 16),
              _whiteText("Text:", 14, FontWeight.w600),
              const SizedBox(height: 8),
              _whiteText(hurdle.task, 14, FontWeight.w400),
              const SizedBox(height: 16),
              _whiteText("Why:", 14, FontWeight.w600),
              const SizedBox(height: 8),
              _whiteText(hurdle.why, 14, FontWeight.w400),
              const SizedBox(height: 16),

              Card(
                color: Color(0X1A5CA99F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 1),
                ),

                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _whiteText("Checklist to Follow", 15, FontWeight.w400),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              color: Color(0XFF5CA99F),
                              value: total == 0 ? 0 : completed / total,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _whiteText('$completed/$total', 12, FontWeight.w500),
                        ],
                      ),
                      ListView.separated(
                        padding: EdgeInsets.only(left: 0),
                        shrinkWrap: true,
                        itemCount: total,
                        separatorBuilder:
                            (context, index) => Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0X33DBDBDB),
                            ),
                        itemBuilder: (context, index) {
                          return ListTileTheme(
                            horizontalTitleGap: 0.0,
                            contentPadding: EdgeInsets.zero,
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Color(0XFF5CA99F),
                              side: const BorderSide(color: Colors.white),
                              checkColor: Colors.white,
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                hurdle.checklist[index]['title'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  color:
                                      checklist[index].isChecked
                                          ? Color(0XFF5CA99F)
                                          : Colors.white,
                                  decoration:
                                      checklist[index].isChecked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  decorationColor: Color(0XFF5CA99F),
                                  decorationThickness: 1.5,
                                ),
                              ),
                              value: checklist[index].isChecked,
                              onChanged: (_) => controller.toggle(index),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _whiteText("Note:", 14, FontWeight.w600),
              const SizedBox(height: 8),
              _whiteText(hurdle.note, 12, FontWeight.w400),
            ],
          ),
        ),
      ),
    );
  }

  Text _whiteText(String text, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontFamily: "Poppins",
        fontWeight: fontWeight,
      ),
    );
  }
}
