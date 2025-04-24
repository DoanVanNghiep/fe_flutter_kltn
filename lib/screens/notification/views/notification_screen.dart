import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart'; // Cập nhật đúng path nếu cần
import 'package:vnua_service/route/route_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentIndex = 2;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, homeScreenRoute);
        break;
      case 1:
        Navigator.pushNamed(context, motelSearchRoute);
        break;
      case 3:
        Navigator.pushNamed(context, notificationOptionsScreenRoute);
        break;
      case 4:
        Navigator.pushNamed(context, profileScreenRoute);
        break;
    }
  }

  final List<NotificationItem> notifications = [
    NotificationItem(
      userName: "Nguyễn Văn A",
      message: "đã thích bài viết của bạn.",
      time: "2 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=1",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    NotificationItem(
      userName: "Trần Thị B",
      message: "đã bình luận: 'Hay quá!'",
      time: "5 phút trước",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),

    // Thêm nhiều dữ liệu khác nếu muốn
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông báo")),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(notification: notifications[index]);
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class NotificationItem {
  final String userName;
  final String message;
  final String time;
  final String avatarUrl;

  NotificationItem({
    required this.userName,
    required this.message,
    required this.time,
    required this.avatarUrl,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(notification.avatarUrl),
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: notification.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " ${notification.message}",
              ),
            ],
          ),
        ),
        subtitle: Text(notification.time),
        trailing: const Icon(Icons.more_horiz),
      ),
    );
  }
}
