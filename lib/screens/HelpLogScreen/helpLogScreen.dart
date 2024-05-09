import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HelpRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentUserPhoneNumber(),
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('User not authenticated.'),
          );
        }
        return LogScreenBody(phoneNumber: snapshot.data!);
      },
    );
  }

  Future<String?> _getCurrentUserPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.phoneNumber;
    }
    return null;
  }
}

class LogScreenBody extends StatefulWidget {
  final String phoneNumber;

  const LogScreenBody({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _LogScreenBodyState createState() => _LogScreenBodyState();
}

class _LogScreenBodyState extends State<LogScreenBody> {
  late StreamSubscription<QuerySnapshot> _streamSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    // Initialize stream subscription
    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.phoneNumber)
        .collection('logsForEmergencyContact')
        .snapshots()
        .listen((QuerySnapshot event) {
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          // New document added, show notification
          _showNotification();
        }
      });
    });

    // Initialize notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initNotifications();

    // Fetch and print device token
    _fetchAndPrintDeviceToken();
  }

  @override
  void dispose() {
    _streamSubscription.cancel(); // Cancel subscription to prevent memory leaks
    super.dispose();
  }

  // Function to initialize notifications
  Future<void> _initNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      // Handle notification tap event
      // Here you can cancel the notification
      await flutterLocalNotificationsPlugin.cancel(0);
      // You can add more logic if needed
    });
  }

  // Function to show notification
  Future<void> _showNotification() async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'channel_ID',
        'channel name',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'New Notification',
        'Notification message',
        RepeatInterval.everyMinute, // Use RepeatInterval.minute for repeating every minute
        platformChannelSpecifics,
        payload: 'New Notification', // Add payload if needed
      );
      print('Notification shown successfully');
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  // Function to fetch and print device token
  Future<void> _fetchAndPrintDeviceToken() async {
    try {
      final deviceTokenSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.phoneNumber)
          .collection('deviceToken')
          .doc(widget.phoneNumber)
          .get();

      if (deviceTokenSnapshot.exists) {
        final deviceToken = deviceTokenSnapshot.data()?['token'];
        if (deviceToken != null) {
          print('Device token printed: $deviceToken');
        } else {
          print('Device token not found.');
        }
      } else {
        print('Device token document does not exist.');
      }
    } catch (e) {
      print('Error fetching device token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Records'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.phoneNumber)
            .collection('logsForEmergencyContact')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text('No logs found for your emergency contact.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var log =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>?;

              if (log == null) {
                // Handle the case where log is null
                return const SizedBox.shrink(); // or any other fallback widget
              }

              var mediaUrl = log['mediaLink'] as String?;
              var address = log['address'] as String?;
              var type = log['type'] as String?;

              Widget mediaWidget;

              if (type == 'image' && mediaUrl != null && mediaUrl.isNotEmpty) {
                mediaWidget = GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Image.network(
                            mediaUrl,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    mediaUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                );
              } else if (type == 'video' &&
                  mediaUrl != null &&
                  mediaUrl.isNotEmpty) {
                mediaWidget = VideoWidget(videoUrl: mediaUrl);
              } else {
                mediaWidget = const SizedBox.shrink();
              }

              return ListTile(
                title: Text('Type: $type'),
                subtitle: Text('Address: $address'),
                leading: mediaWidget,
              );
            },
          );
        },
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading video');
                  } else {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  }
                },
              ),
            );
          },
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9, // or set as per your video aspect ratio
            child: VideoPlayer(_controller),
          ),
          const Icon(
            Icons.play_circle_filled,
            size: 50,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
