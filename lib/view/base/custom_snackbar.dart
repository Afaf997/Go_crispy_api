import 'package:flutter/material.dart';

class CustomNotificationOverlay {
  static void show(BuildContext context, {required String message, NotificationType type = NotificationType.error}) {
    Color bgColor;
    IconData iconData;
    String title;

    switch (type) {
      case NotificationType.error:
        bgColor = Colors.red;
        iconData = Icons.error;
        title = 'Oh snap!';
        break;
      case NotificationType.success:
        bgColor = const Color.fromARGB(255, 52, 120, 54); 
        iconData = Icons.check_circle;
        title = 'Well done!';
        break;
      case NotificationType.warning:
        bgColor = Colors.amber;
        iconData = Icons.warning;
        title = 'Warning!';
        break;
    }

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 90.0, // Adjusted to start from the top
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: _CustomNotification(
            message: message,
            bgColor: bgColor,
            iconData: iconData,
            title: title,
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}


class _CustomNotification extends StatelessWidget {
  final String message;
  final Color bgColor;
  final IconData iconData;
  final String title;

  _CustomNotification({required this.message, required this.bgColor, required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.white,
          ),
         const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  message,
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                  maxLines: 2, // Adjust this value based on your needs
                  overflow: TextOverflow.ellipsis, // Handles overflow
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


enum NotificationType {
  error,
  success,
  warning,
}

// Usage
void showCustomNotification(BuildContext context, String message, {NotificationType type = NotificationType.error}) {
  CustomNotificationOverlay.show(context, message: message, type: type);
}
