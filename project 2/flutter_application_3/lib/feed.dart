import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'dart:io';

class FeedPage extends StatefulWidget {
  final String? category;

  const FeedPage({super.key, this.category});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final TextEditingController _textController = TextEditingController();
  late Box feedBox;

  @override
  void initState() {
    super.initState();
    feedBox = Hive.box('feedBox');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submitPost() {
    if (_image != null && _textController.text.isNotEmpty) {
      var feeds = feedBox.get(widget.category, defaultValue: []);
      feeds.add({
        'imagePath': _image!.path,
        'text': _textController.text,
      });
      feedBox.put(widget.category, feeds);

      setState(() {
        _image = null;
        _textController.clear();
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post submitted!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image and write something.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var feeds = feedBox.get(widget.category, defaultValue: []);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category ?? 'Feed Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showEditDialog(context);
            },
          ),
        ],
      ),
      body: feeds.isEmpty
          ? const Center(child: Text('No posts yet.'))
          : ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (context, index) {
                var feed = feeds[index];
                return FeedItem(
                  image: File(feed['imagePath']),
                  text: feed['text'],
                );
              },
            ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo),
                      )
                    : Image.file(
                        _image!,
                        width: 100,
                        height: 100,
                      ),
              ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: 'Write something...'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class FeedItem extends StatelessWidget {
  final File? image;
  final String text;

  const FeedItem({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null) Image.file(image!, width: 100, height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
