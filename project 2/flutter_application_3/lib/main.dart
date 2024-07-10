import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'feed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('feedBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Column(
              children: [
                const Text('웅덕방'),
                Text(
                  '영웅이 덕질 방(?)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: const MyHomePage(),
      ),
      routes: {
        '/feed': (context) => const FeedPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '인기글',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: FeedList(category: '인기글'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '영웅이 보고 왔어요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: FeedList(category: '영웅이 보고 왔어요'),
          ),
        ],
      ),
    );
  }
}

class FeedList extends StatelessWidget {
  final String category;

  const FeedList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    var feedBox = Hive.box('feedBox');
    var feeds = feedBox.get(category, defaultValue: []);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: feeds.length + 1,
      itemBuilder: (context, index) {
        if (index == feeds.length) {
          return MoreButton(category: category);
        }
        var feed = feeds[index];
        return FeedItem(image: File(feed['imagePath']), text: feed['text']);
      },
    );
  }
}

class MoreButton extends StatelessWidget {
  final String category;

  const MoreButton({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedPage(category: category),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.all(8.0),
        child: const Center(
          child: Text(
            '더 보기',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
