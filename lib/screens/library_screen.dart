import 'package:flutter/material.dart';
import 'ar_view_screen.dart';
import '../models/fake_data.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'All';

  final List<String> categories = ['All', 'Astronomy', 'Biology', 'Chemistry', 'Geography', 'Physics'];

  List<LearningTopic> get filteredTopics {
    if (_selectedCategory == 'All') {
      return [...FakeData.featuredTopics, ...FakeData.recentTopics];
    }
    return [...FakeData.featuredTopics, ...FakeData.recentTopics]
        .where((topic) => topic.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Library'),
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8, top: 16, bottom: 16),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Topics List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredTopics.length,
              itemBuilder: (context, index) {
                final topic = filteredTopics[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[50],
                      child: Icon(Icons.view_in_ar, color: Colors.blue),
                    ),
                    title: Text(
                      topic.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(topic.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            topic.category,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                              builder: (context) => ARViewScreen(
                          topicName: topic.name,                    // FIX: Change conceptName to topicName
                          topicDescription: topic.description,    ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
