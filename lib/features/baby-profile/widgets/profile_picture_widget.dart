import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String profileImageUrl;
  final String svgIconUrl;
  final String base64Img;
  const ProfilePictureWidget({
    super.key,
    required this.profileImageUrl,
    required this.svgIconUrl,
    this.base64Img = "",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Color(0XFF5CA99F),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(90),
                child:
                    base64Img != ""
                        ? Image.memory(
                          base64Decode(base64Img),
                          fit: BoxFit.cover,
                        )
                        : Image.asset(profileImageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0XFF5CA99F),
                borderRadius: BorderRadius.circular(50),
              ),
              child: SvgPicture.asset(svgIconUrl, height: 22, width: 22),
            ),
          ),
        ],
      ),
    );
  }
}
