import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onClicked;
  final String? avatar;

  const ProfilePicWidget({
    Key? key,
    required this.avatar,
    this.imagePath,
    required this.onClicked,
  }) : super(key: key);

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
    return buildCircle(
      all: 6,
      color: const Color(0xFF43829c),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: imagePath != null
              ? Image.network(imagePath!,
                  fit: BoxFit.cover,
                  width: 152,
                  height: 152, loadingBuilder: (BuildContext context,
                      Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 152,
                    height: 152,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.green,
                      ),
                    ),
                  );
                })
              : Image.asset(
                  'assets/raw_profile_pic.png',
                  fit: BoxFit.cover,
                  width: 152,
                  height: 152,
                ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 5,
          child: const Icon(
            CupertinoIcons.camera_fill,
            color: Colors.white,
            size: 17,
          ),
        ),
      );

  Widget buildCircle(
          {required Widget child, required double all, required Color color}) =>
      InkWell(
        onTap: onClicked,
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
          ),
        ),
      );
}

class ProfilePicWidgetForLoading extends StatelessWidget {
  const ProfilePicWidgetForLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
        ],
      ),
    );
  }

  Widget buildImage() {
    return buildCircle(
      all: 6,
      color: const Color(0xFF43829c),
      child: const ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget buildCircle(
          {required Widget child, required double all, required Color color}) =>
      InkWell(
        onTap: null,
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            color: color,
            child: child,
          ),
        ),
      );
}
