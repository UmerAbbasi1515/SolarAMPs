import 'package:flutter/material.dart';

class UnEditableProfilePicWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final String? avatar;

  const UnEditableProfilePicWidget({
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
    // ignore: unused_local_variable
    ImageProvider image = const AssetImage('assets/raw_profile_pic.png');
    if(avatar!=null){
      try{
        image = NetworkImage('http://35.230.141.143/solo/storage/app/resources/assets/media/useravatar/$avatar');
      } on Exception{
        image = const AssetImage('assets/raw_profile_pic.png');
      }

    } else{
      //  image = NetworkImage(imagePath);
      image = const AssetImage('assets/raw_profile_pic.png');
    //  image = const CircleAvatar()
    }

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child:
        /*FadeInImage.assetNetwork(
          placeholder: 'assets/raw_profile_pic.png',
          image: 'http://35.230.141.143/solo/storage/app/resources/assets/media/useravatar/$avatar',
          fit: BoxFit.cover,
          width: 64,
          height: 64,
        ),*/
          /*Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 64,
          height: 64,
          child: InkWell(onTap: onClicked),
        ),*/
        Image.network('http://35.230.141.143/solo/storage/app/resources/assets/media/useravatar/$avatar',fit: BoxFit.cover,
            width: 64,
            height: 64,
          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ?
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: const Icon(
        Icons.edit,
        color: Colors.white,
        size: 10,
      ),
    ),
  );

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