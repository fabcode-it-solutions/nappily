import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/baby-profile/controller/baby_profile_controller.dart';
import 'package:notizen/features/baby-profile/widgets/profile_picture_widget.dart';
import 'package:notizen/widgets/custom_button_widget.dart';
import 'package:notizen/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class BabyProfileScreen extends StatelessWidget {
  const BabyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = BabyProfileController();
        controller.loadProfileData(context);
        return controller;
      },
      child: Scaffold(
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
            'Baby Profile',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<BabyProfileController>(
          builder: (context, controller, _) {
            return Container(
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
              child:
                  controller.isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0XFF5CA99F),
                        ),
                      )
                      : Center(
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 60),
                                GestureDetector(
                                  onTap: () => {controller.pickImage()},
                                  child: ProfilePictureWidget(
                                    profileImageUrl:
                                        'assets/images/baby-default.png',
                                    svgIconUrl:
                                        'assets/images/image-upload.svg',
                                    base64Img: controller.base64Image ?? "",
                                  ),
                                ),
                                const SizedBox(height: 30),
                                CustomTextField(
                                  controller: controller.nameController,
                                  placeholder: 'Baby Name',
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 20),
                                CustomButtonWidget(
                                  buttonPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 22,
                                  ),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2020),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      controller.dob = picked;
                                      controller.toggleDob(picked);
                                    }
                                  },
                                  buttonTextAlign: Alignment.centerLeft,
                                  isOutlined: true,
                                  buttonFontWeight: FontWeight.w400,
                                  buttonTextSize: 12,
                                  text:
                                      controller.dob == null
                                          ? 'Baby Date of Birth'
                                          : '${controller.dob!.day}/${controller.dob!.month}/${controller.dob!.year}',
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller:
                                      controller.prefersSleepTimeDisabled,
                                  placeholder:
                                      'Do you have a preferred sleeping time?',
                                  enabled: false,
                                  fontSize: 12,
                                ),
                                Row(
                                  children: [
                                    _buildSquareRadio(
                                      context,
                                      title: "Yes",
                                      value: true,
                                      groupValue: controller.prefersSleepTime,
                                      onChanged:
                                          (val) => controller
                                              .togglePrefersSleep(val!),
                                    ),
                                    const SizedBox(width: 12),
                                    _buildSquareRadio(
                                      context,
                                      title: "No",
                                      value: false,
                                      groupValue: controller.prefersSleepTime,
                                      onChanged:
                                          (val) => controller
                                              .togglePrefersSleep(val!),
                                    ),
                                  ],
                                ),
                                if (controller.prefersSleepTime)
                                  const SizedBox(height: 10),
                                if (controller.prefersSleepTime)
                                  // CustomTextField(
                                  //   controller: controller.sleepTimeController,
                                  //   placeholder: 'What time is it?',
                                  //   fontSize: 12,
                                  // ),
                                  InkWell(
                                    onTap:
                                        () => showTimePicker(
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          context: context,
                                          initialTime:
                                              controller.sleepTime ??
                                              TimeOfDay.now(),
                                        ).then((value) {
                                          if (value != null) {
                                            controller.updateSleepTime(value);
                                          }
                                        }),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 9.5,
                                        ),
                                        child: Text(
                                          controller.sleepTime == null
                                              ? 'What time is it?'
                                              : '${controller.sleepTime!.hour}:${controller.sleepTime!.minute}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: controller.napsController,
                                  placeholder:
                                      'How many naps does your baby hold per day?',
                                  keyboardType: TextInputType.number,
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 30),
                                CustomButtonWidget(
                                  text: 'Save',
                                  backgroundColor: Color(0XFF5CA99F),
                                  onPressed: () async {
                                    try {
                                      await controller.submitProfile(context);
                                      if (context.mounted) {
                                        GoRouter.of(context).pop();
                                      }
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSquareRadio(
    BuildContext context, {
    required String title,
    required bool value,
    required bool groupValue,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              size: 20,
              groupValue == value
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: groupValue == value ? Color(0XFF5CA99F) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
