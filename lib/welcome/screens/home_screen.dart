import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/welcome/controller/home_controller.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/welcome/widgets/custom_check_box.dart';
import 'package:notizen/welcome/widgets/timer_section_widget.dart';
import 'package:notizen/widgets/custom_button_two_icons.dart';
import 'package:notizen/widgets/loader.dart';
import 'package:notizen/widgets/main_layout.dart';
import 'package:gradient_borders/gradient_borders.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HurdleOverviewScreenState();
}

class _HurdleOverviewScreenState extends ConsumerState<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    return MainLayout(
      currentIndex: 0,
      onTabChanged: (index) {
        onTabChanged(context)(index);
      },
      child:
          state.isLoading
              ? Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCard(
                        title: 'Time until sleeping at night',
                        child: TimerDisplay(
                          sleepTime: state.sleepTime ?? DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildHurdleOfTheDay(state),
                      const SizedBox(height: 24),
                      _buildSolvedProgress(state),
                      const SizedBox(height: 24),
                      _buildUpcomingHurdles(state),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtonTwoIcons(
                            text: "General Info",
                            onPressed: () {
                              GoRouter.of(context).push('/general-info');
                            },
                          ),
                          const SizedBox(width: 16),
                          CustomButtonTwoIcons(
                            leftIcon: ImageIcon(
                              AssetImage(
                                'assets/images/icons/sleep-coach-icon.png',
                              ),
                              color: Colors.white,
                              size: 20,
                            ),
                            text: "Sleep Coach",
                            onPressed: () {
                              GoRouter.of(
                                context,
                              ).push('/home-with-subscription');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: const Color(0X1A5CA99F),
        borderRadius: BorderRadius.circular(11),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildHurdleOfTheDay(HomeState state) {
    final hurdle = state.dailyHurdle;
    if (hurdle == null) return const SizedBox();

    return GestureDetector(
      onTap:
          () => {
            GoRouter.of(context).pushNamed(
              'hurdleDetail',
              pathParameters: {'id': hurdle.id},
              extra: hurdle,
            ),
          },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: const Color(0X1A5CA99F),
          borderRadius: BorderRadius.circular(11),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Hurdle of the day",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(
                    width: 20,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Color(0X80FFFFFF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                hurdle.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                hurdle.description,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Color(0X80FFFFFF),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSolvedProgress(HomeState state) {
    final solved = state.solved?.length ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: const Color(0X1A5CA99F),
        borderRadius: BorderRadius.circular(11),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress how many hurdles are yet solved',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  color: Color(0XFF5CA99F),
                  value: solved > 0 ? state.completedHurdles / solved : 0,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${state.completedHurdles}/$solved',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),

          ListView.separated(
            padding: EdgeInsets.only(left: 0),
            shrinkWrap: true,
            itemCount: state.solved!.length,
            separatorBuilder:
                (context, index) =>
                    Divider(height: 1, thickness: 1, color: Color(0X33DBDBDB)),
            itemBuilder: (context, index) {
              return CustomCheckbox(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    'hurdleDetail',
                    pathParameters: {'id': state.solved![index].id},
                    extra: state.solved![index],
                  );
                },
                fieldKey: state.status[state.solved![index].id].toString(),
                title: state.solved![index].title,
                fieldValue: "completed",
                checkboxRadius: 15,
                iconSize: 18,
                mainContainerPadding: EdgeInsets.symmetric(vertical: 16),
                strikethrough: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingHurdles(HomeState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: const Color(0X1A5CA99F),
        borderRadius: BorderRadius.circular(11),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How many to come',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          ...state.unsolved!.map(
            (h) => Container(
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF40377B), Color(0xFF252141)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: const GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [Color(0XFF252141), Color(0XFF6256B1)],
                  ),
                  width: 1,
                ),
              ),
              margin: const EdgeInsets.only(top: 12),

              child: ListTile(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    'hurdleDetail',
                    pathParameters: {'id': h.id},
                    extra: h,
                  );
                },
                contentPadding: EdgeInsets.only(right: 0, left: 16),
                title: Text(
                  h.title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                      'hurdleDetail',
                      pathParameters: {'id': h.id},
                      extra: h,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
