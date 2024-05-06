import 'package:flutter/material.dart';

class ViewRecipientProfilePicWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final String? avatar;

  const ViewRecipientProfilePicWidget({
    Key? key,
    required this.avatar,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          /*Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),*/
        ],
      ),
    );
  }

  Widget buildImage() {
    if (avatar != null) {
      return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Image.network(
              'http://35.230.141.143/solo/storage/app/resources/assets/media/useravatar/$avatar',
              fit: BoxFit.cover,
              width: 100,
              height: 100, loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }),
        ),
      );
    } else {
      return ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: const AssetImage('assets/raw_profile_pic.png'),
            fit: BoxFit.cover,
            width: 64,
            height: 64,
            child: InkWell(onTap: onClicked),
          ),
        ),
      );
    }
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
