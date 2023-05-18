import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onCliked;
  final bool isEdit;
  const ProfileWidget({
    super.key,
    required this.imagePath,
    this.isEdit = false,
    required this.onCliked,
    // required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath != ''
        ? imagePath
        : 'https://th.bing.com/th/id/OIP.JFDaKNBPBXmO8AgZETnEMAHaE7?pid=ImgDet&rs=1');
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 120.w,
          height: 100.h,
          child: InkWell(
            onTap: onCliked,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) {
    return buildCircle(
        all: 3,
        color: Colors.white,
        child: buildCircle(
            child: Icon(
              isEdit ? Icons.add_a_photo : Ionicons.camera_outline,
              color: Colors.white,
              size: 20,
            ),
            all: 8,
            color: color));
  }

  Widget buildCircle(
      {required Widget child, required double all, required Color color}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
