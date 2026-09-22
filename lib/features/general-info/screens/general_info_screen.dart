import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/general-info/controller/general_info_controller.dart';
import 'package:notizen/features/general-info/controller/reading_controller.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/widgets/bottom_navigation_layout.dart';
import 'package:notizen/widgets/loader.dart';

class GeneralInfoScreen extends ConsumerStatefulWidget {
  const GeneralInfoScreen({super.key});

  @override
  ConsumerState<GeneralInfoScreen> createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends ConsumerState<GeneralInfoScreen> {
  final _expandedSections = <int>{};
  bool _initialized = false;

  final _images = [
    "assets/images/food.png",
    "assets/images/clothing.png",
    "assets/images/sound.png",
    "assets/images/safety.png",
    "assets/images/sleeptracker.png",
  ];
  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(generalInfoDataProvider);

    return BottomNavigationLayout(
      currentIndex: 0,
      onTabChanged: (screenNumber) {
        onTabChanged(context)(screenNumber);
      },
      isFloatingActionButton: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        leadingWidth: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: const SizedBox.shrink(),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: asyncData.when(
        loading: () => const Loader(),
        error:
            (e, _) => Center(
              child: Text('Error: $e', style: TextStyle(color: Colors.red)),
            ),
        data: (sections) {
          if (sections.isEmpty) {
            return const Center(child: Text('No results found.'));
          }
          if (!_initialized) {
            _expandedSections.addAll(List.generate(sections.length, (i) => i));
            _initialized = true;
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),

                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          final section = sections[index];
                          final isExpanded = _expandedSections.contains(index);
                          final topicIndex = Random().nextInt(
                            section.topics.length,
                          );
                          final randomTopic = section.topics[topicIndex];

                          return Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                  left: 5,
                                  bottom: 0,
                                ),
                                dense: true,
                                title: Text(
                                  section.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFF5CA99F),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Color(0XFFFFFFFF),
                                      size: 30,
                                    ),
                                  ),
                                ),

                                onTap: () {
                                  setState(() {
                                    isExpanded
                                        ? _expandedSections.remove(index)
                                        : _expandedSections.add(index);
                                  });
                                },
                              ),
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 300),
                                crossFadeState:
                                    isExpanded
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                firstChild: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  elevation: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      section.paid
                                          ? ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "This Information is paid!",
                                              ),
                                            ),
                                          )
                                          : GoRouter.of(context).pushNamed(
                                            'topic-detail',
                                            extra: TopicDetailArgs(
                                              topics: section.topics,
                                              initialIndex: topicIndex,
                                            ),
                                          );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              11,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(_images[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              11,
                                            ),
                                            color:
                                                !section.paid
                                                    ? Color(0X80000000)
                                                    : Color(0XB2000000),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 12,
                                                        right: 20,
                                                      ),
                                                  child:
                                                      section.paid
                                                          ? ImageIcon(
                                                            size: 20,
                                                            color: Colors.white,
                                                            AssetImage(
                                                              "assets/images/icons/lock-icon.png",
                                                            ),
                                                          )
                                                          : const SizedBox.shrink(),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 35,
                                                  left: 20,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      randomTopic.title,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      randomTopic.tagLine,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                secondChild: const SizedBox.shrink(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
