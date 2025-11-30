import 'package:flutter/material.dart';

class ConceptDetailScreen extends StatelessWidget {
  final String conceptName;

  const ConceptDetailScreen({Key? key, required this.conceptName}) : super(key: key);

  Map<String, dynamic> get conceptDetails {
    // Fake data - replace with real data later
    final data = {
      'Solar System': {
        'description': 'The Solar System is the gravitationally bound system of the Sun and the objects that orbit it, either directly or indirectly.',
        'keyFacts': [
          'Contains 8 planets orbiting the Sun',
          'Formed 4.6 billion years ago',
          'Located in the Milky Way galaxy'
        ],
        'category': 'Astronomy',
        'difficulty': 'Beginner',
      },
      'Human Heart': {
        'description': 'The human heart is a muscular organ that pumps blood through the blood vessels of the circulatory system.',
        'keyFacts': [
          'Has four chambers: two atria and two ventricles',
          'Beats about 100,000 times per day',
          'Pumps about 7,500 liters of blood daily'
        ],
        'category': 'Biology',
        'difficulty': 'Intermediate',
      },
      // Add more concepts as needed
    };

    return data[conceptName] ?? {
      'description': 'Learn about $conceptName through interactive 3D models and animations.',
      'keyFacts': [
        'Interactive 3D visualization',
        'AR-enabled learning experience',
        'Detailed anatomical/structural view'
      ],
      'category': 'General',
      'difficulty': 'Beginner',
    };
  }

  @override
  Widget build(BuildContext context) {
    final details = conceptDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text('Concept Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.view_in_ar, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    conceptName,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          details['category'],
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          details['difficulty'],
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Description
            Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              details['description'],
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            SizedBox(height: 24),

            // Key Facts
            Text(
              'Key Facts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...details['keyFacts'].map<Widget>((fact) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(child: Text(fact)),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 32),

            // AR Action Button
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.visibility),
                label: Text('View in AR'),
                onPressed: () {
                  Navigator.pop(context); // Go back to AR view
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}